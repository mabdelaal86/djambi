import 'dart:math';

import 'package:collection/collection.dart';

import '../../common/utils.dart';
import '../cell.dart';
import '../constants.dart';
import '../enums.dart';
import '../member.dart';
import '../parliament.dart';
import 'evaluation.dart';

/// Caps how many candidate actions a node explores at the root member-level.
/// Used by the "Easy" difficulty to keep it fast and intentionally short
/// sighted: instead of considering every legal move for every piece, it only
/// samples a handful, so it regularly misses good plays a stronger AI would
/// find.
typedef ActionSampler = List<(Member, Cell)> Function(List<(Member, Cell)> actions, Random random);

List<(Member, Cell)> _allActions(List<(Member, Cell)> actions, Random random) {
  actions.shuffle(random);
  return actions;
}

class Node {
  Node(this.parliament, this.parent) : depth = _newDepth(parent, parliament) {
    parent?.subNodes.add(this);
  }

  static int _newDepth(Node? parent, Parliament parliament) =>
      parent?.depth.convert((d) => parliament.isManoeuvreCompleted ? d + 1 : d) ?? 0;

  final Parliament parliament;

  final int depth;
  final Node? parent;
  final List<Node> subNodes = [];
  Node? _bestSubNode;
  Map<Ideology, int> _evaluations = {};

  Node get bestSubNode => _bestSubNode ?? this;

  void evaluate(PartyEvaluation evaluateParty) {
    assert(subNodes.isEmpty, "evaluate should run on leaf nodes only");
    assert(parliament.isManoeuvreCompleted, "the maneuver should be completed");
    _evaluations = {for (final p in parliament.parties) p.ideology: evaluateParty(p)};
  }

  Iterable<Member> _whoCanAct() =>
      parliament.isManoeuvreCompleted ? parliament.currentParty.activeMembers : [parliament.actor!];

  /// True if [cell] is currently occupied by another member, meaning acting
  /// on it is a capture/contact move rather than a quiet relocation.
  bool _isImpactfulTarget(Cell cell) => parliament.getMemberAt(cell) != null;

  Iterable<(Member, Cell)> availableActions(Random random, ActionSampler sample) {
    final actions = [
      for (final member in _whoCanAct()) for (final cell in member.cellsToAct()) (member, cell),
    ];
    // Move ordering: explore moves that interact with another piece (capture,
    // bury, exit-with-a-body, ...) before quiet ones. This makes the search
    // discover strong lines earlier, which matters once pruning/short
    // samplers are involved and keeps deeper searches more efficient.
    actions.sort((a, b) {
      final aImpact = _isImpactfulTarget(a.$2) ? 0 : 1;
      final bImpact = _isImpactfulTarget(b.$2) ? 0 : 1;
      return aImpact.compareTo(bImpact);
    });
    return sample(actions, random);
  }

  void calcMaxN() {
    assert(_evaluations.isEmpty, "evaluations is expected to be empty");
    assert(subNodes.isNotEmpty, "should run on NONE leaf nodes");
    var max = Constants.minInt;
    Map<Ideology, int>? evaluations;
    Node? bestSub;
    for (final subNode in subNodes) {
      final nodeValue = subNode._evaluations[parliament.currentParty.ideology]!;
      final subMax = subNode._evaluations.values.map((v) => nodeValue - v).sum;
      if (subMax > max) {
        max = subMax;
        evaluations = subNode._evaluations;
        bestSub = subNode.parliament.isManoeuvreCompleted ? subNode : subNode.bestSubNode;
      }
    }
    _evaluations = evaluations!;
    _bestSubNode = bestSub;
  }
}

class Tree {
  Tree(
    Parliament parliament,
    this.maxDepth, {
    PartyEvaluation? evaluateParty,
    ActionSampler? sampleActions,
    Random? random,
  }) : _root = Node(parliament, null),
       evaluateParty = evaluateParty ?? defaultPartyEvaluation,
       _sampleActions = sampleActions ?? _allActions,
       _random = random ?? Random();

  final Node _root;
  final int maxDepth;
  final PartyEvaluation evaluateParty;
  final ActionSampler _sampleActions;
  final Random _random;
  final Set<String> _visitedNodes = {};
  // int _level = 0; // just used for debugging

  Node get decision => _root.bestSubNode;

  void build() {
    assert(_root.parliament.isManoeuvreCompleted, "the maneuver should be completed");
    assert(!_root.parliament.isGameFinished, "the game should be still ongoing");
    _visitedNodes.add(_root.parliament.getSign());
    _createSubNodes(_root);
  }

  void _createSubNodes(Node node) {
    assert(node.depth <= maxDepth, "exceed the maximum depth!");
    if (node.parliament.isGameFinished || node.depth == maxDepth) {
      node.evaluate(evaluateParty);
    } else {
      for (final (member, cell) in node.availableActions(_random, _sampleActions)) {
        _doAction(node, member, cell);
      }
      if (node.subNodes.isEmpty) {
        // all sub nodes are visited
        node.parent!.subNodes.remove(node);
      } else {
        // calc max^n
        node.calcMaxN();
      }
    }
  }

  void _doAction(Node node, Member member, Cell cell) {
    // print("${'- ' * _level}do action: $member => $cell [${member.manoeuvre.name}]");
    final copy = node.parliament.makeCopy();
    copy.act(member.id, cell);
    if (copy.isManoeuvreCompleted && !_visitedNodes.add(copy.getSign())) {
      // print("${'  ' * _level}// skip");
      return;
    }
    final subNode = Node(copy, node);
    _createSubNodes(subNode);
  }
}
