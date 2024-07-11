import 'package:filterinio/filterinio.dart';
import 'package:test/test.dart';

void main() {
  group('brackets', () {
    test("base", () {
      final a = Bracket(1, 2);
      final a1 = Bracket(1, 2);
      final b = Bracket(2, 3);
      final c = Bracket(3, 4);
      final d = Bracket(1, 4);

      expect(BracketComparison.less.evaluate(a, b), false);
      expect(BracketComparison.less.evaluate(a, c), true);

      expect(BracketComparison.greater.evaluate(b, a), false);
      expect(BracketComparison.greater.evaluate(c, a), true);

      expect(BracketComparison.lessOverlapping.evaluate(a, b), true);
      expect(BracketComparison.lessOverlapping.evaluate(a, c), false);

      expect(BracketComparison.greaterOverlapping.evaluate(b, a), true);
      expect(BracketComparison.greaterOverlapping.evaluate(c, a), false);

      expect(BracketComparison.overlap.evaluate(a, d), true);
      expect(BracketComparison.overlap.evaluate(a, c), false);

      expect(BracketComparison.equal.evaluate(a, a), true);
      expect(BracketComparison.equal.evaluate(a, a1), true);
      expect(BracketComparison.equal.evaluate(a, b), false);
    });
  });
}
