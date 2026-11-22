import 'dart:async';

import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:navigation_panel/navigation_panel.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../app_state.dart';
import '../routes.dart';
import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';
import 'breadcrumb.dart';
import 'core_spiral.dart';
import 'footer.dart';

class PageShell extends StatefulWidget {
  final String title;
  final List<Crumb> crumbs;
  final Widget child;

  const PageShell({super.key, required this.title, required this.crumbs, required this.child});

  @override
  State<PageShell> createState() => _PageShellState();
}

class _PageShellState extends State<PageShell> {

  bool _ready = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0x00000000),
        floatingActionButton: EndDockedAnimatedNav(
          menuBgColor: AppColors.navy,
          menuOpenIcon: Icon(LineIcons.bars, color: AppColors.light),
          menuCloseIcon: Icon(LineIcons.times, color: AppColors.light),
          navItems: [
            MenuNavItem(onTap: () => navigate(context, Routes.home), icon: LineIcons.home),
            MenuNavItem(onTap: () => navigate(context, Routes.about), icon: LineIcons.infoCircle),
            MenuNavItem(onTap: () => navigate(context, Routes.services), icon: LineIcons.cogs),
            MenuNavItem(onTap: () => navigate(context, Routes.caseStudies), icon: LineIcons.briefcase),
            MenuNavItem(onTap: () => navigate(context, Routes.library), icon: LineIcons.archive),
            MenuNavItem(onTap: () => navigate(context, Routes.documents.first.$2), icon: LineIcons.fileAlt),
            MenuNavItem(onTap: () => AppState.dark.value = !AppState.dark.value, icon: LineIcons.adjust),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: RetroDesktopScaffold(
                topBar: RetroDesktopAppBar(title: widget.title),
                body: ColoredBox(
                  color: AppColors.ink,
                  child: SingleChildScrollView(
                    // Extra bottom space keeps the docked menu clear of the footer.
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 96),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(child: AppBreadcrumb(crumbs: widget.crumbs)),
                                const SizedBox(width: 12),
                                const SquareSwitcher(),
                              ],
                            ),
                            widget.child,
                            const AppFooter(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: _ready,
                child: AnimatedOpacity(
                  opacity: _ready ? 0 : 1,
                  duration: const Duration(milliseconds: 350),
                  child: ColoredBox(color: AppColors.ink, child: const Center(child: PageLoader())),
                ),
              ),
            ),
          ],
        ),
      );
}
