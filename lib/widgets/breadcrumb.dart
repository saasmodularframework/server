import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../routes.dart';
import '../theme/app_theme.dart';

class Crumb {
  final String label;

  final String? route;
  const Crumb(this.label, [this.route]);
}

class AppBreadcrumb extends StatelessWidget {
  final List<Crumb> crumbs;
  const AppBreadcrumb({super.key, required this.crumbs});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < crumbs.length; i++) {
      final c = crumbs[i];
      final last = i == crumbs.length - 1;
      if (i > 0) {
        items.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: txt('\u25C6', size: 8, color: AppColors.light),
        ));
      }
      items.add(last || c.route == null
          ? txt(c.label.toUpperCase(), size: 12, spacing: 1.5, weight: FontWeight.w700, color: AppColors.light)
          : RetroDesktopButton.text(c.label, onPressed: () => navigate(context, c.route!)));
    }
    return Semantics(
      container: true,
      label: 'Breadcrumb',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: items),
      ),
    );
  }
}

