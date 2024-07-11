import 'package:filterinio/filterinio.dart';
import 'package:test/test.dart';

void main() {
  group('filterinio', () {
    test('tree', () {
      final x = FilterTree();

      final first = BinaryComparableFilterDimension<int, num>(
        debugPrintId: "first",
        comparison: BinaryComparison.gt,
        reference: 0,
      );

      x.setRootFilterDimension(first);

      final second = BinaryComparableFilterDimension<int, num>(
        debugPrintId: "second",
        comparison: BinaryComparison.le,
        reference: 2,
      );

      final timeFilter = TernaryComparableFilterDimension(
          debugPrintId: "time",
          comparison: TernaryComparison.inside,
          left: DateTime(2022),
          right: DateTime(2024));

      final iterable = IterableDimension(
        debugPrintId: "iter",
        reference: {1, 2, 3},
        comparison: IterableComparisons.subset,
      );
      final iterable2 = IterableDimension(
        debugPrintId: "iter2",
        reference: {1, 2, 3},
        comparison: IterableComparisons.strictSuperset,
      );

      x.add(
          sibling: first,
          operator: BinaryLogicalConnective.and,
          dimension: second);

      x.add(
          dimension: timeFilter,
          sibling: x.root!,
          operator: BinaryLogicalConnective.xor);

      x.add(
          dimension: iterable,
          sibling: timeFilter,
          operator: BinaryLogicalConnective.and);

      final Map<FilterDimension, dynamic> data = {
        first: 1,
        second: 1,
        // timeFilter: DateTime.now(),
        iterable: {2}
      };

      try {
        x.evaluate(data);
        expect(true, false);
      } on ArgumentError catch (e) {
        expect(e.runtimeType, ArgumentError);
      }

      data[timeFilter] = DateTime(2023);

      expect(x.evaluate(data), false);

      data[timeFilter] = DateTime(2020);

      expect(x.evaluate(data), true);

      data[timeFilter] = DateTime.now();
      data[iterable] = {5};

      x.add(
          dimension: iterable2,
          sibling: iterable,
          operator: BinaryLogicalConnective.and);

      data[iterable2] = {1, 2, 3};

      expect(x.evaluate(data), true);
    });
  });
}
