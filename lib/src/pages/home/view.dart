import '../../../common.dart';
import '../../routes.dart';

import '../services/add_or_edit_app_service/dialog.dart';
import 'controller.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTabletOrLess = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: true,
      desktop: false,
    );

    final servicesLength = ref.watch(homeProvider).services.length;
    final filesLength = ref.watch(homeProvider).files.length;
    final articlesLength = ref.watch(homeProvider).articles.length;

    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    if (ref.watch(homeProvider).isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      padding: EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          spacing: 32,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  '${l10n.welcome_back}, ${ref.watch(authServiceProvider).currentUser?.name ?? ''}!',
                  style: textTheme.headlineLarge?.copyWith(
                    color: ColorManager.greyNormal,
                  ),
                ),
                AppText(l10n.home_description, style: textTheme.labelSmall),
              ],
            ),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                _buildNumberCard(
                  context,
                  title: l10n.articles,
                  number: articlesLength,
                  onPressed: () async {
                    // await AddOrEditArticleDialog.show(
                    //   context,
                    //   params: AddOrEditArticleDialogParams(
                    //     onSuccess: () async {
                    //       await controller.getArticles();
                    //       await controller.getFiles();
                    //     },
                    //   ),
                    // );
                  },
                ),
                _buildNumberCard(
                  context,
                  title: l10n.services,
                  number: servicesLength,
                  onPressed: () async {
                    final result = await AddOrEditAppServiceDialog.show(
                      context,
                      null,
                    );
                    if (result != null) {
                      ref.read(homeProvider.notifier).getServices();
                      ref.read(homeProvider.notifier).getFiles();
                    }
                  },
                ),
                _buildNumberCard(
                  context,
                  title: l10n.files,
                  number: filesLength,
                  // onPressed: () async {
                  //   await controller.pickAndUploadImage(
                  //     context: context,
                  //     pageId: 'home',
                  //     l10n: l10n,
                  //     la: controller.la,
                  //   );
                  //   await controller.getFiles();
                  // },
                ),
              ],
            ),
            isTabletOrLess
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 24,
                    children: [
                      _buildElementCardsSection(context, ref),
                      _buildAboutUsCardSection(context, ref),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 24,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildElementCardsSection(context, ref),
                      ),
                      Expanded(
                        flex: 2,
                        child: _buildAboutUsCardSection(context, ref),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutUsCardSection(BuildContext context, WidgetRef ref) {
    final aboutUs = ref.read(homeProvider).aboutUs;

    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    // final currentLocale = Localizations.localeOf(context).languageCode;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.surfaceWhite,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: ColorManager.surfaceActive),
      ),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 16,
            children: [
              HomeCardIcon(),
              Expanded(
                child: AppText(l10n.about_us, style: textTheme.labelMedium),
              ),
              Tooltip(
                message: l10n.edit,
                child: TextButton(
                  onPressed: () {
                    context.goNamed(AppRoutes.about);
                  },
                  child: AppText(l10n.edit, style: textTheme.bodySmall),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1, color: ColorManager.surfaceActive),
          ),
          AppText(
            l10n.vision,
            style: textTheme.labelLarge?.copyWith(
              color: ColorManager.greyNormal,
            ),
          ),
          AppText(aboutUs.vision, style: textTheme.bodySmall),
          Divider(height: 1, color: ColorManager.surfaceActive),
          AppText(
            l10n.mission,
            style: textTheme.labelLarge?.copyWith(
              color: ColorManager.greyNormal,
            ),
          ),
          AppText(aboutUs.mission, style: textTheme.bodySmall),
          Divider(height: 1, color: ColorManager.surfaceActive),
          AppText(
            l10n.description,
            style: textTheme.labelLarge?.copyWith(
              color: ColorManager.greyNormal,
            ),
          ),
          ...aboutUs.description.map(
            (e) => AppText(e, style: textTheme.bodySmall),
          ),
          Divider(height: 1, color: ColorManager.surfaceActive),
        ],
      ),
    );
  }

  Widget _buildElementCardsSection(BuildContext context, WidgetRef ref) {
    final article = ref.watch(homeProvider).articles.firstOrNull;
    final service = ref.watch(homeProvider).services.firstOrNull;
    final file = ref.watch(homeProvider).files.firstOrNull;

    final l10n = context.l10n;
    // final colorScheme = Theme.of(context).colorScheme;
    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      children: [
        // if (article != null)
        //   ElementCard(
        //     title: l10n.Article,
        //     onTap: () {
        //       context.goNamed(AppRoutes.articles);
        //     },
        //     onElementTap: () async {
        //       await ArticlesInfoDialog.show(
        //         context,
        //         params: ArticlesInfoDialogParams(selectedArticle: article),
        //       );
        //       await controller.getArticles();
        //     },
        //     elementName:
        //         article.headline.locales[currentLocale] ??
        //         article.headline.currentValue.getOrNull(
        //           (x) => x.value,
        //           (x) => x.hasValue(),
        //         ) ??
        //         article.headline.locales[kArLangCode] ??
        //         '',
        //     status: getPublishedWidget(article.isShown, l10n, colorScheme),
        //     category:
        //         article.category.categoryName.locales[currentLocale] ??
        //         article.category.categoryName.currentValue.getOrNull(
        //           (x) => x.value,
        //           (x) => x.hasValue(),
        //         ) ??
        //         article.category.categoryName.locales[kArLangCode] ??
        //         '',
        //   ),
        // if (service != null)
        //   ElementCard(
        //     title: l10n.Service,
        //     onTap: () {
        //       context.goNamed(AppRouteNames.kDashboardServices);
        //     },
        //     onElementTap: () async {
        //       await ServicesInfoDialog.show(
        //         context,
        //         params: ServicesInfoDialogParams(selectedService: service),
        //       );
        //       await controller.getServices();
        //     },
        //     elementName:
        //         service.serviceName.locales[currentLocale] ??
        //         service.serviceName.currentValue.getOrNull(
        //           (x) => x.value,
        //           (x) => x.hasValue(),
        //         ) ??
        //         service.serviceName.locales[kArLangCode] ??
        //         '',
        //     status: getPublishedWidget(service.isShown, l10n, colorScheme),
        //   ),
        // if (file != null)
        //   ElementCard(
        //     title: l10n.file,
        //     onTap: () {
        //       context.goNamed(AppRouteNames.kDashboardFilesManagement);
        //     },
        //     onElementTap: () async {
        //       await FilesInfoDialog.show(
        //         context: context,
        //         params: FilesInfoDialogParams(selectedFile: file),
        //       );
        //       await controller.getFiles();
        //     },
        //     elementName: file.fileName,
        //     status: getAppFileTypeColoredWidgetfromMimeType(
        //       file.mimeType,
        //       l10n,
        //       colorScheme: Theme.of(context).colorScheme,
        //     ),
        //   ),  if (article != null)
        ElementCard(
          title: l10n.articles,
          onTap: () {
            context.goNamed(AppRoutes.articles);
          },
          onElementTap: () async {
            context.goNamed(AppRoutes.articles);
          },
          elementName: article?.title ?? '',
          status: const SizedBox(),
          category: article?.category.name ?? '',
        ),
        if (service != null)
          ElementCard(
            title: l10n.services,
            onTap: () {
              context.goNamed(AppRoutes.services);
            },
            onElementTap: () async {
              context.goNamed(AppRoutes.services);
            },
            elementName: service.name,
            status: const SizedBox(),
          ),
        if (file != null)
          ElementCard(
            title: l10n.files,
            onTap: () {
              context.goNamed(AppRoutes.files);
            },
            onElementTap: () async {
              context.goNamed(AppRoutes.files);
            },
            elementName: file.name,
            status: const SizedBox(),
          ),
      ],
    );
  }

  Widget _buildNumberCard(
    BuildContext context, {
    required String title,
    required int number,
    void Function()? onPressed,
  }) {
    final isScreenSmall = MediaQuery.of(context).size.width <= 1340;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return Container(
      width: !isScreenSmall
          ? (MediaQuery.of(context).size.width - 312 - 96 - 64 - 11) / 5
          : 192.5,
      padding: EdgeInsets.all(21),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.surfaceActive),
        borderRadius: BorderRadius.circular(kBorderRadius),
        color: ColorManager.surfaceWhite,
      ),
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                title,
                style: textTheme.labelLarge?.copyWith(
                  color: ColorManager.greyNormal,
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: ColorManager.surfaceActive),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: ColorManager.surfaceActive),
                ),
                tooltip: l10n.add,
                icon: Icon(Icons.add),
                onPressed: onPressed,
              ),
            ],
          ),
          AppText(
            number.toString(),
            style: textTheme.displayLarge?.copyWith(
              color: ColorManager.greyNormal,
            ),
          ),
        ],
      ),
    );
  }
}

class ElementCard extends StatelessWidget {
  const ElementCard({
    super.key,
    required this.onTap,
    required this.elementName,
    required this.title,
    this.category,
    required this.status,
    required this.onElementTap,
  });

  final void Function()? onTap;
  final String elementName;
  final String title;
  final String? category;
  final Widget status;
  final void Function()? onElementTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surfaceWhite,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: ColorManager.surfaceActive),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              spacing: 16,
              children: [
                HomeCardIcon(),
                Expanded(
                  child: AppText(
                    l10n.last_something_of(title),
                    style: textTheme.labelMedium,
                  ),
                ),
                Tooltip(
                  message: l10n.see_more,
                  child: TextButton(
                    onPressed: onTap,
                    child: AppText(l10n.see_more, style: textTheme.bodySmall),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: ColorManager.surfaceActive),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: onElementTap,
              child: Row(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          elementName,
                          style: textTheme.labelLarge?.copyWith(
                            color: ColorManager.greyNormal,
                          ),
                        ),
                        if (category != null)
                          AppText(category!, style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                  status,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
