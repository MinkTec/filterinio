
import 'package:filterinio/src/types.dart';

enum BinaryLogicalConnective {
  and,
  or,
  xor,
  nand,
  nor,
  ;

  Predicate<T> join<T>(Predicate<T> a, Predicate<T> b) => switch (this) {
        BinaryLogicalConnective.and => (T m) => a(m) & b(m),
        BinaryLogicalConnective.or => (T m) => a(m) || b(m),
        BinaryLogicalConnective.xor => (T m) => a(m) ^ b(m),
        BinaryLogicalConnective.nand => (T m) => !(a(m) & b(m)),
        BinaryLogicalConnective.nor => (T m) => !a(m) & !b(m),
      };

  bool evaluate(bool a, bool b) => switch (this) {
        BinaryLogicalConnective.and => a & b,
        BinaryLogicalConnective.or => a || b,
        BinaryLogicalConnective.xor => a ^ b,
        BinaryLogicalConnective.nand => !(a & b),
        BinaryLogicalConnective.nor => !a & !b,
      };
}

extension JoinPredicates<T> on Predicate<T> {
  Predicate<T> join(Predicate<T> other, BinaryLogicalConnective relation) =>
      relation.join(this, other);
}
