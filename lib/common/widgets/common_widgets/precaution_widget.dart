import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/widgets.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';

import 'package:piapiri_v2/core/model/precaution_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PrecautionWidget extends StatelessWidget {
  final List<PrecautionModel> precautionList;
  const PrecautionWidget({
    super.key,
    required this.precautionList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: precautionList.length,
        separatorBuilder: (context, index) => const PDivider(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.m,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    precautionList[index].appliedPrecautionName.toCapitalizeCaseTr,
                    style: context.pAppStyle.labelReg14textSecondary,
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${L10n.tr('baslangic')}: ${precautionList[index].precautionFirstDate}',
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                    const SizedBox(
                      height: Grid.xs,
                    ),
                    Text(
                      '${L10n.tr('bitis')}: ${precautionList[index].precautionLastDate}',
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
