import 'package:flutter/widgets.dart';

import 'data/instances.dart';
import 'data/products_seed.dart';

const baseUrl = 'https://saas-app-server.onrender.com';
const siteName = 'SaaS Products';

class Routes {
  static const home = '/';
  static const about = '/about-saas-products';
  static const library = '/library';
  static const services = '/services';
  static const caseStudies = '/case-studies';
  static String page(String slug) => '/p/$slug';
  static String instance(Section s, int number) => '${s.path}/${instanceSlug(number)}';
}

void navigate(BuildContext context, String route) {
  final nav = Navigator.of(context);
  if (ModalRoute.of(context)?.settings.name == route) return;
  if (route == Routes.home) {
    nav.pushNamedAndRemoveUntil(Routes.home, (_) => false);
  } else {
    nav.pushNamedAndRemoveUntil(route, (r) => r.isFirst);
  }
}

String sitemapXml() {
  final urls = <String>[
    '$baseUrl/',
    '$baseUrl${Routes.about}',
    '$baseUrl${Routes.library}',
    '$baseUrl${Routes.services}',
    '$baseUrl${Routes.caseStudies}',
    for (final s in seedProducts) '$baseUrl${Routes.page(s.slug)}',
    for (final section in Section.values)
      for (var n = 1; n <= kInstanceCount; n++) '$baseUrl${Routes.instance(section, n)}',
  ];
  final body = urls
      .map((u) => '  <url>\n    <loc>$u</loc>\n    <changefreq>weekly</changefreq>\n    <priority>0.7</priority>\n  </url>')
      .join('\n');
  return '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n$body\n</urlset>\n';
}

