import '../connectives/binary.dart';
import '../dimensions/truth.dart';
import 'nodes.dart';

class FilterTree {
  FilterTree();

  factory FilterTree.fromFilters(Iterable<FilterDimension> filters) {
    final x = FilterTree()..setRootFilterDimension(filters.first);
    for (var filter in filters.skip(1)) {
      x.add(
          operator: BinaryLogicalConnective.and,
          dimension: filter,
          sibling: filters.first);
    }
    return x;
  }

  FilterTreeNode? root = TruthFilterDimension();

  final List<FilterDimension> _dimensions = [];

  bool evaluate(
    Map<FilterDimension, dynamic> data, {
    bool valueOnInvalidData = false,
  }) {
    if (!({...data.keys}.intersection({..._dimensions}).length ==
        _dimensions.length)) {
      throw ArgumentError("data map is invalid");
    }
    return _evaluateNode(root!, data, valueOnInvalidData);
  }

  String expressionString([FilterTreeNode? node]) {
    node ??= root;
    if (node is FilterDimension) {
      return node.debugPrintId.toString();
    } else if (node is OperatorTreeNode) {
      return "(${expressionString(node.left)} ${node.operator.name} ${expressionString(node.right)})";
    } else {
      return node?.debugPrintId ?? "-";
    }
  }

  String evaluatedExpressionString({
    required Map<FilterDimension, dynamic> data,
    FilterTreeNode? node,
  }) {
    node ??= root;
    if (node is FilterDimension) {
      return """${node.debugPrintId ?? "-"}: ${node.evaluate(data[node])}""";
    } else if (node is OperatorTreeNode) {
      return "(${evaluatedExpressionString(data: data, node: node.left)} ${node.operator.name} ${evaluatedExpressionString(data: data, node: node.right)})";
    } else {
      return "";
    }
  }

  bool _evaluateNode(FilterTreeNode node, Map<FilterDimension, dynamic> map,
      bool valueOnInvalidData) {
    if (node is OperatorTreeNode) {
      return node.operator.evaluate(
          _evaluateNode(node.left, map, valueOnInvalidData),
          _evaluateNode(node.right, map, valueOnInvalidData));
    } else {
      try {
        return (node as FilterDimension).evaluate(map[node]);
      } catch (e) {
        return valueOnInvalidData;
      }
    }
  }

  void setRootFilterDimension(FilterDimension root) {
    this.root = root;
  }

  void add({
    required BinaryLogicalConnective operator,
    required FilterDimension dimension,
    required FilterTreeNode sibling,
  }) {
    assert(root != null);
    if (sibling == root) {
      root = OperatorTreeNode(
        debugPrintId: "root",
        operator: operator,
        left: root!,
        right: dimension,
      );
    } else {
      final x = root!.find(sibling);
      if (x == null) {
        throw ArgumentError("parent not in tree");
      }

      final parent = root!.findParent(sibling) as OperatorTreeNode;

      final newChild = OperatorTreeNode(
          left: dimension,
          right: sibling,
          operator: operator,
          debugPrintId: operator.name);

      if (parent.left == sibling) {
        parent.left = newChild;
      } else {
        parent.right = newChild;
      }
    }
    _dimensions.add(dimension);
  }

  void remove(FilterDimension dimension) {
    if (root!.find(dimension) == null) {
      throw ArgumentError("node ${dimension.debugPrintId} is not in tree");
    }

    if (dimension == root) {
      root = TruthFilterDimension();
      _dimensions.remove(dimension);
      return;
    }

    final parent = root!.findParent(dimension) as OperatorTreeNode;

    if (parent == root) {
      if (parent.left == dimension) {
        root = parent.right;
      } else {
        root = parent.left;
      }
      _dimensions.remove(dimension);
      return;
    }

    final grandParent = root!.findParent(parent) as OperatorTreeNode;
    final sibling = parent.left == dimension ? parent.right : parent.left;

    if (grandParent.left == parent) {
      grandParent.left = sibling;
    } else {
      grandParent.right = sibling;
    }
    _dimensions.remove(dimension);
  }

  @override
  String toString() => "Filterinio{${expressionString()}}";
}
