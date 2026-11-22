import 'package:flutter/widgets.dart';

import '../data/docs/microservices_peculiarities_doc.dart';
import '../routes.dart';
import '../theme/app_widgets.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/doc_view.dart';
import '../widgets/gif_stack_carousel.dart';
import '../widgets/page_shell.dart';

class MicroservicesPeculiaritiesPage extends StatelessWidget {
  const MicroservicesPeculiaritiesPage({super.key});

  @override
  Widget build(BuildContext context) => PageShell(
        title: microservicesPeculiaritiesTitle,
        crumbs: const [Crumb('Home', Routes.home), Crumb(microservicesPeculiaritiesTitle)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeading(microservicesPeculiaritiesTitle, subtitle: microservicesPeculiaritiesSubtitle.isEmpty ? null : microservicesPeculiaritiesSubtitle, size: 28),
            const Align(alignment: Alignment.centerLeft, child: GifStackCarousel()),
            const SizedBox(height: 16),
            const DocView(blocks: microservicesPeculiaritiesBlocks),
          ],
        ),
      );
}
