import '../../../common.dart';

class ServiceInfoDialog extends StatelessWidget {
  final Service service;

  const ServiceInfoDialog({super.key, required this.service});

  static Future<void> show(BuildContext context, Service service) async {
    return showDialog(
      context: context,
      builder: (context) => ServiceInfoDialog(service: service),
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
          Expanded(child: AppText(service.name, style: textTheme.titleLarge)),
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
              if (service.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppNetworkImage(
                    url: service.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              AppText('ID: ${service.id}', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              AppText(
                'Created at: ${DateFormat('MMM dd, yyyy').format(service.createdAt)}',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              AppText(
                'Updated at: ${DateFormat('MMM dd, yyyy').format(service.updatedAt)}',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              AppText(l10n.service_details, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              ...service.details.map(
                (d) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: AppText('• $d', style: textTheme.bodyMedium),
                ),
              ),
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
