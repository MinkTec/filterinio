import '../../filterinio.dart';

sealed class FilterTreeNode {
  String? get debugPrintId;

  FilterTreeNode? find(FilterTreeNode node) {
    if (this == node) {
      return this;
    } else if (this is FilterDimension) {
      return null;
    } else {
      final op = this as OperatorTreeNode;
      return op.left.find(node) ?? op.right.find(node);
    }
  }

  FilterTreeNode? findParent(
    FilterTreeNode node,
  ) {
    if (this == node) {
      throw ArgumentError("node is root");
    } else if (this is OperatorTreeNode) {
      final n = this as OperatorTreeNode;
      if (n.left == node || n.right == node) {
        return this;
      }

      return n.left.findParent(node) ?? n.right.findParent(node);
    } else {
      return null;
    }
  }
}

class OperatorTreeNode extends FilterTreeNode {
  BinaryLogicalConnective operator;

  FilterTreeNode left;
  FilterTreeNode right;

  OperatorTreeNode({
    required this.operator,
    this.debugPrintId,
    required this.left,
    required this.right,
  });

  @override
  String? debugPrintId;
}

abstract class FilterDimension<T> extends FilterTreeNode {
  UnaryLogicalConnective unaryConnective;

  FilterDimension({
    this.unaryConnective = UnaryLogicalConnective.confirm,
    this.debugPrintId,
  });

  bool Function(T value) predicate();

  bool evaluate(T value) => predicate()(value);

  @override
  String? debugPrintId;
}
