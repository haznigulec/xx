import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/account_setting_status_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EnquraTileWidget extends StatelessWidget {
  final Function()? onClick;
  final int number;
  final String text;
  final EnquraState state;

  const EnquraTileWidget({
    super.key,
    required this.onClick,
    required this.number,
    required this.text,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m + Grid.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: Grid.l + Grid.xxs,
              height: Grid.l + Grid.xxs,
              decoration: BoxDecoration(
                color: getParameterValue(
                  state.accountSettingStatus,
                  text,
                )
                    ? context.pColorScheme.primary
                    : context.pColorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: getParameterValue(
                  state.accountSettingStatus,
                  text,
                )
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
      ),
    );
  }
}

bool getParameterValue(EnquraAccountSettingStatusModel? model, String text) {
  if (model == null) return false;
  int? value;
  switch (text) {
    case 'personalInformation':
      value = model.personalInformation;
      break;
    case 'financialInformation':
      value = model.financialInformation;
      break;
    case 'identityVerification':
      value = model.identityVerification;
      break;
    case 'onlineContracts':
      value = model.onlineContracts;
      break;
    case 'enqura_videoCall':
      value = model.videoCall;
      break;
    default:
      return false;
  }
  return value == 1;
}
