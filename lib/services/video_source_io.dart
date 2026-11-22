import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

Future<VideoPlayerController> createVideoController(Uint8List bytes, String name) async {
  final dir = await getTemporaryDirectory();
  final file = File(p.join(dir.path, name));
  await file.writeAsBytes(bytes, flush: true);
  return VideoPlayerController.file(file);
}

