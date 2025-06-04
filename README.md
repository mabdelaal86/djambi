# Djambi

[![License](https://img.shields.io/github/license/mabdelaal86/djambi)](LICENSE)
![Language](https://img.shields.io/github/languages/top/mabdelaal86/djambi)
[![Powered by Flame](https://img.shields.io/badge/Powered%20by-%F0%9F%94%A5-orange.svg)](https://flame-engine.org)

**Djambi** is a chess variant for four players designed by *Jean Anesto* in 1975.
As in chess, pieces represent real-life political roles, but in contrast,
they are inspired by modern societies instead of medieval ones.
The game pieces symbolize common sins in modern politics.
For more details, check the [game page](https://en.wikipedia.org/wiki/Djambi) on Wikipedia.

<img src="docs/assets/screenshot.png" alt="A screenshot of Djambi game">


## Known Issues

* When a Chief leave the Maze, its team still get extra turn.
* When no player can win, nothing is happen.


## Roadmap

- [x] Simple AI algorithm.
- [x] Undo last play is missing.
- [x] Show next player.
- [x] Complete GUI with Home page and Settings page.
- [ ] Detailed description about the game and its rules.
- [x] Application icon.
- [ ] Improve UI graphics.
- [ ] Save game state.
- [ ] Add two players variation.
- [ ] Improve AI algorithm.


## Architecture

The core code of the project lays inside [flutter/lib](flutter/lib) directory and it is structured as follows:

<img src="docs/assets/architecture.svg" alt="Architecture">


## License

This project is license under a [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.html) license.


## Credits

Images of [pieces](./flutter/assets/classic) are based on Djambi classic theme create by [Rsalen](https://commons.wikimedia.org/wiki/User:Rsalen).
