import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../routes.dart';
import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8),
      child: Column(
        children: [
          const AppDivider(),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              RetroDesktopButton.text('Home', onPressed: () => navigate(context, Routes.home)),
              RetroDesktopButton.text('About SaaS Products', onPressed: () => navigate(context, Routes.about)),
              RetroDesktopButton.text('Services', onPressed: () => navigate(context, Routes.services)),
              RetroDesktopButton.text('Case Studies', onPressed: () => navigate(context, Routes.caseStudies)),
              RetroDesktopButton.text('Archive', onPressed: () => navigate(context, Routes.library)),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              for (final d in Routes.documents)
                RetroDesktopButton.text(d.$1, onPressed: () => navigate(context, d.$2)),
            ],
          ),
          const SizedBox(height: 8),
          txt('\u00A9 $year  SaaS PRODUCTS', size: 11, spacing: 3, color: AppColors.light, align: TextAlign.center),
          const SizedBox(height: 4),
          txt('Text, JPG, GIF and MP4 are stored in SQLite', size: 11, spacing: 1, align: TextAlign.center),
        ],
      ),
    );
  }
}

