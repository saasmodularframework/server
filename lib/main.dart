import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show databaseFactoryFfi, sqfliteFfiInit;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'app_state.dart';
import 'pages/about_saas_products.dart';
import 'data/instances.dart';
import 'pages/home_page.dart';
import 'pages/instance_page.dart';
import 'pages/library_page.dart';
import 'pages/not_found_page.dart';
import 'pages/sample_page.dart';
import 'pages/section_page.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

const String siteName = 'MODERN MOBILE APPLICATIONS';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await retroDesktopLoadFonts();
  usePathUrlStrategy();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  AppState.rebuildOnChange();
  runApp(const SaasApp());
}

(Section, int)? _instance(String path) {
  for (final s in Section.values) {
    if (!path.startsWith('${s.path}/')) continue;
    final n = parseInstanceSlug(path.substring(s.path.length + 1));
    if (n != null) return (s, n);
  }
  return null;
}

Route<void> _onGenerateRoute(RouteSettings settings) {
  final rawName = settings.name;
  var path = (rawName == null || rawName.isEmpty)
      ? '/'
      : (Uri.tryParse(rawName)?.path ?? rawName);

  if (path.isEmpty || path == '/index.html') {
    path = '/';
  } else if (path.length > 1 && path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }

  var title = siteName;
  final Widget page;

  if (path == Routes.home) {
    page = const HomePage();
  } else if (path == Routes.about) {
    title = 'About SaaS Products';
    page = const AboutSaasProductsPage();
  } else if (path == Routes.library) {
    title = 'Archive';
    page = const LibraryPage();
  } else if (path == Routes.services || path == Routes.caseStudies) {
    final section = path == Routes.services ? Section.services : Section.caseStudies;
    title = section.label;
    page = SectionPage(section: section);
  } else if (_instance(path) case (final Section section, final int number)) {
    title = '${section.label} \u00B7 ${instanceSlug(number)}';
    page = InstancePage(key: ValueKey(path), section: section, number: number);
  } else if (path.startsWith('/p/') && path.length > 3) {
    final slug = path.substring(3);
    title = slug.toUpperCase();
    page = SamplePage(key: ValueKey(slug), slug: slug);
  } else {
    title = '404';
    page = const NotFoundPage();
  }

  return PageRouteBuilder<void>(
    settings: settings,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    pageBuilder: (context, animation, secondary) => Title(
      title: title == siteName ? title : '$title \u00B7 $siteName',
      color: AppColors.light,
      child: page,
    ),
  );
}

class SaasApp extends StatelessWidget {
  const SaasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: siteName,
      color: AppColors.light,
      debugShowCheckedModeBanner: false,
      textStyle: appStyle(),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondary) => builder(context),
      ),
      onGenerateRoute: _onGenerateRoute,
      onGenerateInitialRoutes: (name) => [_onGenerateRoute(RouteSettings(name: name))],
      builder: (context, child) => ListenableBuilder(
        listenable: AppState.theme,
        builder: (context, _) => RetroDesktopTheme(
          data: buildRetroTheme(),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
