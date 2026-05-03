import 'package:custom_dashboard/common.dart';

class AppBoard<T> extends StatelessWidget {
  const AppBoard({
    super.key,
    required this.pageHeadline,
    required this.tableLabel,
    required this.tableColumns,
    required this.tableActionsBuilder,
    required this.rowActions,
    required this.pagingController,
    required this.searchFormGroup,
    this.statisticsCards = const [],
    this.onSearchSubmit,
    this.onSearchFieldChanged,
    required this.searchBarHint,
  });

  final String pageHeadline;
  final String tableLabel;
  final List<ColumnDefinition<T>> tableColumns;
  final List<Widget> Function(BuildContext, List<T>, VoidCallback)
  tableActionsBuilder;
  final List<CardAction<T>> rowActions;
  final PagingController<Int64, T> pagingController;
  final FormGroup searchFormGroup;
  final List<StatisticsCard> statisticsCards;
  final void Function(FormControl<String>)? onSearchSubmit;
  final String searchBarHint;
  final void Function(FormControl<String>)? onSearchFieldChanged;
  @override
  Widget build(BuildContext context) {
    final isTabletOrLess = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: true,
      desktop: false,
    );

    final colorScheme = Theme.of(context).colorScheme;
    //TODO: find a suitable replacment for bdayaLoadableArea
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(32),
          color: colorScheme.surface,
          child: Column(
            spacing: 32,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                isTabletOrLess: isTabletOrLess,
                searchFG: searchFormGroup,
                label: pageHeadline,
                onSearchSubmit: onSearchSubmit,
                searchBarHint: searchBarHint,
                onSearchFieldChanged: onSearchFieldChanged,
              ),
              Wrap(runSpacing: 24, spacing: 24, children: statisticsCards),
              PagedTable<T>(
                tableActionsBuilder: tableActionsBuilder,
                rowActions: rowActions,
                label: tableLabel,
                columns: tableColumns,
                pagingController: pagingController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.searchFG,
    required this.isTabletOrLess,
    required this.label,
    required this.searchBarHint,
    this.onSearchSubmit,
    this.onSearchFieldChanged,
  });

  final FormGroup searchFG;
  final bool isTabletOrLess;
  final String label;
  final String searchBarHint;
  final void Function(FormControl<String>)? onSearchSubmit;
  final void Function(FormControl<String>)? onSearchFieldChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // TODO: add after adding AppText and AppSearchBar properties
    final widgets = [
      Text(label),
      SearchBar(),
      // AppText(
      //   label,
      //   style: textTheme.headlineLarge?.copyWith(
      //     color: colorScheme.onSecondary,
      //   ),
      // ),
      // AppSearchBar(
      //   formGroup: searchFG,
      //   hintText: context.searchSomethingOf(searchBarHint),
      //   onSearchFieldSubmit: onSearchSubmit,
      //   onSearchFieldChanged: onSearchFieldChanged,
      // ),
    ];
    if (isTabletOrLess) {
      return Column(spacing: 24, children: widgets);
    } else {
      return Row(
        children: widgets
            .mapIndexed(
              (index, e) => Expanded(flex: index == 0 ? 3 : 2, child: e),
            )
            .toList(),
      );
    }
  }
}

class StatisticsCard extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final int number;
  final Color textColor;
  final Color borderColor;

  const StatisticsCard({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.number,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isScreenSmall = MediaQuery.of(context).size.width <= 1340;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: !isScreenSmall
          ? (MediaQuery.of(context).size.width - 312 - 48 - 64 - 9) / 3
          : 192.5,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        // TODO: add after adding AppText properties
        children: [
          Text(title),
          // AppText(
          //   title,
          //   style: textTheme.labelLarge?.copyWith(color: textColor),
          // ),
          Text(number.toString()),
          // AppText(
          //   number.toString(),
          //   style: textTheme.displayLarge?.copyWith(
          //     color: colorScheme.onSecondary,
          //   ),
          // ),
        ],
      ),
    );
  }
}
