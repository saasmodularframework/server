import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../data/instances.dart';
import '../models/product.dart';
import '../routes.dart';
import '../services/db_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';
import '../widgets/async_body.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/db_image.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class InstancePage extends StatefulWidget {
  final Section section;
  final int number;
  const InstancePage({super.key, required this.section, required this.number});

  @override
  State<InstancePage> createState() => _InstancePageState();
}

class _InstancePageState extends State<InstancePage> {
  late final Future<List<MediaRef>> _jpgs = Db.allMedia(kind: 'jpg');

  Instance _at(int n) => Instance(widget.section, ((n - 1) % kInstanceCount + kInstanceCount) % kInstanceCount + 1);

  @override
  Widget build(BuildContext context) {
    final i = Instance(widget.section, widget.number);
    final prev = _at(i.number - 1), next = _at(i.number + 1);
    return PageShell(
      title: i.slug.toUpperCase(),
      crumbs: [
        const Crumb('Home', Routes.home),
        Crumb(widget.section.label, widget.section.path),
        Crumb(i.slug.toUpperCase()),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeading(i.title, subtitle: i.subtitle, size: 28),
          Center(child: Wrap(spacing: 6, runSpacing: 6, children: [for (final t in i.tags) AppTag(t)])),
          const SizedBox(height: 16),
          AppFrame(
            padding: const EdgeInsets.all(6),
            child: SizedBox(
              height: 220,
              child: AsyncBody<List<MediaRef>>(
                future: _jpgs,
                builder: (context, jpgs) => DbImage(jpgs.isEmpty ? null : jpgs[(i.number - 1) % jpgs.length].id),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const GifStackCarousel(),
          const SizedBox(height: 12),
          AppFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txt(i.summary, size: 16, weight: FontWeight.w700, color: AppColors.light, height: 1.4),
                const SizedBox(height: 12),
                for (final para in i.paragraphs)
                  Padding(padding: const EdgeInsets.only(bottom: 10), child: txt(para, height: 1.55)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            runSpacing: 8,
            children: [
              RetroDesktopButton('\u25C0  ${prev.slug}', onPressed: () => navigate(context, prev.route)),
              RetroDesktopButton('${next.slug}  \u25B6', isDefaultAction: true, onPressed: () => navigate(context, next.route)),
            ],
          ),
        ],
      ),
    );
  }
}

