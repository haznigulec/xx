import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/switch_tile/switch_tile.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_state.dart';
import 'package:piapiri_v2/app/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:piapiri_v2/app/transaction_history/bloc/transaction_history_event.dart';
import 'package:piapiri_v2/app/transaction_history/bloc/transaction_history_state.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_abroad_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_capra_model.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/shimmer_transaction_history.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_history_abroad_card.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_history_abroad_filter_widget.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_history_filtered_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_statement_date_filter_enum.dart';
import 'package:piapiri_v2/core/model/alpaca_account_status_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TransactionHistoryAbroadPage extends StatefulWidget {
  const TransactionHistoryAbroadPage({
    super.key,
  });

  @override
  State<TransactionHistoryAbroadPage> createState() => _TransactionHistoryAbroadPageState();
}

class _TransactionHistoryAbroadPageState extends State<TransactionHistoryAbroadPage> {
  late final TransactionHistoryBloc _transactionHistoryBloc;
  final ScrollController _controller = ScrollController();
  TransactionHistoryTypeEnum _selectedSide = TransactionHistoryTypeEnum.all;
  TransactionHistoryAbroadTypeEnum _selectedType = TransactionHistoryAbroadTypeEnum.all;
  DateFilterMultiEnum _selectedDate = DateFilterMultiEnum.sumaryToday;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSelectedType = false;
  bool _isSelectedSide = false;
  bool _isSelectedDate = false;
  AlpacaAccountStatusEnum? _alpacaAccountStatus;
  bool _isAlpacaStatusInitialized = false;
  late GlobalAccountOnboardingBloc _globalOnboardingBloc;
  late UserModel _userModel;
  String? _searchedSymbol;
  bool _isActiveMergePartialOrder = false;

  @override
  void initState() {
    _transactionHistoryBloc = getIt<TransactionHistoryBloc>();
    _globalOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
    _userModel = UserModel.instance;
    _fetchAccountStatus();
    super.initState();
  }

  void _fetchAccountStatus() {
    _globalOnboardingBloc.add(
      AccountSettingStatusEvent(
        succesCallback: (accountSettingStatus) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              setState(() {
                _isAlpacaStatusInitialized = true;
                _alpacaAccountStatus = AlpacaAccountStatusEnum.values.firstWhereOrNull(
                  (e) => e.value == accountSettingStatus.accountStatus,
                );
              });
              if (_alpacaAccountStatus == AlpacaAccountStatusEnum.active) {
                _transactionHistoryBloc.add(
                  GetCapraTransactionHistoryEvent(
                    side: '',
                    symbol: _searchedSymbol ?? '',
                    until: _formatToUtc(
                      DateTime.now()
                          .copyWith(
                            hour: 23,
                            minute: 59,
                            second: 0,
                            millisecond: 0,
                          )
                          .toString(),
                    ),
                    after: _formatToUtc(
                      DateTime.now()
                          .copyWith(
                            hour: 0,
                            minute: 0,
                            second: 0,
                            millisecond: 0,
                          )
                          .toString(),
                    ),
                  ),
                );
              }
            },
          );
        },
        errorCallback: () {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              setState(() {
                _isAlpacaStatusInitialized = true;
              });
            },
          );
        },
      ),
    );
  }

  void _fetchData() {
    _transactionHistoryBloc.add(
      GetCapraTransactionHistoryEvent(
        side: _selectedSide.abroadValue,
        symbol: _searchedSymbol ?? '',
        until: _endDate != null
            ? _formatToUtc(
                _endDate!
                    .copyWith(
                      hour: 23,
                      minute: 59,
                      second: 0,
                      millisecond: 0,
                    )
                    .toString(),
              )
            : _formatToUtc(
                DateTime.now()
                    .copyWith(
                      hour: 23,
                      minute: 59,
                      second: 0,
                      millisecond: 0,
                    )
                    .toString(),
              ),
        after: _startDate != null
            ? _formatToUtc(
                _startDate!
                    .copyWith(
                      hour: 0,
                      minute: 0,
                      second: 0,
                      millisecond: 0,
                    )
                    .toString(),
              )
            : _formatToUtc(
                DateTime.now()
                    .copyWith(
                      hour: 0,
                      minute: 0,
                      second: 0,
                      millisecond: 0,
                    )
                    .toString(),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<GlobalAccountOnboardingBloc, GlobalAccountOnboardingState>(
        bloc: _globalOnboardingBloc,
        builder: (context, globalAccountOnboardingState) {
          if (!_isAlpacaStatusInitialized || globalAccountOnboardingState.isLoading) {
            return const ShimmerTransactionHistory();
          }

          if (_alpacaAccountStatus == AlpacaAccountStatusEnum.active) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TransactionHistoryAbroadFilterWidget(
                  selectedDate: _selectedDate,
                  selectedSide: _selectedSide,
                  selectedType: _selectedType,
                  isSelectedType: _isSelectedType,
                  isSelectedSide: _isSelectedSide,
                  isSelectedDate: _isSelectedDate,
                  onSelectedSymbol: (symbolName) {
                    setState(() {
                      _searchedSymbol = symbolName;

                      _fetchData();
                    });
                  },
                  onSelectedSide: (side) {
                    setState(() {
                      _selectedSide = side;
                      _isSelectedSide = true;
                      _fetchData();
                    });
                  },
                  onChangedStartEndDate: (startDate, endDate) {
                    setState(() {
                      _startDate = startDate;
                      _endDate = endDate;

                      if (_startDate!.isAfter(_endDate!)) {
                        _endDate = _startDate!.add(
                          const Duration(days: 1),
                        );
                      }
                      if (endDate.isBefore(startDate)) {
                        _startDate = endDate.subtract(
                          const Duration(days: 1),
                        );
                      }

                      _isSelectedDate = true;

                      _fetchData();
                    });
                  },
                  onSelectedDateFilter: (date) {
                    setState(() {
                      _selectedDate = date;

                      _isSelectedDate = true;
                    });
                  },
                  onSelectedType: (type) {
                    setState(() {
                      _selectedType = type;
                      _isSelectedType = true;
                    });
                  },
                ),
                const SizedBox(
                  height: Grid.s + Grid.xs,
                ),
                if (_searchedSymbol != null) ...[
                  TransactionHistoryFilteredWidget(
                    text: _searchedSymbol!,
                    onTap: () {
                      setState(() {
                        _searchedSymbol = null;

                        _fetchData();
                      });
                    },
                  ),
                  const SizedBox(
                    height: Grid.s + Grid.xs,
                  ),
                ],
                Expanded(
                  child: PBlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
                    bloc: _transactionHistoryBloc,
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Shimmerize(
                          enabled: true,
                          child: ShimmerTransactionHistory(),
                        );
                      }
                      Map<String, List<TransactionHistoryCapraModel>>? finallyList =
                          state.transactionCapraHistoryFilter;

                      if (_isActiveMergePartialOrder) {
                        finallyList = state.transactionCapraHistoryGrouped;
                      }

                      return finallyList?.entries.isEmpty ?? true && state.isSuccess
                          ? Center(
                              child: NoDataWidget(
                                message: L10n.tr('no_transaction_history_found'),
                                iconName: ImagesPath.telescope_on,
                              ),
                            )
                          : sortByDateWidget(
                              finallyList!,
                            );

                      // return state.accountActivitiesList == null
                      //     ? Center(
                      //         child: NoDataWidget(
                      //           message: L10n.tr('no_transaction_history_found'),
                      //           iconName: ImagesPath.telescope_on,
                      //         ),
                      //       )
                      //     : TransactionHistoryCapraList(
                      //         accountActivitiesList: _selectedType == TransactionHistoryAbroadTypeEnum.cash
                      //             ? state.accountActivitiesList!.where((e) => e.activityType == 'JNLC').toList()
                      //             : _selectedType == TransactionHistoryAbroadTypeEnum.americanStockExchanges
                      //                 ? state.accountActivitiesList!.where((e) => e.activityType != 'JNLC').toList()
                      //                 : state.accountActivitiesList!,
                      //       );
                    },
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10n.tr('welcome_American_exchange'),
                style: context.pAppStyle.labelMed18textPrimary,
              ),
              const SizedBox(
                height: Grid.s,
              ),
              Text(
                _alpacaAccountStatus == null
                    ? L10n.tr('start_trading_American_exchange')
                    : L10n.tr('portfolio.${_alpacaAccountStatus!.descriptionKey}'),
                style: context.pAppStyle.labelReg16textPrimary,
              ),
              const SizedBox(
                height: Grid.m,
              ),
              SizedBox(
                height: 33,
                child: PButtonWithIcon(
                  text: _alpacaAccountStatus == null ? L10n.tr('get_started') : L10n.tr('go_agreements'),
                  sizeType: PButtonSize.small,
                  icon: SvgPicture.asset(
                    ImagesPath.arrow_up_right,
                    width: 17,
                    height: 17,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.lightHigh,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () async {
                    await router.push(
                      const GlobalAccountOnboardingRoute(),
                    );

                    if (!_userModel.alpacaAccountStatus) {
                      _globalOnboardingBloc.add(
                        AccountSettingStatusEvent(
                          succesCallback: (accountSettingStatus) {
                            setState(() {
                              _alpacaAccountStatus = AlpacaAccountStatusEnum.values.firstWhereOrNull(
                                (e) => e.value == accountSettingStatus.accountStatus,
                              );
                            });
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        });
  }

  Widget sortByDateWidget(
    Map<String, List<TransactionHistoryCapraModel>> transactionCapraHistoryFilter,
  ) {
    Map<String, List<TransactionHistoryCapraModel>> lastList = {};

    _selectedType == TransactionHistoryAbroadTypeEnum.cash
        ? lastList = transactionCapraHistoryFilter
            .map((key, value) => MapEntry(key, value.where((e) => e.activityType == 'JNLC').toList()))
        : _selectedType == TransactionHistoryAbroadTypeEnum.americanStockExchangesEquity
            ? lastList = transactionCapraHistoryFilter
                .map((key, value) => MapEntry(key, value.where((e) => e.activityType != 'JNLC').toList()))
            : lastList = transactionCapraHistoryFilter;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: Grid.m,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PSwitchRow(
                value: _isActiveMergePartialOrder,
                text: L10n.tr('merge_partial_orders'),
                textStyle: context.pAppStyle.labelReg14textPrimary,
                rowBetweenPadding: Grid.s,
                onChanged: (value) => setState(
                  () => _isActiveMergePartialOrder = value,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            itemCount: lastList.keys.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final String date = lastList.keys.elementAt(index).toString();

              return StickyHeader(
                header: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: Grid.s,
                    bottom: Grid.s,
                  ),
                  decoration: BoxDecoration(
                    color: context.pColorScheme.backgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: context.pColorScheme.textSecondary,
                        width: 0.2,
                      ),
                      top: BorderSide(
                        color: context.pColorScheme.textSecondary,
                        width: 0.2,
                      ),
                    ),
                  ),
                  child: Text(
                    date,
                    style: context.pAppStyle.labelMed14textSecondary,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(
                      lastList[date]?.length ?? 0,
                      (index) => TransactionHistoryAbroadCard(
                        transactionHistory: lastList[date]![index],
                        hasDivider: lastList[date]!.length - 1 != index,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatToUtc(String dateTime) {
    final DateTime date = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').parse(dateTime);
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(date);
  }
}
