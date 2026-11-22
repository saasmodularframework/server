import 'package:saas_products/data/instances.dart';
import 'package:saas_products/data/products_seed.dart';
import 'package:saas_products/utils/roman.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('forty sample pages with unique slugs', () {
    expect(seedProducts.length, 40);
    expect(seedProducts.map((p) => p.slug).toSet().length, 40);
    expect(kOriginalProducts, 14);
  });

  test('roman numerals', () {
    expect(roman(1), 'I');
    expect(roman(14), 'XIV');
  });

  test('services and case studies have forty instance pages each', () {
    for (final s in Section.values) {
      final all = Instance.all(s);
      expect(all.length, 40);
      expect(all.first.route, '${s.path}/instance-01');
      expect(all.last.route, '${s.path}/instance-40');
    }
    expect(parseInstanceSlug('instance-07'), 7);
    expect(parseInstanceSlug('instance-00'), isNull);
    expect(parseInstanceSlug('instance-41'), isNull);
    expect(parseInstanceSlug('instance-7'), isNull);
  });
}

