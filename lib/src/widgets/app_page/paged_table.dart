import 'dart:async';

import '../../../common.dart';

class PagedTable<T> extends StatefulWidget {
  const PagedTable({
    super.key,
    required this.pagingController,
    required this.columns,
    required this.tableActionsBuilder,
    required this.label,
    required this.rowActions,
  });

  final PagingController<String?, T> pagingController;
  final List<ColumnDefinition<T>> columns;
  final List<Widget> Function(
    BuildContext context,
    List<T> selectedItems,
    VoidCallback emptySelectedItems,
  )
  tableActionsBuilder;
  final String label;
  final List<CardAction<T>> rowActions;

  @override
  State<PagedTable<T>> createState() => _PagedTableState<T>();
}

class _PagedTableState<T> extends State<PagedTable<T>> {
  static const _minColumnWidth = 100.0;
  static const _maxColumnWidth = 480.0;
  static const _checkboxColumnWidth = 24.0;
  static const _columnSpacing = 8.0;
  static const _actionsColumnWidth = 56.0;

  final ValueNotifier<double> _horizontalOffset = ValueNotifier<double>(0);
  List<T> selectedItems = [];
  late List<int> _columnOrder;
  late Map<int, double> _columnWidthOverrides;

  @override
  void initState() {
    super.initState();
    _resetColumnState();
  }

  @override
  void didUpdateWidget(covariant PagedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.columns.length != widget.columns.length) {
      _resetColumnState();
    }
  }

  @override
  void dispose() {
    _horizontalOffset.dispose();
    super.dispose();
  }

  void _resetColumnState() {
    _columnOrder = List.generate(widget.columns.length, (index) => index);
    _columnWidthOverrides = <int, double>{};
  }

  bool get _hasColumnChanges {
    if (_columnWidthOverrides.isNotEmpty) return true;
    final defaultOrder = List.generate(widget.columns.length, (index) => index);
    if (_columnOrder.length != defaultOrder.length) return true;
    for (var i = 0; i < _columnOrder.length; i++) {
      if (_columnOrder[i] != defaultOrder[i]) return true;
    }
    return false;
  }

  void _resetTableDefaults() {
    setState(() {
      _resetColumnState();
      _horizontalOffset.value = 0;
    });
  }

  void emptySelectedItems() {
    setState(() {
      selectedItems.clear();
    });
  }

  String _columnDisplayName(int columnIndex) {
    final labelWidget = widget.columns[columnIndex].label;

    if (labelWidget is AppText) {
      return labelWidget.text;
    }
    if (labelWidget is Text) {
      return labelWidget.data ?? 'Column ${columnIndex + 1}';
    }
    return 'Column ${columnIndex + 1}';
  }

  Future<void> _showReorderColumnsDialog(BuildContext context) async {
    final tempOrder = List<int>.from(_columnOrder);

    final apply = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.reorder_columns),
          content: SizedBox(
            width: 560,
            child: ReorderableListView.builder(
              shrinkWrap: true,
              itemCount: tempOrder.length,
              onReorder: (oldIndex, newIndex) {
                setDialogState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final moved = tempOrder.removeAt(oldIndex);
                  tempOrder.insert(newIndex, moved);
                });
              },
              itemBuilder: (context, position) {
                final columnIndex = tempOrder[position];
                return Padding(
                  key: ValueKey(columnIndex),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(_columnDisplayName(columnIndex))),
                      const Icon(Icons.drag_handle),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.apply),
            ),
          ],
        ),
      ),
    );

    if (apply == true && mounted) {
      setState(() {
        _columnOrder = tempOrder;
      });
    }
  }

  void _resizeColumn(int originalIndex, double delta) {
    setState(() {
      final minWidth = _resolveMinWidth(widget.columns[originalIndex]);
      final current = (_columnWidthOverrides[originalIndex] ?? minWidth).clamp(
        minWidth,
        _maxColumnWidth,
      );
      final resized = (current + delta).clamp(minWidth, _maxColumnWidth);
      _columnWidthOverrides[originalIndex] = resized;
    });
  }

  double _resolveMinWidth(ColumnDefinition<T> column) {
    return (column.minWidth ?? _minColumnWidth).clamp(0.0, _maxColumnWidth);
  }

  List<double> _buildFlexWidths(
    List<ColumnDefinition<T>> orderedColumns,
    double availableColumnsWidth,
  ) {
    if (orderedColumns.isEmpty) {
      return const [];
    }

    final minWidths = orderedColumns
        .map((column) => _resolveMinWidth(column))
        .toList(growable: false);

    final totalFlex = orderedColumns.fold<int>(
      0,
      (sum, column) => sum + (column.flex ?? 1),
    );

    final baseWidths = List<double>.generate(orderedColumns.length, (index) {
      final minWidth = minWidths[index];
      if (totalFlex <= 0) {
        return minWidth;
      }
      final flex = orderedColumns[index].flex ?? 1;
      final flexWidth = availableColumnsWidth * (flex / totalFlex);
      return flexWidth.clamp(minWidth, _maxColumnWidth);
    });

    final baseTotal = baseWidths.fold<double>(0, (sum, width) => sum + width);
    if (baseTotal >= availableColumnsWidth) {
      return baseWidths;
    }

    var remaining = availableColumnsWidth - baseTotal;
    for (var i = 0; i < baseWidths.length && remaining > 0; i++) {
      final room = _maxColumnWidth - baseWidths[i];
      if (room <= 0) {
        continue;
      }
      final grow = room < remaining ? room : remaining;
      baseWidths[i] += grow;
      remaining -= grow;
    }

    return baseWidths;
  }

  List<double> _applyOverrides(
    List<ColumnDefinition<T>> orderedColumns,
    List<double> flexWidths,
  ) {
    return List<double>.generate(orderedColumns.length, (orderedIndex) {
      final originalIndex = _columnOrder[orderedIndex];
      final minWidth = _resolveMinWidth(orderedColumns[orderedIndex]);
      final override = _columnWidthOverrides[originalIndex];
      return (override ?? flexWidths[orderedIndex]).clamp(
        minWidth,
        _maxColumnWidth,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final isTabletOrLess = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: true,
      desktop: false,
    );
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final orderedColumns = _columnOrder
        .map((index) => widget.columns[index])
        .toList(growable: false);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: ColorManager.surfaceActive),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 26),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: ValueListenableBuilder(
                    valueListenable: widget.pagingController,
                    builder: (context, value, child) => isTabletOrLess
                        ? Text(
                            '(${value.items?.length ?? 0})',
                            style: textTheme.titleMedium,
                          )
                        : Text(
                            '${widget.label} (${value.items?.length ?? 0})',
                            style: textTheme.titleMedium,
                          ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.end,
                    children: [
                      IconButton(
                        tooltip: 'Reorder Columns',
                        onPressed: () async =>
                            _showReorderColumnsDialog(context),
                        icon: const Icon(Icons.view_column_outlined),
                      ),
                      IconButton(
                        tooltip: l10n.reset,
                        onPressed: _hasColumnChanges
                            ? _resetTableDefaults
                            : null,
                        icon: const Icon(Icons.restart_alt_outlined),
                      ),
                      ...widget.tableActionsBuilder(
                        context,
                        selectedItems,
                        emptySelectedItems,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final dataViewportWidth =
                  (constraints.maxWidth - _actionsColumnWidth - 8).clamp(
                    0.0,
                    double.infinity,
                  );
              final spacingWidth = orderedColumns.isEmpty
                  ? 0.0
                  : orderedColumns.length * _columnSpacing;
              final availableColumnsWidth =
                  (dataViewportWidth - _checkboxColumnWidth - spacingWidth)
                      .clamp(0.0, double.infinity);
              final flexWidths = _buildFlexWidths(
                orderedColumns,
                availableColumnsWidth,
              );
              final effectiveWidths = _applyOverrides(
                orderedColumns,
                flexWidths,
              );
              final currentColumnsWidth = effectiveWidths.fold<double>(
                0,
                (sum, width) => sum + width,
              );
              final currentTotal =
                  _checkboxColumnWidth + spacingWidth + currentColumnsWidth;
              final dataSectionWidth = currentTotal > dataViewportWidth
                  ? currentTotal
                  : dataViewportWidth;

              if (effectiveWidths.isNotEmpty) {
                final remaining = (dataSectionWidth - currentTotal).clamp(
                  0.0,
                  double.infinity,
                );
                if (remaining > 0) {
                  final totalFlex = orderedColumns.fold<int>(
                    0,
                    (sum, column) => sum + (column.flex ?? 1),
                  );
                  if (totalFlex > 0) {
                    for (var i = 0; i < effectiveWidths.length; i++) {
                      final flex = orderedColumns[i].flex ?? 1;
                      effectiveWidths[i] += remaining * (flex / totalFlex);
                    }
                  } else {
                    effectiveWidths[effectiveWidths.length - 1] += remaining;
                  }
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 56.0,
                    padding: const EdgeInsets.all(8.0),
                    color: ColorManager.surfaceLight,
                    child: Row(
                      spacing: 8,
                      children: [
                        SizedBox(
                          width: _checkboxColumnWidth,
                          child: ValueListenableBuilder(
                            valueListenable: widget.pagingController,
                            builder: (context, value, child) => AppCheckBox(
                              tristate: true,
                              checkBoxValue: selectedItems.isEmpty
                                  ? false
                                  : selectedItems.length ==
                                        (value.items?.length ?? 0)
                                  ? true
                                  : null,
                              onChanged: (newValue) => setState(() {
                                if (newValue == true) {
                                  selectedItems = List<T>.from(
                                    value.items ?? [],
                                  );
                                } else {
                                  selectedItems.clear();
                                }
                              }),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _SyncedHorizontalScroll(
                            offsetNotifier: _horizontalOffset,
                            child: SizedBox(
                              width: dataSectionWidth,
                              child: Row(
                                spacing: _columnSpacing,
                                children: [
                                  ...orderedColumns.indexed.map(
                                    (entry) => SizedBox(
                                      width: effectiveWidths[entry.$1],
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            child: entry.$2.label,
                                          ),
                                          PositionedDirectional(
                                            end: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors
                                                  .resizeColumn,
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onHorizontalDragUpdate:
                                                    (details) {
                                                      _resizeColumn(
                                                        _columnOrder[entry.$1],
                                                        isRtl
                                                            ? -details.delta.dx
                                                            : details.delta.dx,
                                                      );
                                                    },
                                                child: Container(
                                                  width: 10,
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    width: 1,
                                                    color: ColorManager
                                                        .surfaceActive,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: _actionsColumnWidth,
                          child: AppText(
                            l10n.actions,
                            style: textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PagingListener(
                    controller: widget.pagingController,
                    builder: (context, state, fetchNextPage) => PagedListView(
                      shrinkWrap: true,
                      state: state,
                      fetchNextPage: fetchNextPage,
                      builderDelegate: PagedChildBuilderDelegate<T>(
                        noItemsFoundIndicatorBuilder: (context) =>
                            Center(child: Text(l10n.no_elements_to_display)),
                        itemBuilder: (context, item, index) => Container(
                          height: 60,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: ColorManager.surfaceActive,
                              ),
                            ),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              SizedBox(
                                width: _checkboxColumnWidth,
                                child: AppCheckBox(
                                  checkBoxValue: selectedItems.contains(item),
                                  onChanged: (newValue) => setState(() {
                                    if (newValue == true) {
                                      selectedItems.add(item);
                                    } else {
                                      selectedItems.remove(item);
                                    }
                                  }),
                                ),
                              ),
                              Expanded(
                                child: _SyncedHorizontalScroll(
                                  offsetNotifier: _horizontalOffset,
                                  child: SizedBox(
                                    width: dataSectionWidth,
                                    child: Row(
                                      spacing: _columnSpacing,
                                      children: [
                                        ...orderedColumns.indexed.map(
                                          (entry) => SizedBox(
                                            width: effectiveWidths[entry.$1],
                                            child: entry.$2.cellInfoAccessor(
                                              item,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: _actionsColumnWidth,
                                child:
                                    PopupMenuButton<
                                      FutureOr<void> Function(T)?
                                    >(
                                      tooltip: l10n.actions,
                                      color: ColorManager.surfaceWhite,
                                      onSelected: (value) => value?.call(item),
                                      itemBuilder: (context) =>
                                          widget.rowActions.map((a) {
                                            final enabled =
                                                a.isEnabled?.call(item) ?? true;
                                            return PopupMenuItem(
                                              enabled: enabled,
                                              value: enabled ? a.onTap : null,
                                              child: Text(
                                                a.label(item),
                                                style: enabled
                                                    ? null
                                                    : TextStyle(
                                                        color: ColorManager
                                                            .greyLighter,
                                                      ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SyncedHorizontalScroll extends StatefulWidget {
  const _SyncedHorizontalScroll({
    required this.offsetNotifier,
    required this.child,
  });

  final ValueNotifier<double> offsetNotifier;
  final Widget child;

  @override
  State<_SyncedHorizontalScroll> createState() =>
      _SyncedHorizontalScrollState();
}

class _SyncedHorizontalScrollState extends State<_SyncedHorizontalScroll> {
  late final ScrollController _controller;
  bool _syncingFromNotifier = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: widget.offsetNotifier.value,
    );
    _controller.addListener(_onControllerChanged);
    widget.offsetNotifier.addListener(_onNotifierChanged);
  }

  @override
  void didUpdateWidget(covariant _SyncedHorizontalScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.offsetNotifier != widget.offsetNotifier) {
      oldWidget.offsetNotifier.removeListener(_onNotifierChanged);
      widget.offsetNotifier.addListener(_onNotifierChanged);
    }
  }

  void _onControllerChanged() {
    if (_syncingFromNotifier) {
      return;
    }

    final offset = _controller.offset;
    if ((widget.offsetNotifier.value - offset).abs() > 0.5) {
      widget.offsetNotifier.value = offset;
    }
  }

  void _onNotifierChanged() {
    if (!_controller.hasClients) {
      return;
    }

    final target = widget.offsetNotifier.value
        .clamp(0.0, _controller.position.maxScrollExtent)
        .toDouble();
    if ((_controller.offset - target).abs() <= 0.5) {
      return;
    }

    _syncingFromNotifier = true;
    _controller.jumpTo(target);
    _syncingFromNotifier = false;
  }

  @override
  void dispose() {
    widget.offsetNotifier.removeListener(_onNotifierChanged);
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: widget.child,
    );
  }
}
