import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_bloc.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_event.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_state.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CurrencyTypeListWidget extends StatefulWidget {
  const CurrencyTypeListWidget({super.key});

  @override
  State<CurrencyTypeListWidget> createState() => _CurrencyTypeListWidgetState();
}

class _CurrencyTypeListWidgetState extends State<CurrencyTypeListWidget> {
  late CurrencyBuySellBloc _currencyBuySellBloc;

  @override
  void initState() {
    _currencyBuySellBloc = getIt<CurrencyBuySellBloc>();
    _currencyBuySellBloc.add(
      GetSystemParametersEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<CurrencyBuySellBloc, CurrencyBuySellState>(
      bloc: _currencyBuySellBloc,
      builder: (context, state) {
        DateTime startDate = state.systemParametersModel?.fcStartTime ??
            DateTime.now().copyWith(
              hour: 09,
              minute: 00,
            );
        DateTime endDate = state.systemParametersModel?.fcEndTime ??
            DateTime.now().copyWith(
              hour: 18,
              minute: 00,
            );

        DateTime now = getIt<TimeBloc>().state.mxTime != null
            ? DateTime.fromMicrosecondsSinceEpoch(
                getIt<TimeBloc>().state.mxTime!.timestamp.toInt(),
              )
            : DateTime.fromMicrosecondsSinceEpoch(
                DateTime.now().microsecondsSinceEpoch,
              );

        bool isMarketClosed = now.hour < startDate.hour || now.hour >= endDate.hour;

        if (DateTimeUtils().isWeekend() || DateTimeUtils().isHoliday()) {
          isMarketClosed = true;
        }

        return Column(
          children: [
            if (isMarketClosed) ...[
              Text(
                '${L10n.tr(
                  'currency_transaction_working_hour_info',
                  args: [
                    startDate.formatTimeHourMinute(),
                    endDate.formatTimeHourMinute(),
                  ],
                )} ${L10n.tr('currency_transcation_specified_time_info')}',
                textAlign: TextAlign.center,
                style: context.pAppStyle.labelReg14textPrimary,
              ),
              const SizedBox(
                height: Grid.m,
              ),
              const PDivider(),
            ],
            ...CurrencyEnum.values.map(
              (type) {
                if (type == CurrencyEnum.japaneseYen ||
                    type == CurrencyEnum.other ||
                    type == CurrencyEnum.turkishLira) {
                  return const SizedBox.shrink();
                }

                return InkWell(
                  splashColor: context.pColorScheme.transparent,
                  highlightColor: context.pColorScheme.transparent,
                  onTap: () {
                    if (isMarketClosed) return;

                    List<AccountModel> accountsByCurrency = [];

                    if (type == CurrencyEnum.dollar) {
                      accountsByCurrency = UserModel.instance.accounts
                          .where(
                            (element) => element.currency == CurrencyEnum.dollar,
                          )
                          .toList();
                    } else if (type == CurrencyEnum.euro) {
                      accountsByCurrency = UserModel.instance.accounts
                          .where(
                            (element) => element.currency == CurrencyEnum.euro,
                          )
                          .toList();
                    } else if (type == CurrencyEnum.pound) {
                      accountsByCurrency = UserModel.instance.accounts
                          .where(
                            (element) => element.currency == CurrencyEnum.pound,
                          )
                          .toList();
                    }

                    if (accountsByCurrency.isEmpty) {
                      Utils().showCustomerServiceCallAlert(
                        context,
                        L10n.tr(
                          'no_usd_account_desc',
                          args: [
                            type.name.toUpperCase(),
                          ],
                        ),
                      );
                      return;
                    }

                    router.push(
                      CurrencyBuySellRoute(
                        currencyType: type,
                        accountsByCurrency: accountsByCurrency,
                      ),
                    );

                    router.maybePop();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Grid.m,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              L10n.tr(type.shortName),
                              style: context.pAppStyle.labelReg16textPrimary,
                            ),
                            isMarketClosed
                                ? Row(
                                    children: [
                                      Text(
                                        L10n.tr('closed'),
                                        style: context.pAppStyle.labelReg14textSecondary,
                                      ),
                                      const SizedBox(
                                        width: Grid.xs,
                                      ),
                                      SvgPicture.asset(
                                        ImagesPath.moon,
                                        colorFilter: ColorFilter.mode(
                                          context.pColorScheme.critical,
                                          BlendMode.srcIn,
                                        ),
                                        width: 12,
                                        height: 12,
                                      )
                                    ],
                                  )
                                : SvgPicture.asset(
                                    ImagesPath.chevron_right,
                                    colorFilter: ColorFilter.mode(
                                      context.pColorScheme.textPrimary,
                                      BlendMode.srcIn,
                                    ),
                                    width: 12,
                                    height: 12,
                                  )
                          ],
                        ),
                      ),
                      if (type != CurrencyEnum.pound) const PDivider(),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
