import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

//ticket oluşturuken dosya seçme
class ChosenImageFileWidget extends StatefulWidget {
  final List<String> fileBaseNames;
  final VoidCallback onDelete;
  final bool? fromActiveTicket;

  const ChosenImageFileWidget({
    super.key,
    required this.fileBaseNames,
    required this.onDelete,
    this.fromActiveTicket = false,
  });

  @override
  State<ChosenImageFileWidget> createState() => _ChosenImageFileWidgetState();
}

class _ChosenImageFileWidgetState extends State<ChosenImageFileWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widget.fileBaseNames.map((imageName) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: widget.onDelete,
                child: SvgPicture.asset(
                  ImagesPath.trash,
                  width: 17,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              if (!widget.fromActiveTicket!) ...[
                const SizedBox(width: Grid.xs),
                Expanded(
                  child: Text(
                    imageName,
                    style: context.pAppStyle.labelReg16textPrimary,
                  ),
                ),
              ]
            ],
          );
        }).toList(),
      ),
    );
  }
}
