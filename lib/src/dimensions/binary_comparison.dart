
import '../comparisons/comparisons.dart';
import '../tree/nodes.dart';

class BinaryComparableFilterDimension<T extends S, S extends Comparable<S>>
    extends FilterDimension<T> {
  final BinaryComparison comparison;

  final T reference;

  BinaryComparableFilterDimension({
    super.debugPrintId = "binary",
    required this.comparison,
    super.unaryConnective,
    required this.reference,
  });

  @override
  bool Function(T value) predicate() =>
      comparison.predicate<T, T, S>(reference);
}
