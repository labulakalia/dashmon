import 'dart:io';
import 'dart:convert';

import 'package:watcher/watcher.dart';

class HotReload {
  late Process _process;
  final List<String> args;

  Future? _throttler;

  final List<String> _proxiedArgs = [];
  bool _isFvm = false;
  bool _isAttach = false;

  HotReload(this.args) {
    _parseArgs();
  }

  void _parseArgs() {
    for (String arg in args) {
      if (arg == '--fvm') {
        _isFvm = true;
        continue;
      }

      if (arg == 'attach') {
        _isAttach = true;
        continue;
      }

      _proxiedArgs.add(arg);
    }
  }

  Future<void> _runUpdate() async {
    _process.stdin.write('r');
    await Future.delayed(Duration(milliseconds: 100));
  }

  void _print(String line) {
    final trim = line.trim();
    if (trim.isNotEmpty) {
      print(trim);
    }
  }

  void _processLine(String line) {
    if (line.contains('More than one device connected')) {
      _print(
          "Dashmon found multiple devices, device choosing menu isn't supported yet, please use the -d argument");
      _process.kill();
      exit(1);
    } else {
      _print(line);
    }
  }

  void _processError(String line) {
    _print(line);
  }

  Future<void> start() async {
    _process = await (_isFvm
        ? Process.start(
            'fvm', ['flutter', _isAttach ? 'attach' : 'run', ..._proxiedArgs])
        : Process.start(
            'flutter', [_isAttach ? 'attach' : 'run', ..._proxiedArgs]));

    _process.stdout.transform(utf8.decoder).forEach(_processLine);

    _process.stderr.transform(utf8.decoder).forEach(_processError);

    var watcher = DirectoryWatcher("./lib");
    watcher.events.listen((data) {
      if (data.path.endsWith('.dart')) {
        if (_throttler == null) {
          _throttler = _runUpdate();
          _throttler?.then((_) {
            _throttler = null;
          });
        }
      }
    });

    stdin.lineMode = false;
    stdin.echoMode = false;
    stdin.transform(utf8.decoder).forEach(_process.stdin.write);
    final exitCode = await _process.exitCode;
    exit(exitCode);
  }
}
