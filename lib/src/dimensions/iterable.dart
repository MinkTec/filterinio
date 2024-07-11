
import '../tree/nodes.dart';
import '../types.dart';

enum IterableComparisons {
  intersecting,
  disjoint,
  subset,
  superset,
  strictSuperset,
  identical,
  ;

  Predicate<Iter> predicate<Iter extends Iterable<T>, T>(Iter reference) =>
      switch (this) {
        IterableComparisons.intersecting => (Iter t) =>
            {...t}.intersection({...reference}).isNotEmpty,
        IterableComparisons.disjoint => (Iter t) =>
            {...t}.intersection({...reference}).isEmpty,
        IterableComparisons.subset => (Iter t) =>
            t.any((x) => reference.contains(x)) &&
            !t.any((x) => !reference.contains(x)),
        IterableComparisons.superset => (Iter t) =>
            t.every((x) => reference.contains(x)),
        IterableComparisons.strictSuperset => (Iter t) =>
            IterableComparisons.subset.predicate(reference)(t) &&
            !IterableComparisons.identical.predicate(reference)(t),
        IterableComparisons.identical => (Iter t) =>
            t.length == reference.length &&
            {...t}.intersection({...reference}).length == reference.length,
      };
}

class IterableComparable<Iter extends Iterable<T>, T>
    extends FilterDimension<Iter> {
  final IterableComparisons comparison;

  final Iter reference;

  IterableComparable({
    super.debugPrintId = "iter",
    required this.reference,
    required this.comparison,
    super.unaryConnective,
  });

  @override
  bool Function(Iter value) predicate() => comparison.predicate(reference);
}
