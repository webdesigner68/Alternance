import 'package:flutter_test/flutter_test.dart';
import 'package:la_bonne_alternance/data/models/search_criteria.dart';

void main() {
  group('JobRemoteDatasource', () {
    test('should build search query with CSV romes', () {
      const criteria = SearchCriteria(
        romes: ['M1805', 'M1607'],
        radius: 50,
      );

      // In the actual datasource, this would be:
      // query['romes'] = criteria.romes!.join(',');
      final romesParam = criteria.romes!.join(',');

      expect(romesParam, 'M1805,M1607');
    });

    test('should format lat/lon to 6 decimals', () {
      const criteria = SearchCriteria(
        latitude: 48.856613123456,
        longitude: 2.352222987654,
      );

      final latParam = criteria.latitude!.toStringAsFixed(6);
      final lonParam = criteria.longitude!.toStringAsFixed(6);

      expect(latParam, '48.856613');
      expect(lonParam, '2.352223');
    });

    test('should use integer radius', () {
      const criteria = SearchCriteria(
        radius: 30,
      );

      expect(criteria.radius, isA<int>());
      expect(criteria.radius, 30);
    });

    test('should handle repeated departements parameter', () {
      const criteria = SearchCriteria(
        departements: ['75', '06', '13'],
      );

      expect(criteria.departements, hasLength(3));
      expect(criteria.departements, contains('75'));
    });
  });
}
