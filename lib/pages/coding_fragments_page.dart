import 'package:flutter/widgets.dart';

import '../data/docs/coding_fragments_doc.dart';
import '../routes.dart';
import '../theme/app_widgets.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/doc_view.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class CodingFragmentsPage extends StatelessWidget {
  const CodingFragmentsPage({super.key});

  @override
  Widget build(BuildContext context) => PageShell(
        title: codingFragmentsTitle,
        crumbs: const [Crumb('Home', Routes.home), Crumb(codingFragmentsTitle)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeading(codingFragmentsTitle, subtitle: codingFragmentsSubtitle.isEmpty ? null : codingFragmentsSubtitle, size: 28),
            const Align(alignment: Alignment.centerLeft, child: GifStackCarousel()),
            const SizedBox(height: 16),
            const DocView(blocks: codingFragmentsBlocks),
          ],
        ),
      );
}
