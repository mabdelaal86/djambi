# Djambi

An implementation of Djambi board game using Flutter framework and Flame game engine.


## Architecture

The project is structured as follows:

<img src="../docs/assets/architecture.svg" alt="Architecture">


## Run/Debug

To run the game use the command `flutter run` and select the device number from the provided list,
or provide the device id directly with `-d`/`--device-id` option (ex. `flutter run -d linux`).

For debugging, add `--debug` option.


### Run as a Web-server

To run the game as a web app from another device (ex. a mobile), use the following command to run the game as a web server:

```bash
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

Then use `http://<YOUR.IP>:8080` to access the web-server.
