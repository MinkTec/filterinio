part of 'comparisons.dart';

typedef TernaryCompFunc<Q extends T, R extends T, S extends T,
        T extends Comparable<T>>
    = bool Function(Q a, R b, S c);

enum TernaryComparison implements ComparisonEnum, Displayable {
  inside,
  insideEq,
  outside,
  outsideEq,
  ;

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

  Predicate<Q>
      predicate<Q extends S, R extends S, T extends S, S extends Comparable<S>>(
              R lower, T upper) =>
          (Q value) => func<Q, R, T, S>()(value, lower, upper);

  @override
  String get label {
    switch (this) {
      case TernaryComparison.inside:
        return 'Inside';
      case TernaryComparison.insideEq:
        return 'Inside or Equal';
      case TernaryComparison.outside:
        return 'Outside';
      case TernaryComparison.outsideEq:
        return 'Outside or Equal';
    }
  }

  @override
  String get sign {
    switch (this) {
      case TernaryComparison.inside:
        return '∈ ()';
      case TernaryComparison.insideEq:
        return '∈ []';
      case TernaryComparison.outside:
        return '∉ ()';
      case TernaryComparison.outsideEq:
        return '∉ []';
    }
  }
}
