export 'video_source_stub.dart'
    if (dart.library.io) 'video_source_io.dart'
    if (dart.library.js_interop) 'video_source_web.dart';

