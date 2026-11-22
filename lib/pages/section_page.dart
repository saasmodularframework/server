import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../data/instances.dart';
import '../routes.dart';
import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class SectionPage extends StatelessWidget {
  final Section section;
  const SectionPage({super.key, required this.section});

  @override
  Widget build(BuildContext context) => PageShell(
        title: section.label,
        crumbs: [const Crumb('Home', Routes.home), Crumb(section.label)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeading(section.label, subtitle: 'software engineering and computer science: ${instanceSlug(1)} to ${instanceSlug(kInstanceCount)}', size: 28),
            const GifStackCarousel(),
            const SizedBox(height: 12),
            AppFrame(
              child: RetroDesktopWell(
                child: RetroDesktopList(
                  children: [
                    for (final i in Instance.all(section))
                      RetroDesktopListTile(
                        title: i.slug,
                        subtitle: '${i.title}  \u00B7  ${i.subtitle}',
                        leading: const Icon(RetroDesktopGlyphs.fileText),
                        onPressed: () => navigate(context, i.route),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

