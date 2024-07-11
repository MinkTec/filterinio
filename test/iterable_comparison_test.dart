import 'package:filterinio/filterinio.dart';
import 'package:test/test.dart';

void main() {
  group('set equality tests', () {
    final ref = [1, 2, 5];

    test("disjoint", () {
      final comp = IterableDimension(
          reference: ref, comparison: IterableComparisons.disjoint);
      expect(comp.evaluate([2]), false);
      expect(comp.evaluate([2489]), true);
    });

    test("subset", () {
      final comp = IterableDimension(
          reference: ref, comparison: IterableComparisons.subset);
      expect(comp.evaluate([2]), true);
      expect(comp.evaluate([1, 2, 5]), true);
      expect(comp.evaluate([2489]), false);
    });

    test("superset", () {
      final comp = IterableDimension(
          reference: ref, comparison: IterableComparisons.superset);
      expect(comp.evaluate([1, 2, 5]), true);
      expect(comp.evaluate([1, 2, 6, 7]), false);
    });

    test("strict superset", () {
      final comp = IterableDimension(
        reference: ref,
        comparison: IterableComparisons.strictSuperset,
      );
      expect(comp.evaluate([1, 2]), true);
      expect(comp.evaluate([1, 2, 5]), false);
      expect(comp.evaluate([1, 2, 6, 7]), false);
      expect(comp.evaluate([1, 2, 5, 7]), false);
    });

    test("identical", () {
      final comp = IterableDimension(
          reference: ref, comparison: IterableComparisons.identical);
      expect(comp.evaluate([1, 2, 5]), true);
      expect(comp.evaluate([1, 2, 6, 7]), false);
      expect(comp.evaluate([1, 2, 5, 7]), false);
    });

    test("intersecting", () {
      final comp = IterableDimension(
          reference: ref, comparison: IterableComparisons.intersecting);
      expect(comp.evaluate([4, 7]), false);
      expect(comp.evaluate([1, 2, 5]), true);
      expect(comp.evaluate([1, 2, 6, 7]), true);
      expect(comp.evaluate([1, 2, 6, 7, 9, 4]), true);
    });
  });
}
