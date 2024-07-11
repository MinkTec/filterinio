
import 'package:filterinio/filterinio.dart';
import 'package:test/test.dart';

void main() {
  group("comparisons", () {
    test('binary comp predicate builder', () {
      var pred = BinaryComparison.gt.predicate<int, int, num>(5);
      expect(pred(4), false);
      expect(pred(5), false);
      expect(pred(6), true);

      pred = BinaryComparison.geq.predicate<int, int, num>(5);
      expect(pred(4), false);
      expect(pred(5), true);
      expect(pred(6), true);

      pred = BinaryComparison.le.predicate<int, int, num>(5);
      expect(pred(4), true);
      expect(pred(5), false);
      expect(pred(6), false);

      pred = BinaryComparison.leq.predicate<int, int, num>(5);
      expect(pred(4), true);
      expect(pred(5), true);
      expect(pred(6), false);

      pred = UnaryLogicalConnective.negate
          .transform(BinaryComparison.leq.predicate<int, int, num>(5));
      expect(pred(4), false);
      expect(pred(5), false);
      expect(pred(6), true);

      pred = BinaryComparison.leq.predicate<int, int, num>(5);
      expect(pred(4), true);
      expect(pred(5), true);
      expect(pred(6), false);

      pred = BinaryComparison.eq.predicate<int, int, num>(5);
      expect(pred(4), false);
      expect(pred(5), true);
      expect(pred(6), false);

      pred = BinaryComparison.neq.predicate<int, int, num>(5);
      expect(pred(4), true);
      expect(pred(5), false);
      expect(pred(6), true);
    });

    test("ternary comp builder", () {
      var pred =
          TernaryComparison.inside.predicate<double, double, double, num>(0, 1);
      expect(pred(-1), false);
      expect(pred(0), false);
      expect(pred(0.5), true);
      expect(pred(1), false);

      pred = TernaryComparison.insideEq
          .predicate<double, double, double, num>(0, 1);
      expect(pred(-1), false);
      expect(pred(0), true);
      expect(pred(0.5), true);
      expect(pred(1), true);

      pred = TernaryComparison.outside.predicate<num, num, num, num>(0.0, 1.0);
      expect(pred(-1), true);
      expect(pred(0), false);
      expect(pred(0.5), false);
      expect(pred(1), false);

      pred = TernaryComparison.outsideEq
          .predicate<double, double, double, num>(0, 1);
      expect(pred(-1), true);
      expect(pred(0), true);
      expect(pred(0.5), false);
      expect(pred(1), true);
    });

  });
}
