import 'package:flutter_hot_reload/hot_reload.dart';

void main(List<String> args) {
  print('Starting Flutter Hot Reload...');
  final hotReload = HotReload(args);
  hotReload.start();
}
