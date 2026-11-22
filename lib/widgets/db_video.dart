import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';
import 'package:video_player/video_player.dart';

import '../models/product.dart';
import '../services/db_service.dart';
import '../services/video_source.dart';
import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';

class DbVideo extends StatefulWidget {
  final MediaRef media;
  const DbVideo({super.key, required this.media});

  @override
  State<DbVideo> createState() => _DbVideoState();
}

class _DbVideoState extends State<DbVideo> {
  VideoPlayerController? _c;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final bytes = await Db.bytes(widget.media.id);
      final c = await createVideoController(bytes, 'media_${widget.media.id}.mp4');
      await c.initialize();
      await c.setLooping(true);
      await c.setVolume(0);
      await c.play();
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() => _c = c);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _c;
    return AppFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          txt('${widget.media.name}  \u00B7  MP4  \u00B7  ${widget.media.sizeLabel}',
              size: 12, spacing: 1.5, color: AppColors.light),
          const SizedBox(height: 10),
          if (_error != null)
            txt('Video could not be played: $_error', height: 1.5)
          else if (c == null)
            Padding(padding: const EdgeInsets.all(40), child: Center(child: txt('LOADING REEL\u2026', spacing: 3)))
          else ...[
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: AspectRatio(aspectRatio: c.value.aspectRatio, child: VideoPlayer(c)),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: c,
                builder: (context, v, _) => RetroDesktopButton(
                  v.isPlaying ? 'Pause' : 'Play',
                  onPressed: () => v.isPlaying ? c.pause() : c.play(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

