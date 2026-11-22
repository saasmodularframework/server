import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../routes.dart';
import '../theme/app_theme.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) => const PageShell(
        title: '404',
        crumbs: [Crumb('Home', Routes.home), Crumb('404')],
        child: NotFoundBody(),
      );
}

class NotFoundBody extends StatelessWidget {
  const NotFoundBody({super.key});

  @override
  Widget build(BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GifStackCarousel(),
              const SizedBox(height: 20),
              txt('404', size: 64, color: AppColors.light, weight: FontWeight.w700, spacing: 8),
              const SizedBox(height: 8),
              txt('PAGE NOT FOUND', spacing: 4),
              const SizedBox(height: 20),
              RetroDesktopButton('Home', isDefaultAction: true, onPressed: () => navigate(context, Routes.home)),
            ],
          ),
        );
}

