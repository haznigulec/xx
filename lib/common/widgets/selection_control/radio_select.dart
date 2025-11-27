// Dropdown larda kullanılan seçili olan row'un iconu
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:flutter/material.dart';

class RadioSelectedIcon extends StatelessWidget {
  const RadioSelectedIcon({super.key, required this.isSelected});
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: Grid.xs,
        right: Grid.xs,
        bottom: Grid.xs,
      ),
      decoration: !isSelected
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).unselectedWidgetColor,
              ),
            )
          : null,
      child: isSelected
          ? Image.asset(
              ImagesPath.done_orange,
              width: 15,
              height: 15,
              fit: BoxFit.cover,
            )
          : const SizedBox(),
    );
  }
}
