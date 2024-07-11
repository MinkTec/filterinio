library filterinio_comparisons;

import 'package:filterinio/src/types.dart';

typedef BinaryCompFunc<R extends S, T extends S, S extends Comparable<S>> = bool
    Function(R a, T b);

enum BinaryComparison  {
  gt,
  geq,
  le,
  leq,
  eq,
  neq,
  ;

  @override
  String get description => switch (this) {
        BinaryComparison.gt => "greater",
        BinaryComparison.geq => "greater or equal",
        BinaryComparison.le => "less",
        BinaryComparison.leq => "less or equal",
        BinaryComparison.eq => "equal",
        BinaryComparison.neq => "not equal",
      };

  @override
  String get enumName => name;

  BinaryCompFunc<R, T, S>
      func<R extends S, T extends S, S extends Comparable<S>>() =>
          switch (this) {
            BinaryComparison.gt => (R a, T b) => a.compareTo(b) > 0,
            BinaryComparison.geq => (R a, T b) => a.compareTo(b) >= 0,
            BinaryComparison.le => (R a, T b) => a.compareTo(b) < 0,
            BinaryComparison.leq => (R a, T b) => a.compareTo(b) <= 0,
            BinaryComparison.eq => (R a, T b) => a.compareTo(b) == 0,
            BinaryComparison.neq => (R a, T b) => a.compareTo(b) != 0,
          };

  @override
  String get label => switch (this) {
        BinaryComparison.gt => ">",
        BinaryComparison.geq => ">=",
        BinaryComparison.le => "<",
        BinaryComparison.leq => "<=",
        BinaryComparison.eq => "==",
        BinaryComparison.neq => "!=",
      };

  Predicate<R> predicate<R extends S, T extends S, S extends Comparable<S>>(
      T reference) {
    return (R value) => func<R, T, S>()(value, reference);
  }
}
