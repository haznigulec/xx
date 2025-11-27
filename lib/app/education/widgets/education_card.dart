import 'dart:convert';
import 'dart:typed_data';

import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/education_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EducationCard extends StatelessWidget {
  final EducationListModel educationList;
  const EducationCard({
    super.key,
    required this.educationList,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List imageData = base64.decode(educationList.thumbnail ?? '');

    return SizedBox(
      height: 88,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(Grid.m),
            child: Image.memory(
              imageData,
              height: 56,
              width: 56,
              scale: 1,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: Grid.s,
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  educationList.title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Text(
                  L10n.tr('free'),
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Text(
                  '${educationList.educationSubjects?.length ?? 1} Video',
                  style: context.pAppStyle.labelMed12primary,
                ),
                const Spacer(),
                SizedBox(
                  height: 23,
                  child: PCustomOutlinedButtonWithIcon(
                    text: L10n.tr('start_watching'),
                    icon: const Icon(
                      Icons.arrow_outward_rounded,
                      size: Grid.m,
                    ),
                    foregroundColorApllyBorder: false,
                    foregroundColor: context.pColorScheme.lightHigh,
                    backgroundColor: context.pColorScheme.primary,
                    onPressed: () {
                      router.push(
                        EducationDetailRoute(
                          educationList: educationList,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
