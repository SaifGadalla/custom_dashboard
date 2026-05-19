import '../../../common.dart';
import 'controller.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aboutControllerProvider);
    final controller = ref.read(aboutControllerProvider.notifier);
    final l10n = context.l10n;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: ColorManager.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorManager.surfaceActive),
            ),
            child: ReactiveFormBuilder(
              form: () => controller.form,
              builder: (context, form, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24,
                  children: [
                    AppText(
                      l10n.about_us,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Divider(color: ColorManager.surfaceActive),
                    AppTextField(
                      formControlName: 'vision',
                      label: l10n.vision,
                    ),
                    AppTextField(
                      formControlName: 'mission',
                      label: l10n.mission,
                    ),
                    DetailsSection(
                      formControlName: 'description',
                      tableTitle: l10n.description,
                      additionLabel: l10n.add,
                      editingTitle: l10n.edit,
                      deleteDialogLabel: l10n.delete,
                      maxLines: 4,
                    ),
                    ReactiveDialogImageSection(
                      formControlName: 'imageUrl',
                      onDragDone: (details) async {
                        if (details.files.isNotEmpty) {
                          final file = details.files.last;
                          final data = await file.readAsBytes();
                          await controller.handleDragUpload(data, file.name);
                        }
                      },
                      clickToUploadOnTap: () async {
                        await controller.pickAndUploadImage();
                      },
                    ),
                    Divider(color: ColorManager.surfaceActive),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        onTap: form.valid && form.dirty
                            ? () => controller.save()
                            : null,
                        backgroundColor: ColorManager.brownNormal,
                        foregroundColor: ColorManager.surfaceWhite,
                        isLoading: state.isSubmitting,
                        tooltip: l10n.save,
                        child: AppText(l10n.save),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
