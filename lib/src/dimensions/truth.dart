import '../tree/nodes.dart';

class TruthFilterDimension extends FilterDimension<bool> {
  TruthFilterDimension({
    super.unaryConnective,
    super.debugPrintId = "truth",
  });

  @override
  bool Function(bool value) predicate() => (x) => x;
}
