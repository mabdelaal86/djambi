import 'package:flutter/material.dart';

import '../models/enums.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: const Text('Rules & Pieces'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < _tabs.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 6, bottom: 4),
                    child: ChoiceChip(
                      label: Text(_tabs[i].title),
                      selected: _tab == i,
                      onSelected: (_) => setState(() => _tab = i),
                    ),
                  ),
                const SizedBox(width: 6),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _tabs[_tab].build(context),
        ),
      ),
    );
  }
}

// ── Tab definitions ───────────────────────────────────────────────────────

abstract class _Tab {
  String get title;
  Widget build(BuildContext context);
}

final _tabs = <_Tab>[
  _OverviewTab(),
  _ObjectiveTab(),
  _PiecesTab(),
  _TurnTab(),
  _SpecialRulesTab(),
];

// ── Overview ──────────────────────────────────────────────────────────────

class _OverviewTab extends _Tab {
  @override
  String get title => 'Overview';

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _h1('What is Djambi?'),
          _p('Djambi is a strategic board game for four players designed by '
              'Jean Anesto in 1975. Unlike chess, all four factions share the '
              'same board simultaneously, and pieces represent political roles — '
              'spies, assassins, diplomats and reporters — scheming against each other.'),
          _p('The 9×9 board has a single central cell called the Maze '
              '(Parliament), the seat of power.'),
          _h2('The Board'),
          _p('Each faction (Red, Blue, Yellow, Green) starts with 9 pieces '
              'in one corner. Players take turns moving one piece and resolving '
              'any resulting action (kill, place body, etc.).'),
          const SizedBox(height: 12),
          // Show all 6 piece types in red as a visual preview
          _AllPiecesRow(),
        ],
      );
}

// ── Objective ─────────────────────────────────────────────────────────────

class _ObjectiveTab extends _Tab {
  @override
  String get title => 'Objective';

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _h1('How to Win'),
          _p('Occupy the Maze (center square E5) with your Chief AND be the '
              'last faction with a living Chief.'),
          _h2('Eliminating a Faction'),
          _p('When a Chief is killed, all remaining members of that faction '
              'immediately join the faction that killed the Chief.'),
          _h2('The Maze (Seat of Power)'),
          _p('The party whose Chief occupies the Maze takes an extra turn '
              'after every other player\'s turn — a massive tempo advantage.'),
          _p('A Chief in the Maze cannot be attacked directly; it can only be '
              'eliminated by surrounding (see Special Rules).'),
        ],
      );
}

// ── Pieces ────────────────────────────────────────────────────────────────

class _PiecesTab extends _Tab {
  @override
  String get title => 'Pieces';

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _h1('Piece Descriptions'),
          for (final entry in _pieceInfo.entries) ...[
            const SizedBox(height: 12),
            _PieceCard(role: entry.key, info: entry.value),
          ],
        ],
      );
}

// ── Turn ──────────────────────────────────────────────────────────────────

class _TurnTab extends _Tab {
  @override
  String get title => 'Turn Order';

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _h1('Turn Sequence'),
          _step('1', 'Select a piece',
              'Tap any highlighted piece in your colour. '
              'Valid destinations are shown.'),
          _step('2', 'Move the piece',
              'Tap a highlighted destination. If the piece lands on an enemy '
              'or dead body, a secondary action may be required.'),
          _step('3', 'Resolve the action',
              'Choose where to place a body, which adjacent enemy to kill '
              '(Reporter), or where to relocate a piece (Diplomat).'),
          _step('4', 'Turn ends',
              'Play passes to the next faction — unless the party in the '
              'Maze gets an extra turn first.'),
          const SizedBox(height: 16),
          _h2('Undo & Redo'),
          _p('Use ↩ and ↪ in the top bar to take back or replay moves.'),
          _h2('Party in Power'),
          _p('The faction whose Chief is in the Maze acts after every other '
              'player\'s turn each round.'),
        ],
      );
}

// ── Special Rules ─────────────────────────────────────────────────────────

class _SpecialRulesTab extends _Tab {
  @override
  String get title => 'Special Rules';

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _h1('Special Rules'),
          _h2('Surrounding'),
          _p('If every cell reachable from a Chief is blocked by enemies and '
              'the Chief has no active Necromobile, the Chief is eliminated '
              'without a direct attack.'),
          _h2('Paralysis'),
          _p('When a Chief is killed, all its members become paralysed '
              '(grey). They cannot act until the winning faction\'s Chief '
              'enters the Maze, absorbing them as active allies.'),
          _h2('The Maze'),
          _p('Only a Chief can enter the Maze willingly. A Diplomat can move '
              'any Chief into the Maze. Pieces inside cannot be attacked directly.'),
          _h2('Dead Bodies'),
          _p('Dead pieces stay as obstacles until moved by a Necromobile, '
              'Chief, Militant, or Assassin. Place them strategically to '
              'block paths or defend your Chief.'),
        ],
      );
}

// ── Piece data ────────────────────────────────────────────────────────────

final _pieceInfo = <Role, _PieceInfo>{
  Role.chief: _PieceInfo(
    name: 'Chief',
    count: 1,
    movement: 'Any number of squares in any of 8 directions (like a chess Queen).',
    ability: 'Kills the occupant on contact and moves that body to any empty '
        'non-Maze square. Occupying the Maze grants an extra turn each round.',
    tip: 'Your most powerful and most vulnerable piece. Rush toward the Maze '
        'for tempo, but keep Militants nearby for defense.',
  ),
  Role.assassin: _PieceInfo(
    name: 'Assassin',
    count: 1,
    movement: 'Any number of squares in any of 8 directions — MUST land on an active enemy.',
    ability: 'Kills the target instantly. Cannot move to empty squares.',
    tip: 'Long-range sniper. Threatens enemy Chiefs from across the board.',
  ),
  Role.reporter: _PieceInfo(
    name: 'Reporter',
    count: 1,
    movement: 'Any empty non-Maze square (unlimited range).',
    ability: 'After moving, may kill one orthogonally adjacent active enemy. '
        'Body stays in place.',
    tip: 'Area-control piece. Park it near enemy clusters to kill one per turn.',
  ),
  Role.diplomat: _PieceInfo(
    name: 'Diplomat',
    count: 1,
    movement: 'Any number of squares in any of 8 directions, landing on an active enemy.',
    ability: 'Does NOT kill — relocates the target to any empty square. '
        'Can move a Chief into the Maze.',
    tip: 'Eject an enemy Chief from the Maze or move it into a surrounded position.',
  ),
  Role.necromobile: _PieceInfo(
    name: 'Necromobile',
    count: 1,
    movement: 'Any number of squares in any of 8 directions, landing on a dead body.',
    ability: 'Moves a dead body to any empty non-Maze square. '
        'While active, your Chief cannot be surrounded.',
    tip: 'Use bodies to block enemy paths. The anti-surrounding protection is invaluable.',
  ),
  Role.militant: _PieceInfo(
    name: 'Militant',
    count: 4,
    movement: 'Up to 2 squares in any of 8 directions. Cannot enter the Maze.',
    ability: 'Kills on contact and moves the body to any empty non-Maze square.',
    tip: 'Workhorses. Form a defensive wall around your Chief or control center squares.',
  ),
};

class _PieceInfo {
  final String name, movement, ability, tip;
  final int count;
  const _PieceInfo({
    required this.name,
    required this.count,
    required this.movement,
    required this.ability,
    required this.tip,
  });
}

// ── Piece image widgets ───────────────────────────────────────────────────

/// Shows one pre-rendered piece PNG (colored circle with icon).
/// asset path: assets/images/pieces/{role}_{ideology}.png
class _PieceImage extends StatelessWidget {
  final Role role;
  final String ideology; // 'red' | 'blue' | 'yellow' | 'green'
  final double size;

  const _PieceImage({
    required this.role,
    this.ideology = 'red',
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/images/pieces/${role.name}_$ideology.png',
        width: size,
        height: size,
        // If image fails to load, show a colored circle fallback
        errorBuilder: (_, __, ___) => _FallbackPiece(role: role, size: size),
      );
}

/// Fallback circle with role initial if PNG fails to load.
class _FallbackPiece extends StatelessWidget {
  final Role role;
  final double size;
  const _FallbackPiece({required this.role, required this.size});

  static const _colors = {
    Role.chief:       Color(0xFF5C6BC0),
    Role.assassin:    Color(0xFFEF5350),
    Role.reporter:    Color(0xFF26A69A),
    Role.diplomat:    Color(0xFFAB47BC),
    Role.necromobile: Color(0xFF78909C),
    Role.militant:    Color(0xFFFF7043),
  };

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _colors[role],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            role.name[0].toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.45,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}

/// Row showing all 6 piece types in red, used in the Overview tab.
class _AllPiecesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final role in Role.values)
          Column(
            children: [
              _PieceImage(role: role, ideology: 'red', size: 52),
              const SizedBox(height: 4),
              Text(
                role.name[0].toUpperCase() + role.name.substring(1),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
      ],
    );
  }
}

/// Card showing piece image + all 4 color variants + description.
class _PieceCard extends StatelessWidget {
  final Role role;
  final _PieceInfo info;
  const _PieceCard({required this.role, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: 4 color variants + name ──────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Four faction-colored variants
                for (final ideology in ['red', 'blue', 'yellow', 'green'])
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _PieceImage(role: role, ideology: ideology, size: 48),
                  ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${info.count}× per faction',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            _label(context, '📐  Movement'),
            _p(info.movement),
            _label(context, '⚡  Ability'),
            _p(info.ability),
            _label(context, '💡  Strategy Tip'),
            _p(info.tip),
          ],
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 2),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      );
}

// ── Shared text helpers ────────────────────────────────────────────────────

Widget _h1(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );

Widget _h2(String text) => Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );

Widget _p(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(height: 1.5)),
    );

Widget _step(String number, String title, String body) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 14, child: Text(number)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(body, style: const TextStyle(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
