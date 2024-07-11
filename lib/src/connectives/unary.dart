import 'package:filterinio/src/types.dart';

enum UnaryLogicalConnective {
  confirm,
  negate,
  ;

  Predicate<T> transform<T>(Predicate<T> predicate) {
    return switch (this) {
      UnaryLogicalConnective.confirm => predicate,
      UnaryLogicalConnective.negate => (T t) => !predicate(t),
    };
  }

  String get label => switch (this) {
        UnaryLogicalConnective.confirm => "is",
        UnaryLogicalConnective.negate => "is not",
      };
}
