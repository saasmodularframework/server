import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import '../models/product.dart';
import '../services/db_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';
import '../utils/roman.dart';
import 'async_body.dart';
import 'db_image.dart';

class JpgCarousel extends StatefulWidget {
  const JpgCarousel({super.key});

  @override
  State<JpgCarousel> createState() => _JpgCarouselState();
}

class _JpgCarouselState extends State<JpgCarousel> {
  late final Future<List<MediaRef>> _future = Db.allMedia(kind: 'jpg');

  @override
  Widget build(BuildContext context) => AsyncBody<List<MediaRef>>(
        future: _future,
        builder: (context, jpgs) {
          if (jpgs.isEmpty) return txt('No JPG images in the database yet.');
          return FlutterCarousel(
            options: FlutterCarouselOptions(
              height: 420,
              viewportFraction: 0.82,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              enableInfiniteScroll: true,
              showIndicator: true,
              slideIndicator: CircularSlideIndicator(
                slideIndicatorOptions: SlideIndicatorOptions(
                  currentIndicatorColor: AppColors.light,
                  indicatorBackgroundColor: AppColors.light.withValues(alpha: 0.3),
                ),
              ),
            ),
            items: [
              for (var i = 0; i < jpgs.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: AppFrame(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: DbImage(jpgs[i].id, fit: BoxFit.cover)),
                        const SizedBox(height: 6),
                        txt('${roman(i + 1)} / ${roman(jpgs.length)}   ${jpgs[i].name}',
                            size: 11, spacing: 2, color: AppColors.light, align: TextAlign.center),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      );
}

