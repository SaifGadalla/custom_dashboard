import '../../../common.dart';

class ColumnDefinition<T> extends DataColumn {
  const ColumnDefinition({
    required this.cellInfoAccessor,
    required super.label,
    this.flex,
    this.minWidth,
  });

  final Widget Function(T item) cellInfoAccessor;
  final int? flex;
  final double? minWidth;
}
