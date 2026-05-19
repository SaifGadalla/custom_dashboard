import '../../../common.dart';
import 'add_or_edit_app_article/dialog.dart';
import 'info_dialog.dart';

import 'controller.dart';

class ArticlesPage extends ConsumerStatefulWidget {
  const ArticlesPage({super.key});

  @override
  ConsumerState<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends ConsumerState<ArticlesPage>
    with SearchFormGroup {
  late PagingController<String?, Article> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<String?, Article>(
      getNextPageKey: (state) {
        final pages = state.pages;
        if (pages == null || pages.isEmpty) return '';
        final lastPage = pages.last;
        if (lastPage.length < kPageSize) return null;
        return lastPage.last.id;
      },
      fetchPage: (String? pageKey) async {
        final query = searchFG.control(kSearchFCN).value as String?;
        return await ref
            .read(articleControllerProvider.notifier)
            .listArticles(pageKey: pageKey, query: query);
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
    return AppBoard<Article>(
      pageHeadline: l10n.articles,
      tableLabel: l10n.articles,
      tableColumns: [
        ColumnDefinition<Article>(
          minWidth: 40,
          flex: 0,
          cellInfoAccessor: (e) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            height: 40,
            width: 40,
            child: AppNetworkImage(url: e.imageUrl),
          ),
          label: SizedBox(width: 40),
        ),
        ColumnDefinition(
          minWidth: 40,
          cellInfoAccessor: (item) {
            return AppText(item.id);
          },
          label: AppText('id'),
        ),
        ColumnDefinition(
          minWidth: 120,
          cellInfoAccessor: (item) {
            return AppText(item.title);
          },
          label: AppText('title'),
        ),
        ColumnDefinition<Article>(
          minWidth: 140,
          label: AppText(
            'Created at',
            // style: displayExtraSmallSemiBold,
          ),
          cellInfoAccessor: (item) {
            final createdAt = item.createdAt;
            return AppText(DateFormat('MMM dd, yyyy').format(createdAt));
          },
        ),
        ColumnDefinition<Article>(
          minWidth: 140,
          label: AppText(
            'Updated at',
            // style: displayExtraSmallSemiBold,
          ),
          cellInfoAccessor: (item) {
            final updatedAt = item.updatedAt;
            return AppText(DateFormat('MMM dd, yyyy').format(updatedAt));
          },
        ),
      ],
      tableActionsBuilder: (context, items, onRefresh) {
        return [
          AppButton(
            onTap: () async {
              final result = await AddOrEditArticleDialog.show(context, null);
              if (result != null) {
                _pagingController.refresh();
              }
            },
            icon: Icons.add,
            tooltip: '${l10n.add} ${l10n.article}',
            child: AppText('${l10n.add} ${l10n.article}'),
          ),
        ];
      },
      rowActions: [
        CardAction(
          label: (item) => 'View Details',
          onTap: (item) async {
            await ArticleInfoDialog.show(context, item);
          },
        ),
        CardAction(
          label: (item) => '${l10n.edit} ${l10n.article}',
          onTap: (item) async {
            final result = await AddOrEditArticleDialog.show(context, item);
            if (result != null) {
              _pagingController.refresh();
            }
          },
        ),
      ],
      pagingController: _pagingController,
      searchFormGroup: searchFG,
      searchBarHint: l10n.search,
      onSearchFieldChanged: (p0) {
        _pagingController.refresh();
      },
    );
  }
}
