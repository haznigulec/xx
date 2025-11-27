import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/license/widgets/license_cancel_button.dart';
import 'package:piapiri_v2/app/license/widgets/license_give_up_cancel_button.dart';
import 'package:piapiri_v2/app/license/widgets/license_give_up_request_button.dart';
import 'package:piapiri_v2/app/license/widgets/license_request_button.dart';
import 'package:piapiri_v2/app/license/widgets/license_undefined_button.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/license_enum.dart';
import 'package:piapiri_v2/core/model/license_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class LicenseCard extends StatelessWidget {
  final LicenseModel license;
  final bool showDivider;

  const LicenseCard({
    super.key,
    required this.license,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isKD1 = license.code == 'KD1';

    return InkWell(
      onTap: () {
        if (isKD1) {
          _doCancelLicense(context);
          return;
        }
        if (license.lastRequest == null) {
          if (license.hasLicence) {
            _doCancelLicense(context);
            return;
          }

          _doRequestLicense(context);
          return;
        } else {
          if (license.lastRequest!.status == LicenseRequestStatusEnum.requested.value) {
            if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseNew.value) {
              _doCancelLicense(context);
              return;
            } else if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseCancel.value) {
              _doCancelLicense(context);
              return;
            } else {
              _doCancelLicense(context);
              return;
            }
          } else if (license.lastRequest!.status == LicenseRequestStatusEnum.accepted.value) {
            if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseCancel.value) {
              _doRequestLicense(context);
              return;
            } else if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseNew.value) {
              _doCancelLicense(context);
              return;
            } else {
              _doCancelLicense(context);
              return;
            }
          } else if (license.lastRequest!.status == LicenseRequestStatusEnum.rejected.value) {
            if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseCancel.value) {
              _doCancelLicense(context);
              return;
            } else if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseNew.value) {
              _doRequestLicense(context);
              return;
            } else {
              _doCancelLicense(context);
              return;
            }
          } else {
            _doRequestLicense(context);
            return;
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10n.tr('${license.code.toLowerCase()}_name'),
            textAlign: TextAlign.left,
            style: context.pAppStyle.labelReg14textPrimary,
          ),
          const SizedBox(
            height: Grid.xs,
          ),
          Text(
            '${L10n.tr('fiyat')}: ${license.currency == 'TL' ? CurrencyEnum.turkishLira.symbol : license.currency}${MoneyUtils().readableMoney(license.price)}',
            style: context.pAppStyle.labelMed12textSecondary,
          ),
          const SizedBox(
            height: Grid.xs,
          ),
          isKD1 ? _kd1ButtonWidget(context) : _actionButtonWidget(context),
          showDivider
              ? const PDivider(
                  padding: EdgeInsets.symmetric(
                    vertical: Grid.m,
                  ),
                )
              : const SizedBox(
                  height: Grid.m,
                ),
        ],
      ),
    );
  }

  Widget _kd1ButtonWidget(BuildContext context) {
    return SizedBox(
      height: 23,
      child: PCustomOutlinedButtonWithIcon(
        onPressed: () => _doCancelLicense(context),
        text: L10n.tr('free'),
        textStyle: context.pAppStyle.labelMed14primary,
        foregroundColor: context.pColorScheme.primary,
        foregroundColorApllyBorder: false,
        iconSource: ImagesPath.hediye,
      ),
    );
  }

  _doCancelLicense(BuildContext context) {
    router.push(
      LicenseCancelRoute(
        license: license,
      ),
    );
  }

  _doRequestLicense(BuildContext context) {
    router.push(
      LicenseRequestRoute(
        license: license,
      ),
    );
  }

  Widget _actionButtonWidget(BuildContext context) {
    if (license.lastRequest == null) {
      if (license.hasLicence) {
        return LicenseCancelButton(
          onTap: () => _doCancelLicense(context),
        );
      }

      return LicenseRequestButton(
        onTap: () => _doRequestLicense(context),
      );
    } else {
      if (license.lastRequest!.status == LicenseRequestStatusEnum.requested.value) {
        if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseNew.value) {
          return LicenseGiveUpRequestButton(
            onTap: () => _doCancelLicense(context),
          );
        } else if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseCancel.value) {
          return LicenseGiveUpCancelButton(
            onTap: () => _doCancelLicense(context),
          );
        } else {
          return LicenseUndefinedButton(
            onTap: () => _doCancelLicense(context),
          );
        }
      } else if (license.lastRequest!.status == LicenseRequestStatusEnum.accepted.value) {
        if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseCancel.value) {
          return LicenseRequestButton(
            onTap: () => _doRequestLicense(context),
          );
        } else if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseNew.value) {
          return LicenseCancelButton(
            onTap: () => _doCancelLicense(context),
          );
        } else {
          return LicenseUndefinedButton(
            onTap: () => _doCancelLicense(context),
          );
        }
      } else if (license.lastRequest!.status == LicenseRequestStatusEnum.rejected.value) {
        if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseCancel.value) {
          return LicenseCancelButton(
            onTap: () => _doCancelLicense(context),
          );
        } else if (license.lastRequest!.type == LicenseRequestTypeEnum.licenseNew.value) {
          return LicenseRequestButton(
            onTap: () => _doRequestLicense(context),
          );
        } else {
          return LicenseUndefinedButton(
            onTap: () => _doCancelLicense(context),
          );
        }
      } else {
        return LicenseRequestButton(
          onTap: () => _doRequestLicense(context),
        );
      }
    }
  }
}
