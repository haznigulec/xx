import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_state.dart';
import 'package:piapiri_v2/app/global_account_onboarding/model/account_setting_status_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OnBoardingTileWidget extends StatelessWidget {
  final int number;
  final String text;
  final GlobalAccountOnboardingState state;

  const OnBoardingTileWidget({
    super.key,
    required this.number,
    required this.text,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.m + Grid.xs,
      ),
      child: Row(
        children: [
          Container(
            width: Grid.l + Grid.xxs,
            height: Grid.l + Grid.xxs,
            decoration: BoxDecoration(
              color: getParameterValue(state.accountSettingStatus!, text)
                  ? context.pColorScheme.primary
                  : context.pColorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: getParameterValue(state.accountSettingStatus!, text)
                  ? SvgPicture.asset(
                      ImagesPath.check,
                      width: 12,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.lightHigh,
                        BlendMode.srcIn,
                      ),
                    )
                  : Text(
                      number.toString(),
                      style: context.pAppStyle.labelMed12primary,
                    ),
            ),
          ),
          const SizedBox(
            width: Grid.s,
          ),
          Text(
            L10n.tr(text),
            style: context.pAppStyle.labelReg16textPrimary,
          ),
        ],
      ),
    );
  }
}

bool getParameterValue(AccountSettingStatusModel model, String text) {
  int? value;
  switch (text) {
    case 'personalInformation':
      value = model.personalInformation;
      break;
    case 'financialInformation':
      value = model.financialInformation;
      break;
    case 'onlineContracts':
      value = model.onlineContracts;
      break;
    default:
      return false;
  }
  return value == 1;
}
