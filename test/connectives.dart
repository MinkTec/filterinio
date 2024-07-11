import 'package:filterinio/filterinio.dart';
import 'package:test/test.dart';

main() {
  group('connectives', () {
    test("predicat combinations", () {
      var pred1 = BinaryComparison.eq.predicate<int, int, num>(5);
      var pred2 = BinaryComparison.neq.predicate<int, int, num>(5);

      expect(pred1.join(pred2, BinaryLogicalConnective.or)(5), true);
      expect(pred1.join(pred2, BinaryLogicalConnective.and)(5), false);
      expect(pred1.join(pred2, BinaryLogicalConnective.xor)(5), true);

      expect(pred1.join(pred1, BinaryLogicalConnective.or)(5), true);
      expect(pred1.join(pred1, BinaryLogicalConnective.and)(5), true);
      expect(pred1.join(pred1, BinaryLogicalConnective.xor)(5), false);

      expect(pred2.join(pred2, BinaryLogicalConnective.or)(5), false);
      expect(pred2.join(pred2, BinaryLogicalConnective.and)(5), false);
      expect(pred2.join(pred2, BinaryLogicalConnective.xor)(5), false);

      var relation = BinaryLogicalConnective.and;
      var pred = pred1.join(
          pred1.join(
              pred1.join(
                pred1.join(
                  pred1.join(
                    pred1,
                    relation,
                  ),
                  relation,
                ),
                relation,
              ),
              relation),
          relation);

      expect(pred(5), true);

      relation = BinaryLogicalConnective.or;
      pred = pred1.join(
          pred1.join(
              pred1.join(
                pred1.join(
                  pred1.join(
                    pred1,
                    relation,
                  ),
                  relation,
                ),
                relation,
              ),
              relation),
          relation);

      expect(pred(5), true);

      relation = BinaryLogicalConnective.xor;
      pred = pred1.join(
          pred1.join(
              pred1.join(
                pred1.join(
                  pred1.join(
                    pred1,
                    relation,
                  ),
                  relation,
                ),
                relation,
              ),
              relation),
          relation);

      expect(pred(5), false);
    });
  });
}
