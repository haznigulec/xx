import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/app/contracts/model/get_customer_answers_model.dart';
import 'package:piapiri_v2/app/contracts/widget/risk_level_tile.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ContractsResultWidget extends StatelessWidget {
  final ContractsState state;

  const ContractsResultWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    GetCustomerAnswersModel result = state.getCustomerAnswersModel!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: Grid.m,
          ),
          RichText(
            text: TextSpan(
              text: '${L10n.tr('contracts_risk_level_intro')} ',
              style: context.pAppStyle.labelReg16textPrimary,
              children: [
                TextSpan(
                  text: result.suitableRisks?.last.riskName ?? '-',
                  style: context.pAppStyle.labelMed16primary,
                ),
                TextSpan(
                  text: L10n.tr('contracts_risk_level_suffix'),
                  style: context.pAppStyle.labelReg16textPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(height: Grid.xs),
          Expanded(
            child: ListView.separated(
              itemCount: contractRiskLevel.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const PDivider(),
              itemBuilder: (context, index) {
                final status = result.suitableRisks!.any(
                  (e) => e.riskName == contractRiskLevel[index]['riskName'],
                );

                return RiskLevelTile(
                  suitableRisk: contractRiskLevel[index],
                  status: status,
                );
              },
            ),
          ),
          const SizedBox(height: Grid.s),
        ],
      ),
    );
  }
}
