import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';

import '../data/products_seed.dart';
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

class AboutSaasProductsPage extends StatefulWidget {
  const AboutSaasProductsPage({super.key});

  @override
  State<AboutSaasProductsPage> createState() => _AboutSaasProductsPageState();
}

class _AboutSaasProductsPageState extends State<AboutSaasProductsPage> {
  late final Future<List<Product>> _pages = Db.pages();

  @override
  Widget build(BuildContext context) => PageShell(
        title: 'About SaaS Products',
        crumbs: const [Crumb('Home', Routes.home), Crumb('About SaaS Products')],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeading(
              'About SaaS Products',
              subtitle: 'The details about software & machine learning engineering [virtual & augmented reality in 2D/3D]',
              size: 28,
            ),
            const GifStackCarousel(),
            const SizedBox(height: 12),
            AsyncBody<List<Product>>(
              future: _pages,
              builder: (context, pages) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final p in pages.take(kOriginalProducts)) _ProductRow(p),
                  const AppHeading('Sample modules', subtitle: 'Twenty-six more pages from the same database', size: 20),
                  AppFrame(
                    child: RetroDesktopWell(
                      child: RetroDesktopList(
                        children: [
                          for (final p in pages.skip(kOriginalProducts))
                            RetroDesktopListTile(
                              title: p.display,
                              subtitle: '${p.versionLabel}  ${p.copyright}  \u00B7  ${p.tags.join(' ')}',
                              leading: const Icon(RetroDesktopGlyphs.fileText),
                              onPressed: () => navigate(context, Routes.page(p.slug)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ProductRow extends StatelessWidget {
  final Product product;
  const _ProductRow(this.product);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: AppTap(
          onTap: () => navigate(context, Routes.page(product.slug)),
          child: IntrinsicHeight(
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Container(
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.burgundy,
                  border: Border.all(color: AppColors.light, width: 2),
                ),
                child: const Center(child: Icon(RetroDesktopGlyphs.fileText, color: Color(0xFFF2E8C9), size: 22)),
              ),
              Expanded(
                child: AppFrame(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 120, height: 84, child: DbImage(product.heroId, cacheWidth: 300)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            txt(product.display, size: 15, weight: FontWeight.w700, spacing: 2, color: AppColors.light),
                            const SizedBox(height: 2),
                            txt('${product.versionLabel}  ${product.copyright}', size: 11.5, spacing: 1),
                            const SizedBox(height: 8),
                            Wrap(spacing: 6, runSpacing: 6, children: [for (final t in product.tags) AppTag(t)]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      );
}

