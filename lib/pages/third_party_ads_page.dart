import 'package:flutter/widgets.dart';

import '../data/docs/third_party_ads_doc.dart';
import '../routes.dart';
import '../theme/app_widgets.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/doc_view.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class ThirdPartyAdsPage extends StatelessWidget {
  const ThirdPartyAdsPage({super.key});

  @override
  Widget build(BuildContext context) => PageShell(
        title: thirdPartyAdsTitle,
        crumbs: const [Crumb('Home', Routes.home), Crumb(thirdPartyAdsTitle)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeading(thirdPartyAdsTitle, subtitle: thirdPartyAdsSubtitle.isEmpty ? null : thirdPartyAdsSubtitle, size: 28),
            const Align(alignment: Alignment.centerLeft, child: GifStackCarousel()),
            const SizedBox(height: 16),
            const DocView(blocks: thirdPartyAdsBlocks),
          ],
        ),
      );
}
