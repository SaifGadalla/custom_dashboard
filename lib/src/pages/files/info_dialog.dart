import '../../../common.dart';

class FileInfoDialog extends StatelessWidget {
  final AppFile file;

  const FileInfoDialog({super.key, required this.file});

  static Future<void> show(BuildContext context, AppFile file) async {
    return showDialog(
      context: context,
      builder: (context) => FileInfoDialog(file: file),
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
          Expanded(child: AppText(file.name, style: textTheme.titleLarge)),
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
              if (file.type == 'image' && file.url.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppNetworkImage(
                    url: file.url,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              AppText('ID: ${file.id}', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              AppText(
                'Type: ${getFileType(file.type)}',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              AppText(
                'Size: ${(file.size / 1024).toStringAsFixed(2)} KB',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              AppText(
                'Created at: ${DateFormat('MMM dd, yyyy').format(file.createdAt)}',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              AppText('URL: ${file.url}', style: textTheme.bodyMedium),
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
