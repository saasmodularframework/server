import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../models/product.dart';
import '../routes.dart';
import '../services/db_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';
import '../widgets/async_body.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/db_image.dart';
import '../widgets/db_video.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';
import 'not_found_page.dart';

class _Data {
  final List<Product> all;
  final Product? product;
  final List<MediaRef> gifs, videos, jpgs;
  const _Data(this.all, this.product, this.gifs, this.videos, this.jpgs);
}

class SamplePage extends StatefulWidget {
  final String slug;
  const SamplePage({super.key, required this.slug});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  late Future<_Data> _future;
  final _summary = TextEditingController();
  final _body = TextEditingController();
  int _tab = 0;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_Data> _load() async {
    final all = await Db.pages();
    final product = all.where((p) => p.slug == widget.slug).firstOrNull;
    if (product == null) return _Data(all, null, const [], const [], const []);
    _summary.text = product.summary;
    _body.text = product.body;
    return _Data(
      all,
      product,
      await Db.mediaFor(product.slug, 'gif'),
      await Db.mediaFor(product.slug, 'mp4'),
      await Db.mediaFor(product.slug, 'jpg'),
    );
  }

  @override
  void dispose() {
    _summary.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await Db.updatePageText(widget.slug, _summary.text, _body.text);
    setState(() {
      _status = 'Saved to SQLite at ${TimeOfDayLabel.now()}';
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) => PageShell(
        title: widget.slug.toUpperCase(),
        crumbs: [
          const Crumb('Home', Routes.home),
          const Crumb('About SaaS Products', Routes.about),
          Crumb(widget.slug.toUpperCase()),
        ],
        child: AsyncBody<_Data>(
          future: _future,
          builder: (context, d) {
            final p = d.product;
            if (p == null) return const NotFoundBody();
            final i = d.all.indexOf(p);
            final prev = d.all[(i - 1 + d.all.length) % d.all.length];
            final next = d.all[(i + 1) % d.all.length];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppHeading(p.display, subtitle: '${p.versionLabel}  ${p.copyright}', size: 28),
                Center(child: Wrap(spacing: 6, runSpacing: 6, children: [for (final t in p.tags) AppTag(t)])),
                const SizedBox(height: 16),
                AppFrame(
                  padding: const EdgeInsets.all(6),
                  child: SizedBox(height: 220, child: DbImage(d.jpgs.isEmpty ? p.heroId : d.jpgs.first.id)),
                ),
                const SizedBox(height: 16),
                GifStackCarousel(slug: p.slug),
                const SizedBox(height: 12),
                RetroDesktopTabBar(
                  tabs: const ['Overview', 'Video', 'Database'],
                  selectedIndex: _tab,
                  onChanged: (index) => setState(() => _tab = index),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: switch (_tab) {
                      0 => _overview(p),
                      1 => d.videos.isEmpty ? txt('No MP4 stored for this page.') : DbVideo(media: d.videos.first),
                      _ => _database(p, d),
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    RetroDesktopButton('\u25C0  ${prev.title}', onPressed: () => navigate(context, Routes.page(prev.slug))),
                    RetroDesktopButton('${next.title}  \u25B6',
                        isDefaultAction: true, onPressed: () => navigate(context, Routes.page(next.slug))),
                  ],
                ),
              ],
            );
          },
        ),
      );

  Widget _overview(Product p) => AppFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            txt(p.summary, size: 16, weight: FontWeight.w700, color: AppColors.light, height: 1.4),
            const SizedBox(height: 12),
            for (final para in p.body.split('\n\n'))
              Padding(padding: const EdgeInsets.only(bottom: 10), child: txt(para, height: 1.55)),
          ],
        ),
      );

  Widget _database(Product p, _Data d) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RetroDesktopCard(
            title: 'Edit the stored text',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RetroDesktopTextField(label: 'Summary', controller: _summary),
                const SizedBox(height: 10),
                RetroDesktopTextField(label: 'Body (blank line = new paragraph)', controller: _body),
                const SizedBox(height: 12),
                RetroDesktopButton('Save', isDefaultAction: true, onPressed: _save),
                if (_status.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_status)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RetroDesktopCard(
            title: 'Media rows on this page',
            child: RetroDesktopWell(
              child: RetroDesktopList(
                children: [
                  for (final m in [...d.jpgs, ...d.videos, ...d.gifs])
                    RetroDesktopListTile(
                      title: m.name,
                      subtitle: '${m.kind.toUpperCase()} \u00B7 ${m.sizeLabel} \u00B7 media #${m.id}',
                      leading: const Icon(RetroDesktopGlyphs.fileText),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
}

class TimeOfDayLabel {
  static String now() {
    final t = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }
}

