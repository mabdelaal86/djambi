import 'package:collection/collection.dart';

import '../../common/utils.dart';
import '../cell.dart';
import '../constants.dart';
import '../enums.dart';
import '../member.dart';
import '../parliament.dart';
import 'evaluation.dart';

enum AiDifficulty {
  easy,
  medium,
  hard;

  String get title => switch (this) {
        AiDifficulty.easy => 'Easy',
        AiDifficulty.medium => 'Medium',
        AiDifficulty.hard => 'Hard',
      };

  int get depth => switch (this) {
        AiDifficulty.easy => 1,
        AiDifficulty.medium => 2,
        AiDifficulty.hard => 3,
      };
}

class Node {
  Node(this.parliament, this.parent) : depth = _newDepth(parent, parliament) {
    parent?.subNodes.add(this);
  }

  static int _newDepth(Node? parent, Parliament parliament) =>
      parent?.depth.convert(
          (d) => parliament.isManoeuvreCompleted ? d + 1 : d) ??
      0;

  final Parliament parliament;
  final int depth;
  final Node? parent;
  final List<Node> subNodes = [];
  Node? _bestSubNode;
  Map<Ideology, int> _evaluations = {};

  Node get bestSubNode => _bestSubNode ?? this;

  void evaluate(PartyEvaluation evaluateParty) {
    assert(subNodes.isEmpty, 'evaluate should run on leaf nodes only');
    assert(parliament.isManoeuvreCompleted, 'the maneuver should be completed');
    _evaluations = {
      for (final p in parliament.parties) p.ideology: evaluateParty(p)
    };
  }

  Iterable<Member> _whoCanAct() => parliament.isManoeuvreCompleted
      ? parliament.currentParty.activeMembers
      : [parliament.actor!];

  Iterable<(Member, Cell)> availableActions({required bool shuffle}) sync* {
    for (final member in _whoCanAct()) {
      if (shuffle) {
        final cells = member.cellsToAct().toList()..shuffle();
        yield* cells.map((cell) => (member, cell));
      } else {
        yield* member.cellsToAct().map((cell) => (member, cell));
      }
    }
  }

  void calcMaxN() {
    assert(_evaluations.isEmpty, 'evaluations is expected to be empty');
    assert(subNodes.isNotEmpty, 'should run on NONE leaf nodes');
    var max = Constants.minInt;
    Map<Ideology, int>? evaluations;
    Node? bestSub;
    for (final subNode in subNodes) {
      final nodeValue =
          subNode._evaluations[parliament.currentParty.ideology]!;
      final subMax =
          subNode._evaluations.values.map((v) => nodeValue - v).sum;
      if (subMax > max) {
        max = subMax;
        evaluations = subNode._evaluations;
        bestSub = subNode.parliament.isManoeuvreCompleted
            ? subNode
            : subNode.bestSubNode;
      }
    }
    _evaluations = evaluations!;
    _bestSubNode = bestSub;
  }
}

class Tree {
  Tree(Parliament parliament, this.maxDepth,
      {AiDifficulty difficulty = AiDifficulty.medium})
      : _root = Node(parliament, null),
        _difficulty = difficulty;

  final Node _root;
  final int maxDepth;
  final AiDifficulty _difficulty;
  final Set<String> _visitedNodes = {};
  int _nodesExplored = 0;

  static const _maxNodesEasy = 500;
  static const _maxNodesMedium = 2500;
  static const _maxNodesHard = 10000;

  int get _maxNodes => switch (_difficulty) {
        AiDifficulty.easy => _maxNodesEasy,
        AiDifficulty.medium => _maxNodesMedium,
        AiDifficulty.hard => _maxNodesHard,
      };

  PartyEvaluation get _evaluator => switch (_difficulty) {
        AiDifficulty.easy => defaultPartyEvaluation,
        AiDifficulty.medium => advancedPartyEvaluation,
        AiDifficulty.hard => advancedPartyEvaluation,
      };

  bool get _shuffle => _difficulty != AiDifficulty.hard;

  Node get decision => _root.bestSubNode;

  void build() {
    assert(_root.parliament.isManoeuvreCompleted,
        'the maneuver should be completed');
    assert(!_root.parliament.isGameFinished, 'the game should be still ongoing');
    _visitedNodes.add(_root.parliament.getSign());
    _createSubNodes(_root);
  }

  void _createSubNodes(Node node) {
    assert(node.depth <= maxDepth, 'exceed the maximum depth!');
    if (node.parliament.isGameFinished ||
        node.depth == maxDepth ||
        _nodesExplored >= _maxNodes) {
      node.evaluate(_evaluator);
    } else {
      for (final (member, cell)
          in node.availableActions(shuffle: _shuffle)) {
        if (_nodesExplored >= _maxNodes) break;
        _doAction(node, member, cell);
      }
      if (node.subNodes.isEmpty) {
        if (node.parent != null) {
          node.parent!.subNodes.remove(node);
        } else {
          node.evaluate(_evaluator); // fallback: evaluate root
        }
      } else {
        node.calcMaxN();
      }
    }
  }

  void _doAction(Node node, Member member, Cell cell) {
    _nodesExplored++;
    final copy = node.parliament.makeCopy();
    copy.act(member.id, cell);
    if (copy.isManoeuvreCompleted &&
        !_visitedNodes.add(copy.getSign())) {
      return; // already visited
    }
    final subNode = Node(copy, node);
    _createSubNodes(subNode);
  }
}
