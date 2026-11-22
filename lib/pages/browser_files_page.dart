import 'package:flutter/widgets.dart';

import '../data/docs/browser_files_doc.dart';
import '../routes.dart';
import '../theme/app_widgets.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/doc_view.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class BrowserFilesPage extends StatelessWidget {
  const BrowserFilesPage({super.key});

  @override
  Widget build(BuildContext context) => PageShell(
        title: browserFilesTitle,
        crumbs: const [Crumb('Home', Routes.home), Crumb(browserFilesTitle)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeading(browserFilesTitle, subtitle: browserFilesSubtitle.isEmpty ? null : browserFilesSubtitle, size: 28),
            const Align(alignment: Alignment.centerLeft, child: GifStackCarousel()),
            const SizedBox(height: 16),
            const DocView(blocks: browserFilesBlocks),
          ],
        ),
      );
}
