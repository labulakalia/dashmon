# Flutter Hot Reload

A minimalistic CLI tool to run Flutter applications and auto hot reload it when files are changed. It will watch changes your application code and trigger a hot reload everytime a change happens.

## Install

```
$ flutter pub global activate --source git https://github.com/labulakalia/flutter_hot_reload
```

## Running

To run flutter_hot_reload, just change the `flutter run` command to `flutter_hot_reload`:

```
$ flutter_hot_reload
```

All arguments passed to it will be proxied to the `flutter run` command, so if you want to run on a specific device, the following command can be used:

```
$ flutter_hot_reload -d emulator-5555
```

You can also use attach command to attach to existing running Flutter instance:

```
flutter_hot_reload attach
```

All arguments are passed like with `run` command

## FVM support

Flutter Hot Reload supports [fvm](https://github.com/leoafarias/fvm) out of the box. Assuming that you have `fvm` installed on your computer, to run flutter_hot_reload using fvm under the hood, just pass `--fvm` to it:

```
$ flutter_hot_reload --fvm
```

Suggestions and feedback are welcomed!
