import '../../common.dart';

class HomeCardIcon extends StatelessWidget {
  const HomeCardIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: ColorManager.brownLight,
        border: Border.all(width: 4, color: ColorManager.brownNormal),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.layers_outlined, size: 16),
    );
  }
}
