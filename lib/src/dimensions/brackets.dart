import 'package:filterinio/filterinio.dart';

mixin Transformer<A, B> {
  A Function(B b) get from;
  B Function(A a) get to;
}

enum BracketComparison {
  less,
  lessOverlapping,
  equal,
  greaterOverlapping,
  greater,
  overlap,
  ;

  bool evaluate(Bracket value, Bracket reference) => switch (this) {
        BracketComparison.less => value.upper < reference.lower,
        BracketComparison.lessOverlapping =>
          value.upper >= reference.lower && value.upper <= reference.upper,
        BracketComparison.equal =>
          value.lower == reference.lower && value.upper == reference.upper,
        BracketComparison.greaterOverlapping =>
          value.lower >= reference.lower && value.lower <= reference.upper,
        BracketComparison.greater => value.lower > reference.upper,
        BracketComparison.overlap =>
          BracketComparison.lessOverlapping.evaluate(value, reference) ||
              BracketComparison.greaterOverlapping.evaluate(value, reference)
      };
}

class Bracket<T extends num> implements Comparable<Bracket> {
  T lower;
  T upper;

  Bracket(this.lower, this.upper) {
    assert(lower < upper);
  }

  static const int maxInt = 0x7FFFFFFFFFFFFFFF;
  static const int minInt = -0x8000000000000000;

  @override
  String toString() {
    if (lower == minInt || lower == double.negativeInfinity) {
      return "< ${(upper + 1).toStringAsFixed(0)}";
    } else if (upper == maxInt || upper == double.infinity) {
      return "> ${(lower - 1).toStringAsFixed(0)}";
    } else {
      return "${lower.toStringAsFixed(0)} - ${upper.toStringAsFixed(0)}";
    }
  }

  @override
  int compareTo(Bracket other) {
    if (lower > other.upper) {
      return 1;
    } else if (upper < other.lower) {
      return -1;
    } else {
      return 0;
    }
  }

  double get center => (lower - (upper - lower) / 2);

  @override
  bool operator ==(Object other) {
    if (other is! Bracket) return false;
    return this.lower == other.lower && this.upper == other.upper;
  }

  @override
  int get hashCode => this.lower.hashCode ^ this.upper.hashCode;
}

class TransformerBracket<T, S extends num> extends Bracket<S>
    with Transformer<T, S> {
  @override
  final T Function(S i) from;
  @override
  final S Function(T i) to;

  TransformerBracket({
    required T lower,
    required T upper,
    required this.from,
    required this.to,
  }) : super(to(lower), to(upper));

  factory TransformerBracket.fromBracket({
    required Bracket<S> bracket,
    required T Function(S i) from,
    required S Function(T i) to,
  }) =>
      TransformerBracket(
        lower: from(bracket.lower),
        upper: from(bracket.upper),
        to: to,
        from: from,
      );
}

class BracketRange<S extends num> {
  final S min;
  final S max;
  final S stepSize;
  late final List<Bracket<S>> brackets;

  BracketRange({
    required this.min,
    required this.max,
    required this.stepSize,
  }) {
    brackets = _brackets.toList();
  }

  Iterable<Bracket<S>> get _brackets sync* {
    try {
      yield Bracket<S>(Bracket.minInt as S, (min) - 1 as S);
      for (S i = min; i < max; i = i + stepSize as S) {
        yield Bracket<S>(i, i + (stepSize) - 1 as S);
      }
      yield Bracket<S>((max) + 1 as S, Bracket.maxInt as S);
    } catch (_) {
      yield Bracket<S>(double.negativeInfinity as S, min);
      for (S i = min; i < max; i = i + stepSize as S) {
        yield Bracket<S>(i, i + (stepSize) - 1 as S);
      }
      yield Bracket<S>((max) + 1 as S, double.infinity as S);
    }
  }

  Bracket<S> operator [](int i) => brackets[i];

  Bracket<S> getBracketByValue(value) {
    assert(value is S);
    return brackets.firstWhere((x) => x.lower <= value && value <= x.upper);
  }
}

class TransformerBracketRange<T, S extends num> extends BracketRange<S>
    with Transformer<T, S> {
  @override
  late final T Function(S i) from;
  @override
  late final S Function(T i) to;

  TransformerBracketRange({
    required T min,
    required T max,
    required T stepSize,
    required this.from,
    required this.to,
  }) : super(min: to(min), max: to(max), stepSize: to(stepSize));

  @override
  TransformerBracket<T, S> operator [](int i) =>
      TransformerBracket<T, S>.fromBracket(
          bracket: brackets[i], from: from, to: to);

  @override
  TransformerBracket<T, S> getBracketByValue(value) {
    assert(value is T);
    return TransformerBracket.fromBracket(
        bracket: brackets.firstWhere(
          (x) => x.lower <= to(value) && to(value) <= x.upper,
        ),
        from: from,
        to: to);
  }
}

class BracketDimension<T> extends FilterDimension<Bracket> {
  BracketComparison comparison;
  Bracket reference;

  BracketDimension({
    super.debugPrintId = "brackets",
    required this.comparison,
    required this.reference,
  });

  @override
  bool Function(Bracket value) predicate() => evaluate;

  @override
  bool evaluate(Bracket value) => comparison.evaluate(value, reference);

  @override
  String toString() =>
      "BracketDimension(comparison: ${comparison.name}, reference: $reference)";
}
