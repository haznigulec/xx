import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/app/contracts/page/contracts_info_page.dart';
import 'package:piapiri_v2/app/contracts/widget/contracts_result_widget.dart';
import 'package:piapiri_v2/app/contracts/widget/start_contracts_survey_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ContractsPage extends StatefulWidget {
  final String title;
  const ContractsPage({super.key, required this.title});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  late ContractsBloc _contractsBloc;

  @override
  void initState() {
    _contractsBloc = getIt<ContractsBloc>();
    _contractsBloc.add(
      GetCustomerAnswersEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: PBlocBuilder<ContractsBloc, ContractsState>(
        bloc: _contractsBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: widget.title,
              actions: [
                state.getCustomerAnswersModel?.riskLevel != null && state.getCustomerAnswersModel!.riskLevel!.isNotEmpty
                    ? InkWrapper(
                        child: SvgPicture.asset(
                          ImagesPath.info,
                          width: 19,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.iconPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        onTap: () => PBottomSheet.show(
                          context,
                          child: const ContractsInfoWidget(),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            body:
                state.getCustomerAnswersModel?.riskLevel != null && state.getCustomerAnswersModel!.riskLevel!.isNotEmpty
                    ? ContractsResultWidget(state: state)
                    : const StartContractsSurveyWidget(),
            persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.s,
                ),
                child: PButton(
                  text: state.getCustomerAnswersModel?.riskLevel != null &&
                          state.getCustomerAnswersModel!.riskLevel!.isNotEmpty
                      ? L10n.tr('testAgain')
                      : L10n.tr('startTesting'),
                  fillParentWidth: true,
                  onPressed: () {
                    if (UserModel.instance.innerType != null && UserModel.instance.innerType != 'INSTITUTION') {
                      state.answers?.clear();
                      router.push(
                        ContractsSurveyRoute(
                          title: L10n.tr(
                            'uygunluk_testi',
                          ),
                        ),
                      );
                    } else {
                      PBottomSheet.showError(
                        context,
                        content: L10n.tr('contract_institution_control'),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
