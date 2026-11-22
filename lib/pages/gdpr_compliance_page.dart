import 'package:flutter/widgets.dart';

import '../data/docs/gdpr_compliance_doc.dart';
import '../routes.dart';
import '../theme/app_widgets.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/doc_view.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class GdprCompliancePage extends StatelessWidget {
  const GdprCompliancePage({super.key});

  @override
  Widget build(BuildContext context) => PageShell(
        title: gdprComplianceTitle,
        crumbs: const [Crumb('Home', Routes.home), Crumb(gdprComplianceTitle)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeading(gdprComplianceTitle, subtitle: gdprComplianceSubtitle.isEmpty ? null : gdprComplianceSubtitle, size: 28),
            const Align(alignment: Alignment.centerLeft, child: GifStackCarousel()),
            const SizedBox(height: 16),
            const DocView(blocks: gdprComplianceBlocks),
          ],
        ),
      );
}
