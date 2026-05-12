import '../../../common.dart';
import 'controller.dart';

class FilesPage extends ConsumerStatefulWidget {
  const FilesPage({super.key});

  @override
  ConsumerState<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends ConsumerState<FilesPage> with SearchFormGroup {
  late PagingController<String?, File> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<String?, File>(
      getNextPageKey: (PagingState<String?, File> state) {
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
            .read(fileControllerProvider.notifier)
            .listFiles(pageKey);
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
    final files = ref.watch(fileControllerProvider).files;
    return AppBoard<File>(
      pageHeadline: l10n.files,
      tableLabel: l10n.files,
      pagingController: _pagingController,
      searchFormGroup: searchFG,
      searchBarHint: l10n.search,
      tableColumns: [
        ColumnDefinition<File>(
          minWidth: 40,
          flex: 0,
          cellInfoAccessor: (e) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            height: 40,
            width: 40,
            child: AppNetworkImage(url: e.url),
          ),
          label: SizedBox(width: 40),
        ),
        ColumnDefinition(
          minWidth: 40,
          cellInfoAccessor: (item) {
            return AppText(item.name);
          },
          label: AppText('name'),
        ),
        ColumnDefinition(
          minWidth: 40,
          cellInfoAccessor: (item) {
            return AppText(getFileType(item.type));
          },
          label: AppText('type'),
        ),
        ColumnDefinition(
          minWidth: 40,
          cellInfoAccessor: (item) {
            return AppText(DateFormat('dd-MM-yyyy').format(item.createdAt));
          },
          label: AppText('Created at'),
        ),
      ],
      tableActionsBuilder: (context, items, onRefresh) {
        return [];
      },
      rowActions: const [],
      statisticsCards: [
        StatisticsCard(
          backgroundColor: ColorManager.surfaceWhite,
          title: l10n.files,
          number: files.length,
          textColor: Colors.black,
          borderColor: ColorManager.brownNormal,
        ),
        StatisticsCard(
          backgroundColor: ColorManager.surfaceWhite,
          title: l10n.files,
          number: files.length,
          textColor: Colors.black,
          borderColor: ColorManager.brownNormal,
        ),
        StatisticsCard(
          backgroundColor: ColorManager.surfaceWhite,
          title: l10n.files,
          number: files.length,
          textColor: Colors.black,
          borderColor: ColorManager.brownNormal,
        ),
        StatisticsCard(
          backgroundColor: ColorManager.surfaceWhite,
          title: l10n.files,
          number: files.length,
          textColor: Colors.black,
          borderColor: ColorManager.brownNormal,
        ),
      ],
    );
  }
}
