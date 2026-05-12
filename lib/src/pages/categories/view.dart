import '../../../common.dart';

import 'controller.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage>
    with SearchFormGroup {
  late PagingController<String?, Category> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<String?, Category>(
      getNextPageKey: (PagingState<String?, Category> state) {
        final pages = state.pages;
        // No pages loaded yet — return empty string to trigger first fetch
        if (pages == null || pages.isEmpty) return '';

        // Last page was smaller than page size — no more pages
        final lastPage = pages.last;
        if (lastPage.length < kPageSize) return null;

        // Use the last document ID as the cursor for the next page
        return lastPage.last.id;
      },
      fetchPage: (String? pageKey) async {
        return await ref
            .read(categoriesControllerProvider.notifier)
            .listCategories(pageKey);
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBoard<Category>(
      pageHeadline: l10n.categories,
      tableLabel: l10n.categories,
      tableColumns: [
        ColumnDefinition<Category>(
          minWidth: 40,
          flex: 0,
          cellInfoAccessor: (e) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            height: 40,
            width: 40,
            child: AppNetworkImage(url: e.image ?? ''),
          ),
          label: SizedBox(width: 40),
        ),
        ColumnDefinition(
          minWidth: 40,
          cellInfoAccessor: (item) {
            return AppText(item.id ?? '-');
          },
          label: AppText('id'),
        ),
        ColumnDefinition(
          minWidth: 120,
          cellInfoAccessor: (item) {
            return AppText(item.name ?? '-');
          },
          label: AppText('title'),
        ),
        ColumnDefinition<Category>(
          minWidth: 140,
          label: AppText(
            'Created at',
            // style: displayExtraSmallSemiBold,
          ),
          cellInfoAccessor: (item) {
            final createdAt = item.createdAt;
            return AppText(
              createdAt == null
                  ? '-'
                  : DateFormat('MMM dd, yyyy').format(createdAt),
            );
          },
        ),
        ColumnDefinition<Category>(
          minWidth: 140,
          label: AppText(
            'Updated at',
            // style: displayExtraSmallSemiBold,
          ),
          cellInfoAccessor: (item) {
            final updatedAt = item.updatedAt;
            return AppText(
              updatedAt == null
                  ? '-'
                  : DateFormat('MMM dd, yyyy').format(updatedAt),
            );
          },
        ),
      ],
      tableActionsBuilder: (context, items, onRefresh) {
        return [
          AppButton(
            // onTap: () async {
            //   await AddOrEditArticleDialog.show(
            //     context,
            //     params: AddOrEditArticleDialogParams(),
            //   );
            // },
            icon: Icons.add,
            tooltip: '${l10n.add} ${l10n.article}',
            child: AppText('${l10n.add} ${l10n.article}'),
          ),
        ];
      },
      rowActions: const [],
      pagingController: _pagingController,
      searchFormGroup: searchFG,
      searchBarHint: l10n.search,
    );
  }
}
