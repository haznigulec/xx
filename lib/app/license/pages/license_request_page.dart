import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
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
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
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
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class LicenseRequestPage extends StatefulWidget {
  final LicenseModel license;

  const LicenseRequestPage({
    super.key,
    required this.license,
  });

  @override
  State<LicenseRequestPage> createState() => _LicenseRequestPageState();
}

class _LicenseRequestPageState extends State<LicenseRequestPage> {
  DateTime _startDate = DateTime.now();
  late LicenseBloc _licenseBloc;

  @override
  void initState() {
    _licenseBloc = getIt<LicenseBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              text: L10n.tr('${widget.license.code.toLowerCase()}_name'),
            ),
            const SizedBox(
              height: Grid.s,
            ),
            LicenseInfoRow(
              title: L10n.tr('licence_code'),
              text: widget.license.code,
            ),
            const SizedBox(
              height: Grid.s,
            ),
            LicenseInfoRow(
              title: L10n.tr('fiyat'),
              text:
                  '${widget.license.currency == 'TL' ? CurrencyEnum.turkishLira.symbol : widget.license.currency}${MoneyUtils().readableMoney(widget.license.price)}',
            ),
            LicenseInfoRow(
              title: L10n.tr('baslangic_tarihi'),
              text: '',
              trailingWidget: InkWell(
                onTap: () async {
                  await showPDatePicker(
                    context: context,
                    initialDate: _startDate,
                    minimumDate: _startDate,
                    cancelTitle: L10n.tr('iptal'),
                    doneTitle: L10n.tr('tamam'),
                    onChanged: (selectedDate) {
                      if (selectedDate == null) return;

                      setState(() {
                        _startDate = selectedDate;
                      });
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      ImagesPath.calendar,
                      width: 15,
                      height: 15,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    Text(
                      _startDate.formatDayMonthYearDot(),
                      textAlign: TextAlign.end,
                      style: context.pAppStyle.labelMed14textPrimary,
                    )
                  ],
                ),
              ),
            ),
            PInfoWidget(
              infoText: L10n.tr('licence_description'),
            ),
            const SizedBox(
              height: Grid.m,
            ),
            PInfoWidget(
              infoText: L10n.tr('what_is_${widget.license.code.toLowerCase()}'),
              infoTextStyle: context.pAppStyle.labelMed14primary,
            ),
            const SizedBox(
              height: Grid.s,
            ),
            Text(
              L10n.tr('${widget.license.code.toLowerCase()}_desc'),
              style: context.pAppStyle.labelReg14textSecondary,
            )
          ],
        ),
      ),
      bottomNavigationBar: PBlocBuilder(
        bloc: _licenseBloc,
        builder: (context, state) {
          return generalButtonPadding(
            context: context,
            child: PButton(
              text: L10n.tr('request'),
              fillParentWidth: true,
              onPressed: () async {
                _licenseBloc.add(
                  RequestLicenseEvent(
                    licenceId: widget.license.id,
                    startDate: DateTimeUtils.serverDate(_startDate),
                    customerId: UserModel.instance.customerId ?? '',
                    requestType: LicenseRequestTypeEnum.licenseNew.value,
                    onSuccess: (_) async {
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
                              L10n.tr('license_request_submitted_v2'),
                              style: context.pAppStyle.labelReg16textPrimary,
                            ),
                            const SizedBox(
                              height: Grid.m,
                            ),
                          ],
                        ),
                      );

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
            ),
          );
        },
      ),
    );
  }
}
