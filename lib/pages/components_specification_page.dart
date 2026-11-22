import 'package:flutter/widgets.dart';

import '../data/docs/components_specification_doc.dart';
import '../routes.dart';
import '../theme/app_widgets.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/doc_view.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class ComponentsSpecificationPage extends StatelessWidget {
  const ComponentsSpecificationPage({super.key});

  @override
  Widget build(BuildContext context) => PageShell(
        title: componentsSpecificationTitle,
        crumbs: const [Crumb('Home', Routes.home), Crumb(componentsSpecificationTitle)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeading(componentsSpecificationTitle, subtitle: componentsSpecificationSubtitle.isEmpty ? null : componentsSpecificationSubtitle, size: 28),
            const Align(alignment: Alignment.centerLeft, child: GifStackCarousel()),
            const SizedBox(height: 16),
            const DocView(blocks: componentsSpecificationBlocks),
          ],
        ),
      );
}
