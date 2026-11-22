import 'products_seed.dart';

enum Section {
  services('/services', 'Services', 'Service'),
  caseStudies('/case-studies', 'Case Studies', 'Case study');

  final String path, label, singular;
  const Section(this.path, this.label, this.singular);
}

const int kInstanceCount = 40;

String instanceSlug(int number) => 'instance-${number.toString().padLeft(2, '0')}';

int? parseInstanceSlug(String slug) {
  final m = RegExp(r'^instance-(\d{2})$').firstMatch(slug);
  final n = m == null ? null : int.parse(m.group(1)!);
  return n != null && n >= 1 && n <= kInstanceCount ? n : null;
}

class Instance {
  final Section section;
  final int number;
  const Instance(this.section, this.number);

  SeedProduct get product => seedProducts[number - 1];

  String get slug => instanceSlug(number);
  String get route => '${section.path}/$slug';
  String get title => '${section.singular} instance ${number.toString().padLeft(2, '0')}';
  String get subtitle => product.name;
  List<String> get tags => product.tagList;

  String get summary => section == Section.services
      ? 'Managed ${product.name.toLowerCase()} service: ${product.purpose}.'
      : 'How a team shipped ${product.name.toLowerCase()}: ${product.purpose}.';

  List<String> get paragraphs {
    final platforms = tags.map((t) => t.toLowerCase()).join(', ');
    if (section == Section.services) {
      return [
        'Service instance ${number.toString().padLeft(2, '0')} covers ${product.name}: ${product.purpose}.',
        'The engagement includes design, build and operation of the module for $platforms, '
            'with sample screens in 2D and 3D and a virtual & augmented reality preview.',
        'Current release: v${product.version}-pre. Pricing, scope and the delivery plan are agreed per instance.',
      ];
    }
    return [
      'Case study instance ${number.toString().padLeft(2, '0')} follows a delivery of ${product.name}: ${product.purpose}.',
      'The team shipped to $platforms from one code base, measured the result against the original brief '
          'and kept the sample data, screens and reel as reference material.',
      'Outcome: v${product.version}-pre went live and is the baseline for the next iteration.',
    ];
  }

  static List<Instance> all(Section s) => [for (var n = 1; n <= kInstanceCount; n++) Instance(s, n)];
}

