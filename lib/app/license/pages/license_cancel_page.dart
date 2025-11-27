import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/license/bloc/license_bloc.dart';
import 'package:piapiri_v2/app/license/bloc/license_event.dart';
import 'package:piapiri_v2/app/license/widgets/license_info_row.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/license_enum.dart';
import 'package:piapiri_v2/core/model/license_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class LicenseCancelPage extends StatelessWidget {
  final LicenseModel license;
  const LicenseCancelPage({
    super.key,
    required this.license,
  });

  @override
  Widget build(BuildContext context) {
    bool isGiveUpCancel = license.lastRequest?.status == LicenseRequestStatusEnum.requested.value &&
        license.lastRequest!.type == LicenseRequestTypeEnum.licenseCancel.value;
    bool isGiveUpRequest = license.lastRequest?.status == LicenseRequestStatusEnum.requested.value &&
        license.lastRequest!.type == LicenseRequestTypeEnum.licenseNew.value;
    bool isKD1 = license.code == 'KD1';

    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('license_detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Grid.s,
            ),
            LicenseInfoRow(
              title: L10n.tr('licence_name'),
              text: L10n.tr('${license.code.toLowerCase()}_name'),
            ),
            LicenseInfoRow(
              title: L10n.tr('licence_code'),
              text: license.code,
            ),
            LicenseInfoRow(
              title: L10n.tr('fiyat'),
              text:
                  '${license.currency == 'TL' ? CurrencyEnum.turkishLira.symbol : license.currency}${MoneyUtils().readableMoney(license.price)}',
              textStyle: isKD1 ? context.pAppStyle.labelMed14textSecondary : context.pAppStyle.labelMed14textPrimary,
            ),
            if (license.startDate != null)
              LicenseInfoRow(
                title: L10n.tr('baslangic_tarihi'),
                text: DateTime.parse(
                  license.startDate ?? '',
                ).formatDayMonthYearDot(),
              ),
            if (isGiveUpCancel)
              PInfoWidget(
                infoText: L10n.tr('waiting_cancel_request'),
                textColor: context.pColorScheme.primary,
              ),
            if (isGiveUpRequest)
              PInfoWidget(
                infoText: L10n.tr('demand_is_pending'),
                iconPath: ImagesPath.clock,
                textColor: context.pColorScheme.primary,
              ),
            if (isKD1)
              PInfoWidget(
                infoText: L10n.tr('kd1_free_description'),
              ),
            if (!isKD1)
              PInfoWidget(
                infoText: L10n.tr('licence_description'),
              ),
            const SizedBox(
              height: Grid.m,
            ),
            PInfoWidget(
              infoText: L10n.tr('what_is_${license.code.toLowerCase()}'),
              infoTextStyle: context.pAppStyle.labelMed14primary,
            ),
            const SizedBox(
              height: Grid.s,
            ),
            Text(
              L10n.tr('${license.code.toLowerCase()}_desc'),
              style: context.pAppStyle.labelReg14textSecondary,
            )

          ],
        ),
      ),
      bottomNavigationBar: isKD1
          ? const SizedBox.shrink()
          : PBlocBuilder(
              bloc: getIt<LicenseBloc>(),
              builder: (context, state) {
                return generalButtonPadding(
                  context: context,
                  child: POutlinedButton(
                    text: isGiveUpCancel
                        ? L10n.tr('give_up_cancel')
                        : isGiveUpRequest
                            ? L10n.tr('give_up_request')
                            : L10n.tr('iptal_et'),
                    fillParentWidth: true,
                    onPressed: () async {
                      PBottomSheet.showError(
                        context,
                        content:
                            isGiveUpCancel ? L10n.tr('waiting_cancel_request_alert') : L10n.tr('cancel_license_alert'),
                        showOutlinedButton: true,
                        outlinedButtonText: L10n.tr('vazgec'),
                        onOutlinedButtonPressed: () => router.maybePop(),
                        showFilledButton: true,
                        filledButtonText: L10n.tr('onayla'),
                        onFilledButtonPressed: () async {
                          getIt<LicenseBloc>().add(
                            CancelLicenseEvent(
                              licenceId: license.id,
                              requestType: LicenseRequestTypeEnum.licenseCancel.value,
                              onSuccess: (_) async {
                                await router.maybePop();

                                if (context.mounted) {
                                  await PBottomSheet.show(
                                    context,
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          ImagesPath.checkCircle,
                                          width: 52,
                                          height: 52,
                                          colorFilter: ColorFilter.mode(
                                            context.pColorScheme.primary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: Grid.m,
                                        ),
                                        Text(
                                          isGiveUpCancel
                                              ? L10n.tr('request_is_progress')
                                              : L10n.tr('license_has_been_cancelled'),
                                          style: context.pAppStyle.labelReg16textPrimary,
                                        ),
                                        const SizedBox(
                                          height: Grid.m,
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                getIt<LicenseBloc>().add(
                                  GetLicensesEvent(),
                                );

                                router.popUntilRouteWithName(
                                  LicensesRoute.name,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
