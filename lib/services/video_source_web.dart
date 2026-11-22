import 'dart:js_interop';
import 'dart:typed_data';

import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

Future<VideoPlayerController> createVideoController(Uint8List bytes, String name) async {
  final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: 'video/mp4'));
  return VideoPlayerController.networkUrl(Uri.parse(web.URL.createObjectURL(blob)));
}

