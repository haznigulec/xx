import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/app/contracts/widget/risk_level_tile.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/set_answer_model.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ContractsSurveyResultPage extends StatefulWidget {
  final SetSurveyAnswersModel response;
  const ContractsSurveyResultPage({super.key, required this.response});

  @override
  State<ContractsSurveyResultPage> createState() => _ContractsSurveyResultPageState();
}

class _ContractsSurveyResultPageState extends State<ContractsSurveyResultPage> {
  late ContractsBloc _contractsBloc;

  @override
  void initState() {
    _contractsBloc = getIt<ContractsBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('yerindelik_test_sonucu'),
      ),
      bottomNavigationBar: generalButtonPadding(
        context: context,
        child: PButton(
          text: L10n.tr('devam'),
          onPressed: () {
            router.push(
              const ContractsPdfRoute(),
            );
          },
        ),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return PBlocBuilder<ContractsBloc, ContractsState>(
      bloc: _contractsBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const PLoading();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Grid.m),
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
                      text: widget.response.suitableRisks?.last.riskName ?? '-',
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
                    final status = widget.response.suitableRisks!.any(
                      (e) => e.riskName == contractRiskLevel[index]['riskName'],
                    );

                    return RiskLevelTile(
                      suitableRisk: contractRiskLevel[index],
                      status: status,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
