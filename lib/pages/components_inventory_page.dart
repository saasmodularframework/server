import 'package:flutter/widgets.dart';

import '../data/docs/components_inventory_doc.dart';
import '../routes.dart';
import '../theme/app_widgets.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/doc_view.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class ComponentsInventoryPage extends StatelessWidget {
  const ComponentsInventoryPage({super.key});

  @override
  Widget build(BuildContext context) => PageShell(
        title: componentsInventoryTitle,
        crumbs: const [Crumb('Home', Routes.home), Crumb(componentsInventoryTitle)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeading(componentsInventoryTitle, subtitle: componentsInventorySubtitle.isEmpty ? null : componentsInventorySubtitle, size: 28),
            const Align(alignment: Alignment.centerLeft, child: GifStackCarousel()),
            const SizedBox(height: 16),
            const DocView(blocks: componentsInventoryBlocks),
          ],
        ),
      );
}
