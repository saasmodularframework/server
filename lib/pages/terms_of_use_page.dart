import 'package:flutter/widgets.dart';

import '../data/docs/terms_of_use_doc.dart';
import '../routes.dart';
import '../theme/app_widgets.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/doc_view.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) => PageShell(
        title: termsOfUseTitle,
        crumbs: const [Crumb('Home', Routes.home), Crumb(termsOfUseTitle)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeading(termsOfUseTitle, subtitle: termsOfUseSubtitle.isEmpty ? null : termsOfUseSubtitle, size: 28),
            const Align(alignment: Alignment.centerLeft, child: GifStackCarousel()),
            const SizedBox(height: 16),
            const DocView(blocks: termsOfUseBlocks),
          ],
        ),
      );
}
