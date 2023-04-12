import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../cell.dart';
import '../common.dart';
import '../member.dart';
import '../parliament.dart';
import 'evaluation.dart';

class Node {
  Node(this.parliament, this.depth);

  final Parliament parliament;
  bool get isManoeuvreCompleted => parliament.getActor() == null;

  final int depth;
  List<Node> subNodes = [];
  Node? _bestSubNode;
  Map<Ideology, int> _evaluations = {};

  Node get bestSubNode => _bestSubNode ?? this;

  void evaluate(StateEvaluator evaluator) {
    assert(subNodes.isEmpty);
    _evaluations = { for (final p in parliament.parties) p.ideology: evaluator.evaluate(p) };
  }

  void calcMaxN() {
    assert(_evaluations.isEmpty);
    assert(subNodes.isNotEmpty);
    int max = -999999999999999999;
    Map<Ideology, int>? evaluations;
    Node? bestSub;
    for (Node sub in subNodes) {
      int nodeValue = sub._evaluations[parliament.currentParty.ideology]!;
      int subMax = sub._evaluations.values.map((v) => nodeValue - v).sum;
      if (subMax > max) {
        max = subMax;
        evaluations = sub._evaluations;
        bestSub = sub.isManoeuvreCompleted ? sub : sub.bestSubNode;
      }
    }
    _evaluations = evaluations!;
    _bestSubNode = bestSub;
  }
}

class Tree {
  Tree(Parliament parliament, {this.maxDepth = 3}): _root = Node(parliament, 0);

  final Node _root;
  final int maxDepth;
  final StateEvaluator evaluator = const DefaultEvaluator();
  final Set<String> visitedNodes = {};

  Node getBest() => _root.bestSubNode;

  void build() {
    visitedNodes.add(_root.parliament.value);
    _createSubNodes(_root);
  }

  void _createSubNodes(Node node) {
    if (node.depth > maxDepth) {
      throw StateError("Exceed the maximum depth!");
    }
    final actor = node.parliament.getActor();
    if (node.parliament.isGameFinished || node.depth == maxDepth) {
      assert(actor == null);
      node.evaluate(evaluator);
      return;
    }
    // should do an action -----------------
    final members = actor != null ? [actor] : node.parliament.currentParty.movableMembers;
    for (final member in members) {
      for (final cell in member.cellsToAct()) {
        _doAction(node, member, cell);
      }
    }
    // calc max^n
    node.calcMaxN();
  }

  void _doAction(Node node, Member member, Cell cell) {
    final copyParliament = node.parliament.makeCopy();
    final copyMember = copyParliament.members[member.id];
    copyParliament.act(copyMember, cell);
    if (visitedNodes.contains(copyParliament.value)) {
      // print("skip: $member => $cell");
      return;
    }
    visitedNodes.add(copyParliament.value);
    int depth = node.depth;
    if (copyMember.manoeuvre == Manoeuvre.none) {
      depth++;
      debugPrint("${'--' * depth} do action: $member => $cell");
    }
    final subNode = Node(copyParliament, depth);
    node.subNodes.add(subNode);
    _createSubNodes(subNode);
  }
}
