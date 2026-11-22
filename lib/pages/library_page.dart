import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../app_state.dart';
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

class _Vault {
  final DbStats stats;
  final List<MediaRef> media;
  const _Vault(this.stats, this.media);
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late final Future<_Vault> _future = _load();

  Future<_Vault> _load() async => _Vault(await Db.stats(), await Db.allMedia());

  String _kb(int b) => b >= 1048576 ? '${(b / 1048576).toStringAsFixed(2)} MB' : '${(b / 1024).toStringAsFixed(1)} KB';

  @override
  Widget build(BuildContext context) => PageShell(
        title: 'Archive',
        crumbs: const [Crumb('Home', Routes.home), Crumb('Archive')],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeading('Archive', subtitle: 'Everything stored in saas.db', size: 28),
            const GifStackCarousel(),
            const SizedBox(height: 12),
            AsyncBody<_Vault>(
              future: _future,
              builder: (context, v) {
                final s = v.stats;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppFrame(
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 24,
                        runSpacing: 14,
                        children: [
                          _stat('TEXT PAGES', '${s.pages}', _kb(s.textBytes)),
                          _stat('JPG', '${s.jpg}', 'images'),
                          _stat('GIF', '${s.gif}', 'animations'),
                          _stat('MP4', '${s.mp4}', 'videos'),
                          _stat('MEDIA', _kb(s.mediaBytes), 'as BLOBs'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    RetroDesktopCard(
                      title: 'Appearance',
                      child: ListenableBuilder(
                        listenable: AppState.theme,
                        builder: (context, _) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RetroDesktopSelect<String>(
                              label: 'Palette',
                              value: '${AppState.preset.value}',
                              options: [
                                for (var i = 0; i < themePresets.length; i++) RetroDesktopOption('$i', themePresets[i].label),
                              ],
                              onChanged: (value) => AppState.preset.value = int.parse(value as String),
                            ),
                            const SizedBox(height: 10),
                            RetroDesktopSelect<String>(
                              label: 'UI type',
                              value: AppState.chisel.value ? 'ui-01' : 'ui-02',
                              options: const [
                                RetroDesktopOption('ui-01', 'UI-01'),
                                RetroDesktopOption('ui-02', 'UI-02'),
                              ],
                              onChanged: (value) => AppState.chisel.value = value == 'ui-01',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    RetroDesktopCard(
                      title: 'Media table',
                      child: RetroDesktopWell(
                        child: RetroDesktopList(
                          children: [
                            for (final m in v.media)
                              RetroDesktopListTile(
                                title: m.name,
                                subtitle: '${m.kind.toUpperCase()} \u00B7 ${m.sizeLabel} \u00B7 #${m.id}',
                                leading: m.kind == 'mp4'
                                    ? const Icon(RetroDesktopGlyphs.fileText)
                                    : SizedBox(width: 40, height: 40, child: DbImage(m.id, cacheWidth: 80)),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );

  Widget _stat(String label, String value, String note) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          txt(value, size: 26, weight: FontWeight.w700, color: AppColors.light, spacing: 2),
          txt(label, size: 11, spacing: 3),
          txt(note, size: 10, spacing: 1),
        ],
      );
}

