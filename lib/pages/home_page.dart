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
import '../widgets/jpg_carousel.dart';
import '../widgets/page_shell.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<Product>> _pages = Db.pages();

  @override
  Widget build(BuildContext context) => PageShell(
        title: 'SaaS Products',
        crumbs: const [Crumb('Home')],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeading(
              'SaaS Products',
              subtitle: 'Software & machine learning engineering [virtual & augmented reality in 2D/3D]',
              size: 30,
            ),
            Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  RetroDesktopButton('About SaaS Products',
                      isDefaultAction: true, onPressed: () => navigate(context, Routes.about)),
                  RetroDesktopButton('Services', onPressed: () => navigate(context, Routes.services)),
                  RetroDesktopButton('Case Studies', onPressed: () => navigate(context, Routes.caseStudies)),
                  RetroDesktopButton('Open Archive', onPressed: () => navigate(context, Routes.library)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const JpgCarousel(),
            const AppHeading('Forty sample pages', size: 20),
            AsyncBody<List<Product>>(
              future: _pages,
              builder: (context, pages) => Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [for (final p in pages) _ProductCard(p)],
              ),
            ),
          ],
        ),
      );
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard(this.product);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 250,
        child: AppRoundedTile(
          header: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: SizedBox(
              height: 130,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DbImage(product.heroId, cacheWidth: 500),
              ),
            ),
          ),
          title: txt(product.display, size: 13, weight: FontWeight.w700, spacing: 1.5, color: AppColors.light, maxLines: 2),
          subtitle: txt('PAGE ${product.position + 1} / 40', size: 10, spacing: 2),
          children: [
            txt('${product.versionLabel}  ${product.copyright}', size: 11, spacing: 1),
            const SizedBox(height: 10),
            RetroDesktopButton('Open page',
                isDefaultAction: true, onPressed: () => navigate(context, Routes.page(product.slug))),
          ],
        ),
      );
}
