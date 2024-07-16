import '../tree/nodes.dart';
import 'iterable.dart';

class VariantDimension<T> extends FilterDimension {
  final IterableComparison comparison;
  final Set reference;

  VariantDimension({
    super.debugPrintId = "variant",
    required this.reference,
    required this.comparison,
    super.unaryConnective,
  });

  @override
  bool Function(dynamic value) predicate() {
    return (dynamic value) {
      final pred = comparison.predicate(reference);
      if (value is Set<T>) {
        return pred(value);
      } else {
        return pred({value});
      }
    };
  }

  @override
  bool evaluate(dynamic value) => this.predicate()(value);
}
