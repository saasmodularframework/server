import 'package:flutter/widgets.dart';

import '../data/docs/coding_variations_doc.dart';
import '../routes.dart';
import '../theme/app_widgets.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/doc_view.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class CodingVariationsPage extends StatelessWidget {
  const CodingVariationsPage({super.key});

  @override
  Widget build(BuildContext context) => PageShell(
        title: codingVariationsTitle,
        crumbs: const [Crumb('Home', Routes.home), Crumb(codingVariationsTitle)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeading(codingVariationsTitle, subtitle: codingVariationsSubtitle.isEmpty ? null : codingVariationsSubtitle, size: 28),
            const Align(alignment: Alignment.centerLeft, child: GifStackCarousel()),
            const SizedBox(height: 16),
            const DocView(blocks: codingVariationsBlocks),
          ],
        ),
      );
}
