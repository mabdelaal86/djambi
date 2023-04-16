import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

import '../cell.dart';
import '../common.dart';
import '../member.dart';
import '../parliament.dart';
import 'evaluation.dart';

class Node {
  Node(this.parliament, this.parent):
        depth = parent == null ? 0 : parent.depth + (parliament.isManoeuvreCompleted ? 1 : 0) {
    if (parent != null) {
      parent!.subNodes.add(this);
    }
  }

  final Parliament parliament;

  final int depth;
  final Node? parent;
  final List<Node> subNodes = [];
  Node? _bestSubNode;
  Map<Ideology, int> _evaluations = {};

  Node get bestSubNode => _bestSubNode ?? this;

  void evaluate(StateEvaluator evaluator) {
    assert(subNodes.isEmpty, "evaluate should run on leaf nodes only");
    assert(parliament.isManoeuvreCompleted, "the maneuver should be completed");
    _evaluations = { for (final p in parliament.parties) p.ideology: evaluator.evaluate(p) };
  }

  Iterable<Member> _whoCanAct() => parliament.isManoeuvreCompleted
      ? parliament.currentParty.aliveMembers
      : [parliament.actor!];

  Iterable<Tuple2<Member, Cell>> availableActions() sync* {
    for (final member in _whoCanAct()) {
      for (final cell in member.cellsToAct()) {
        yield Tuple2(member, cell);
      }
    }
  }

  void calcMaxN() {
    assert(_evaluations.isEmpty, "evaluations is expected to be empty");
    assert(subNodes.isNotEmpty, "should run on NONE leaf nodes");
    int max = -999999999999999; // just a very small number as no const for min int
    Map<Ideology, int>? evaluations;
    Node? bestSub;
    for (Node sub in subNodes) {
      int nodeValue = sub._evaluations[parliament.currentParty.ideology]!;
      int subMax = sub._evaluations.values.map((v) => nodeValue - v).sum;
      if (subMax > max) {
        max = subMax;
        evaluations = sub._evaluations;
        bestSub = sub.parliament.isManoeuvreCompleted ? sub : sub.bestSubNode;
      }
    }
    _evaluations = evaluations!;
    _bestSubNode = bestSub;
  }
}

class Tree {
  Tree(Parliament parliament, this.maxDepth): _root = Node(parliament, null);

  final Node _root;
  final int maxDepth;
  final StateEvaluator evaluator = const DefaultEvaluator();
  final Set<String> _visitedNodes = {};
  // int _level = 0; // just used for debugging

  Node get decision => _root.bestSubNode;

  void build() {
    assert(!_root.parliament.isGameFinished);
    _visitedNodes.add(_root.parliament.getSign());
    _createSubNodes(_root);
  }

  void _createSubNodes(Node node) {
    assert (node.depth <= maxDepth, "Exceed the maximum depth!");
    if (node.parliament.isGameFinished || node.depth == maxDepth) {
      node.evaluate(evaluator);
    } else {
      for (final action in node.availableActions()) {
        // _level++;
        _doAction(node, action.item1, action.item2);
        // _level--;
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
