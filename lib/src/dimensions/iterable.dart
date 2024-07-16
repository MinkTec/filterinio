
import '../tree/nodes.dart';
import '../types.dart';

enum IterableComparison {
  intersecting,
  disjoint,
  subset,
  superset,
  strictSuperset,
  identical,
  ;

  Predicate<Iter> predicate<Iter extends Iterable<T>, T>(Iter reference) =>
      switch (this) {
        IterableComparison.intersecting => (Iter t) =>
            {...t}.intersection({...reference}).isNotEmpty,
        IterableComparison.disjoint => (Iter t) =>
            {...t}.intersection({...reference}).isEmpty,
        IterableComparison.subset => (Iter t) =>
            t.any((x) => reference.contains(x)) &&
            !t.any((x) => !reference.contains(x)),
        IterableComparison.superset => (Iter t) =>
            t.every((x) => reference.contains(x)),
        IterableComparison.strictSuperset => (Iter t) =>
            IterableComparison.subset.predicate(reference)(t) &&
            !IterableComparison.identical.predicate(reference)(t),
        IterableComparison.identical => (Iter t) =>
            t.length == reference.length &&
            {...t}.intersection({...reference}).length == reference.length,
      };
}

class IterableDimension<Iter extends Iterable<T>, T>
    extends FilterDimension<Iter> {
  final IterableComparison comparison;

  final Iter reference;

  IterableDimension({
    super.debugPrintId = "iter",
    required this.reference,
    required this.comparison,
    super.unaryConnective,
  });

  @override
  bool Function(Iter value) predicate() => comparison.predicate(reference);
}
