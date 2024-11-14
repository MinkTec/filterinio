import '../models/displayable.dart';
import '../types.dart';

part 'binary.dart';
part 'ternary.dart';

sealed class ComparisonEnum implements Displayable {
  String get enumName;
}
