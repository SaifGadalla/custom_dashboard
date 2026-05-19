import '../../../common.dart';

class ArticleInfoDialog extends StatelessWidget {
  final Article article;

  const ArticleInfoDialog({super.key, required this.article});

  static Future<void> show(BuildContext context, Article article) async {
    return showDialog(
      context: context,
      builder: (context) => ArticleInfoDialog(article: article),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: ColorManager.surfaceWhite,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: AppText(article.title, style: textTheme.titleLarge)),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (article.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppNetworkImage(
                    url: article.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              AppText('ID: ${article.id}', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              AppText(
                'Category: ${article.category.name}',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              AppText(
                'Created at: ${DateFormat('MMM dd, yyyy').format(article.createdAt)}',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              AppText(
                'Updated at: ${DateFormat('MMM dd, yyyy').format(article.updatedAt)}',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              AppText('Content', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              AppText(article.content, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          tooltip: l10n.close,
          onTap: () => Navigator.of(context).pop(),
          child: AppText(l10n.close),
        ),
      ],
    );
  }
}
