import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';
import 'breadcrumb.dart';
import 'footer.dart';

class PageShell extends StatelessWidget {
  final String title;
  final List<Crumb> crumbs;
  final Widget child;

  const PageShell({super.key, required this.title, required this.crumbs, required this.child});

  @override
  Widget build(BuildContext context) => RetroDesktopScaffold(
        topBar: RetroDesktopAppBar(title: title),
        body: ColoredBox(
          color: AppColors.ink,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: AppBreadcrumb(crumbs: crumbs)),
                        const SizedBox(width: 12),
                        const SquareSwitcher(),
                      ],
                    ),
                    child,
                    const AppFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

