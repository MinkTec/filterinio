import 'package:filterinio/src/types.dart';

typedef TernaryCompFunc<Q extends T, R extends T, S extends T,
        T extends Comparable<T>>
    = bool Function(Q a, R b, S c);

enum TernaryComparison {
  inside,
  insideEq,
  outside,
  outsideEq,
  ;

  @override
  String get description => switch (this) {
        TernaryComparison.inside => "between",
        TernaryComparison.insideEq => "between or equal",
        TernaryComparison.outside => "outside",
        TernaryComparison.outsideEq => "outside or equal"
      };

  @override
  String get enumName => name;

  TernaryCompFunc<Q, R, T, S>
      func<Q extends S, R extends S, T extends S, S extends Comparable<S>>() =>
          switch (this) {
            TernaryComparison.inside => (Q a, R b, T c) =>
                a.compareTo(b) > 0 && a.compareTo(c) < 0,
            TernaryComparison.insideEq => (Q a, R b, T c) =>
                a.compareTo(b) >= 0 && a.compareTo(c) <= 0,
            TernaryComparison.outside => (Q a, R b, T c) =>
                a.compareTo(b) < 0 || a.compareTo(c) > 0,
            TernaryComparison.outsideEq => (Q a, R b, T c) =>
                a.compareTo(b) <= 0 || a.compareTo(c) >= 0,
          };

  @override
  String get label => switch (this) {
        TernaryComparison.inside => "< x <",
        TernaryComparison.insideEq => "<= x <=",
        TernaryComparison.outside => "> x <",
        TernaryComparison.outsideEq => ">= x =<"
      };

  Predicate<Q>
      predicate<Q extends S, R extends S, T extends S, S extends Comparable<S>>(
              R lower, T upper) =>
          (Q value) => func<Q, R, T, S>()(value, lower, upper);
}
