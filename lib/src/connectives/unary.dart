import 'package:filterinio/src/models/displayable.dart';
import 'package:filterinio/src/types.dart';

enum UnaryLogicalConnective implements Displayable {
  confirm,
  negate,
  ;

  @override
  String get sign => switch (this) {
        UnaryLogicalConnective.confirm => '',
        UnaryLogicalConnective.negate => '!',
      };

  Predicate<T> transform<T>(Predicate<T> predicate) {
    return switch (this) {
      UnaryLogicalConnective.confirm => predicate,
      UnaryLogicalConnective.negate => (T t) => !predicate(t),
    };
  }

  @override
  String get label => switch (this) {
        UnaryLogicalConnective.confirm => "is",
        UnaryLogicalConnective.negate => "is not",
      };
}
