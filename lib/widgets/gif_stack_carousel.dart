import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import '../models/product.dart';
import '../services/db_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';
import '../utils/roman.dart';
import 'async_body.dart';
import 'db_image.dart';

class _Gif {
  final MediaRef ref;
  final Uint8List bytes;
  const _Gif(this.ref, this.bytes);
}

class GifStackCarousel extends StatefulWidget {
  final String? slug;
  final Duration interval;
  const GifStackCarousel({super.key, this.slug, this.interval = const Duration(seconds: 4)});

  @override
  State<GifStackCarousel> createState() => _GifStackCarouselState();
}

class _GifStackCarouselState extends State<GifStackCarousel> {
  final _pc = PageController();
  late Future<List<_Gif>> _future;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_Gif>> _load() async {
    final slug = widget.slug;
    final refs = slug == null ? await Db.allMedia(kind: 'gif') : await Db.mediaFor(slug, 'gif');
    final gifs = <_Gif>[for (final r in refs) _Gif(r, await Db.bytes(r.id))];
    if (mounted && gifs.length > 1) _startTimer(gifs.length);
    return gifs;
  }

  void _startTimer(int count) {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted || !_pc.hasClients) return;
      _pc.animateToPage((_index + 1) % count, duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pc.dispose();
    super.dispose();
  }

  Widget _card(_Gif g, int i, int total) => Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 320,
          height: 340,
          child: AppFrame(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: DbImage(g.ref.id, fit: BoxFit.cover)),
                const SizedBox(height: 6),
                txt('${roman(i + 1)} / ${roman(total)}   ${g.ref.name}',
                    size: 11, spacing: 2, color: AppColors.light, align: TextAlign.left),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => AsyncBody<List<_Gif>>(
        future: _future,
        builder: (context, gifs) {
          if (gifs.isEmpty) return txt('No GIFs in the database yet.');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                height: 470,
                width: 340,
                child: StackedCardCarousel(
                  type: StackedCardCarouselType.fadeOutStack,
                  pageController: _pc,
                  onPageChanged: (i) => setState(() => _index = i),
                  items: [for (var i = 0; i < gifs.length; i++) _card(gifs[i], i, gifs.length)],
                ),
              ),
              ),
              txt('${gifs.length} GIFS FROM SQLITE  \u00B7  CARD ${roman(_index + 1)}',
                  size: 11, spacing: 2, color: AppColors.light, align: TextAlign.left),
            ],
          );
        },
      );
}

