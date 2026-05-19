import 'package:custom_dashboard/src/pages/services/info_dialog.dart';

import '../../../common.dart';
import 'add_or_edit_app_service/dialog.dart';
import 'controller.dart';

class ServicesPage extends ConsumerStatefulWidget {
  const ServicesPage({super.key});

  @override
  ConsumerState<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends ConsumerState<ServicesPage>
    with SearchFormGroup {
  late PagingController<String?, Service> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<String?, Service>(
      getNextPageKey: (PagingState<String?, Service> state) {
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
            .read(serviceControllerProvider.notifier)
            .listServices(pageKey: pageKey);
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
    return AppBoard<Service>(
      pageHeadline: l10n.services,
      tableLabel: l10n.services,
      tableColumns: [
        ColumnDefinition<Service>(
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
          cellInfoAccessor: (item) {
            return AppText(item.name);
          },
          label: AppText('title'),
        ),
        ColumnDefinition<Service>(
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
        ColumnDefinition<Service>(
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
              await AddOrEditAppServiceDialog.show(context, null);
            },
            icon: Icons.add,
            tooltip: '${l10n.add} ${l10n.service}',
            child: AppText('${l10n.add} ${l10n.service}'),
          ),
        ];
      },
      rowActions: [
        CardAction(
          label: (item) => '${l10n.edit} ${l10n.service}',
          onTap: (item) async {
            await AddOrEditAppServiceDialog.show(context, item);
          },
        ),
        CardAction(
          label: (item) => 'View Details',
          onTap: (item) async {
            await ServiceInfoDialog.show(context, item);
          },
        ),
      ],
      pagingController: _pagingController,
      searchFormGroup: searchFG,
      searchBarHint: l10n.search,
    );
  }
}
