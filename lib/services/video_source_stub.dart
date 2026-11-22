import 'dart:typed_data';

import 'package:video_player/video_player.dart';

Future<VideoPlayerController> createVideoController(Uint8List bytes, String name) =>
    throw UnsupportedError('Video playback is not supported on this platform.');

