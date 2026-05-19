import '../../../common.dart';
import 'controller.dart';
import 'info_dialog.dart';

class FilesPage extends ConsumerStatefulWidget {
  const FilesPage({super.key});

  @override
  ConsumerState<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends ConsumerState<FilesPage> with SearchFormGroup {
  late PagingController<String?, AppFile> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<String?, AppFile>(
      getNextPageKey: (PagingState<String?, AppFile> state) {
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
        final query = searchFG.control(kSearchFCN).value as String?;
        return await ref
            .read(fileControllerProvider.notifier)
            .listFiles(pageKey, query: query);
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
    final state = ref.watch(fileControllerProvider);
    final totalFiles = state.statisticsFiles;
    final images = totalFiles.where((f) => f.type == 'image').toList();
    final videos = totalFiles.where((f) => f.type == 'video').toList();
    final others = totalFiles.where((f) => f.type == 'other').toList();
    if (ref.watch(fileControllerProvider).isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return AppBoard<AppFile>(
      pageHeadline: l10n.files,
      tableLabel: l10n.files,
      pagingController: _pagingController,
      searchFormGroup: searchFG,
      searchBarHint: l10n.search,
      onSearchFieldChanged: (p0) {
        _pagingController.refresh();
      },
      tableColumns: [
        ColumnDefinition<AppFile>(
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
        return [
          AppButton(
            icon: Icons.refresh,
            isLoading: state.isLoading,
            onTap: () async {
              _pagingController.refresh();
            },
            tooltip: context.l10n.refresh,
            child: AppText(context.l10n.refresh),
          ),
          AppButton(
            icon: Icons.upload,
            isLoading: state.isLoading,
            onTap: () async {
              await ref.read(fileControllerProvider.notifier).uploadFile();
              _pagingController.refresh();
            },
            tooltip: context.l10n.click_to_upload,
            child: AppText(context.l10n.click_to_upload),
          ),
        ];
      },
      rowActions: [
        CardAction(
          label: (item) => 'View Details',
          onTap: (item) async {
            await FileInfoDialog.show(context, item);
          },
        ),
      ],
      statisticsCards: [
        StatisticsCard(
          backgroundColor: ColorManager.surfaceWhite,
          title: l10n.total,
          number: totalFiles.length,
          textColor: Colors.black,
          borderColor: ColorManager.brownNormal,
        ),
        StatisticsCard(
          backgroundColor: ColorManager.surfaceWhite,
          title: l10n.images,
          number: images.length,
          textColor: Colors.black,
          borderColor: ColorManager.brownNormal,
        ),
        StatisticsCard(
          backgroundColor: ColorManager.surfaceWhite,
          title: l10n.videos,
          number: videos.length,
          textColor: Colors.black,
          borderColor: ColorManager.brownNormal,
        ),
        StatisticsCard(
          backgroundColor: ColorManager.surfaceWhite,
          title: l10n.files,
          number: others.length,
          textColor: Colors.black,
          borderColor: ColorManager.brownNormal,
        ),
      ],
    );
  }
}
