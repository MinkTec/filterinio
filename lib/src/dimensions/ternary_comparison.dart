import '../comparisons/ternary.dart';
import '../tree/nodes.dart';

class TernaryComparableFilterDimension<T extends Comparable<T>>
    extends FilterDimension<T> {
  final TernaryComparison comparison;

  final T left;
  final T right;

  TernaryComparableFilterDimension({
    super.debugPrintId = "ternary",
    required this.comparison,
    super.unaryConnective,
    required this.left,
    required this.right,
  });

  @override
  bool Function(T value) predicate() =>
      comparison.predicate<T, T, T, T>(left, right);
}
