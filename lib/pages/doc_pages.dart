import 'package:flutter/widgets.dart';

import '../routes.dart';
import 'browser_files_page.dart';
import 'coding_fragments_page.dart';
import 'coding_variations_page.dart';
import 'components_inventory_page.dart';
import 'components_specification_page.dart';
import 'gdpr_compliance_page.dart';
import 'microservices_peculiarities_page.dart';
import 'terms_of_use_page.dart';
import 'third_party_ads_page.dart';

(String, Widget)? docPage(String path) => switch (path) {
      Routes.browserFiles => ('Browser Files', const BrowserFilesPage()),
      Routes.codingFragments => ('Coding Fragments', const CodingFragmentsPage()),
      Routes.codingVariations => ('Coding Variations', const CodingVariationsPage()),
      Routes.componentsInventory => ('Components Inventory', const ComponentsInventoryPage()),
      Routes.componentsSpecification => ('Webapp Components Specification', const ComponentsSpecificationPage()),
      Routes.gdprCompliance => ('GDPR Compliance', const GdprCompliancePage()),
      Routes.microservicesPeculiarities => ('Microservices Peculiarities', const MicroservicesPeculiaritiesPage()),
      Routes.termsOfUse => ('Terms of Use', const TermsOfUsePage()),
      Routes.thirdPartyAds => ('Third-Party Ads', const ThirdPartyAdsPage()),
      _ => null,
    };
