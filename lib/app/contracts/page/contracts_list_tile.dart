import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ContractsListTileWidget extends StatelessWidget {
  final String leadingTitle;
  final String leadingSubTitle;
  final Function()? onTap;
  final bool isShowDivider;
  final bool hasGtpContracts;
  final bool isConfirmed;
  final String? approvedDate;

  const ContractsListTileWidget({
    super.key,
    required this.leadingTitle,
    required this.leadingSubTitle,
    this.onTap,
    this.isShowDivider = false,
    this.hasGtpContracts = false,
    this.isConfirmed = false,
    this.approvedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: InkWell(
        onTap: (UserModel.instance.innerType != null && UserModel.instance.innerType == 'INSTITUTION') || isConfirmed
            ? null
            : onTap ?? () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Grid.m,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leadingTitle,
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                  const SizedBox(
                    height: Grid.s,
                  ),
                  Text(
                    leadingSubTitle,
                    style: context.pAppStyle.labelReg14textSecondary,
                  ),
                  if (isConfirmed) ...[
                    const SizedBox(
                      height: Grid.s,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        approvedDate != null
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${L10n.tr('approved_date')}: ',
                                    style: context.pAppStyle.labelMed14textSecondary.copyWith(
                                      color: context.pColorScheme.iconPrimary,
                                    ),
                                  ),
                                  Text(
                                    approvedDate!,
                                    style: context.pAppStyle.labelMed14textSecondary.copyWith(
                                      color: context.pColorScheme.iconPrimary,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ] else ...[
                    if (UserModel.instance.innerType != null && UserModel.instance.innerType != 'INSTITUTION') ...[
                      const SizedBox(
                        height: Grid.s,
                      ),
                      PButtonWithIcon(
                        height: 28,
                        onPressed: onTap,
                        text: hasGtpContracts ? L10n.tr('contract_approve') : L10n.tr('contract_show'),
                        iconAlignment: IconAlignment.end,
                        sizeType: PButtonSize.xsmall,
                        icon: SvgPicture.asset(
                          ImagesPath.arrow_up_right,
                          width: Grid.m,
                          height: Grid.m,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.lightHigh,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            if (isShowDivider) ...[
              const PDivider(),
            ]
          ],
        ),
      ),
    );
  }
}
