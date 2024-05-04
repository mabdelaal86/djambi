# Djambi

[![License](https://img.shields.io/github/license/mabdelaal86/djambi)](LICENSE)
![Language](https://img.shields.io/github/languages/top/mabdelaal86/djambi)
[![Powered by Flame](https://img.shields.io/badge/Powered%20by-%F0%9F%94%A5-orange.svg)](https://flame-engine.org)

An implementation of [Djambi](https://en.wikipedia.org/wiki/Djambi) board game.

More details about the rules: https://www.djambi.net/

<img src="docs/assets/screenshot.png" width="400px">


## Roadmap

- [x] Simple AI algorithm.
- [x] Undo last play is missing.
- [x] Implement traitors when chief is surrounded
- [ ] Improve the AI algorithm
- [ ] Display an end of game message
- [ ] Stop the game when no player is able to kill an other players'chief.
- [ ] Save game state.
- [ ] Complete GUI with Home page and Settings page.

corrections:
- if surrounded then definitely dead
- other pieces invulnerable
- if necromobile here, no surrounding possible
- solve bug, when someone is leaving the power, he should not have 2 turns

## License

This project is license under a [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.html) license.

Images of [pieces](./flutter/assets/classic) are based on Djambi classic theme create by [Rsalen](https://commons.wikimedia.org/wiki/User:Rsalen).


## Personal Readme.

- Open game to 3, 4 and 6 players. Rules are differents.
- For 6 players (and maybe 4), rules can be set in "advanced".
--> diplo, necro, killer and reporter see their moves evolving.
- In the menu:
- in the settings: 
    - nb players (3, 4, 6, 6-advanced)
    - IA difficulty (easy, medium, hard)
- personal space:
    - pseudo/name
    - Elo (for each mode)
- game local on the phone (no elo involved)/train/local game
- game on remote (elo involved)/start/remote game