import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_event.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_state.dart';
import 'package:piapiri_v2/app/alarm/enum/alarm_price_sliding.dart';
import 'package:piapiri_v2/app/alarm/widgets/alarm_sliding_percentage.dart';
import 'package:piapiri_v2/app/alarm/widgets/alarm_sliding_price.dart';
import 'package:piapiri_v2/app/alarm/widgets/alarm_tile.dart';
import 'package:piapiri_v2/app/alarm/widgets/description_textfield.dart';
import 'package:piapiri_v2/app/alarm/widgets/price_alarm_current_prices_row.dart';
import 'package:piapiri_v2/app/ipo/widgets/filter_category_button.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alarm_model.dart';
import 'package:piapiri_v2/core/model/alarm_validity_enum.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CreatePriceAlarmPage extends StatefulWidget {
  final SymbolModel symbol;
  const CreatePriceAlarmPage({
    super.key,
    required this.symbol,
  });

  @override
  State<CreatePriceAlarmPage> createState() => _CreatePriceAlarmPageState();
}

class _CreatePriceAlarmPageState extends State<CreatePriceAlarmPage> {
  int _selectedSlidingIndex = AlarmPriceSliding.price.value;
  final TextEditingController _alarmPriceTC = TextEditingController(text: '0');
  final TextEditingController _priceChangeTC = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  final GlobalKey _noteKey = GlobalKey(debugLabel: 'note_key');
  final ScrollController _scrollController = ScrollController();
  AlarmValidityEnum _selectedValidity = AlarmValidityEnum.alarmDaily;
  double _goalPrice = 0;
  double _lastPrice = 0;
  late SymbolBloc _symbolBloc;
  MarketListModel? _marketListModel;
  String _symbol = '';
  late final AlarmBloc _alarmBloc;
  String _symbolNameForIcon = '';
  String _symbolDescription = '';

  @override
  void initState() {
    _symbol = widget.symbol.name;
    _symbolDescription = widget.symbol.description;

    _symbolBloc = getIt<SymbolBloc>();
    _alarmBloc = getIt<AlarmBloc>();

    _alarmBloc.add(
      GetAlarmsEvent(),
    );
    _symbolBloc.add(
      SymbolSubOneTopicEvent(
        symbol: _symbol,
      ),
    );

    _handleSymbolIcon(widget.symbol);

    super.initState();
  }

  void _handleSymbolIcon(SymbolModel symbol) {
    _symbolNameForIcon = stringToSymbolType(symbol.typeCode) == SymbolTypes.option ||
            stringToSymbolType(symbol.typeCode) == SymbolTypes.future ||
            stringToSymbolType(symbol.typeCode) == SymbolTypes.warrant
        ? symbol.underlyingName
        : _symbol; // sembolün ne zaman underlying name'sine bakılacağının ayarlandığı yer.
  }

  String _getCurrencySymbol() {
    final symbolType = stringToSymbolType(widget.symbol.typeCode);
    final currencySymbol = symbolType == SymbolTypes.parity ? '' : CurrencyEnum.turkishLira.symbol;
    return currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: Grid.m,
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: PSymbolTile(
                  variant: PSymbolVariant.equityTab,
                  title: _symbol,
                  subTitle: _symbolDescription,
                  symbolName: _symbolNameForIcon,
                  symbolType: stringToSymbolType(widget.symbol.typeCode),
                  trailingWidget: SvgPicture.asset(
                    ImagesPath.search,
                    width: 21,
                    height: 21,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.iconPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onTap: () {
                    router.push(
                      SymbolSearchRoute(
                        appBarTitle: L10n.tr('alarm_kur'),
                        filterList: SymbolSearchFilterEnum.values
                            .where(
                              (e) =>
                                  e != SymbolSearchFilterEnum.foreign &&
                                  e != SymbolSearchFilterEnum.fund &&
                                  e != SymbolSearchFilterEnum.etf,
                            )
                            .toList(),
                        onTapSymbol: (symbolModelList) {
                          _symbol = symbolModelList[0].name;
                          _symbolDescription = symbolModelList[0].description;

                          _symbolBloc.add(
                            // Seçilen sembole subscribe olduğumuz yer.
                            SymbolSubOneTopicEvent(
                              symbol: _symbol,
                            ),
                          );

                          _handleSymbolIcon(symbolModelList[0]);

                          _alarmPriceTC.text = '0';
                          _priceChangeTC.text = '0';

                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Grid.s,
                  horizontal: Grid.m,
                ),
                child: PDivider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: PBlocConsumer<SymbolBloc, SymbolState>(
                    bloc: _symbolBloc,
                    listenWhen: (previous, current) {
                      return current.isUpdated &&
                          current.watchingItems.map((e) => e.symbolCode).toList().contains(
                                _symbol,
                              );
                    },
                    listener: (BuildContext context, SymbolState state) {
                      MarketListModel? newModel = state.watchingItems.firstWhereOrNull(
                        (element) => element.symbolCode == _symbol,
                      );
                      if (newModel == null) return;
                      setState(() {
                        _marketListModel = newModel;
                        _lastPrice = _marketListModel == null
                            ? 0
                            : MoneyUtils().getPrice(
                                _marketListModel!,
                                null,
                              );
                      });
                    },
                    builder: (context, state) {
                      return PriceAlarmCurrentPricesRow(
                        buyPrice: _marketListModel?.bid ?? 0,
                        sellPrice: _marketListModel?.ask ?? 0,
                        lastPrice: _marketListModel?.last ?? 0,
                        percentage: _marketListModel?.differencePercent ?? 0.0,
                        currencySymbol: _getCurrencySymbol(),
                      );
                    }),
              ),
              const SizedBox(
                height: Grid.l,
              ),
              Container(
                height: 35,
                width: MediaQuery.sizeOf(context).width,
                color: context.pColorScheme.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: SlidingSegment(
                  backgroundColor: context.pColorScheme.card,
                  segmentList: [
                    PSlidingSegmentModel(
                      segmentTitle: L10n.tr('fiyat'),
                      segmentColor: context.pColorScheme.secondary,
                    ),
                    PSlidingSegmentModel(
                      segmentTitle: L10n.tr('change'),
                      segmentColor: context.pColorScheme.secondary,
                    ),
                  ],
                  onValueChanged: (p0) {
                    setState(() {
                      _selectedSlidingIndex = p0;
                      if (_selectedSlidingIndex == AlarmPriceSliding.percentage.value) {
                        _alarmPriceTC.text = '0';
                      } else {
                        _priceChangeTC.text = '0';
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: Grid.s,
              ),
              _selectedSlidingIndex == AlarmPriceSliding.price.value
                  ?
                  // Fiyat Tab'ı
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Grid.m,
                      ),
                      child: AlarmSlidingPrice(
                        controller: _alarmPriceTC,
                        lastPrice: _marketListModel == null ? 0.0 : MoneyUtils().getPrice(_marketListModel!, null),
                        goalPrice: (lastPrice) {
                          setState(() {
                            _goalPrice = lastPrice;
                          });
                        },
                        currencySymbol: _getCurrencySymbol(),
                      ),
                    )
                  :
                  // Değişim Tab'ı
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Grid.m,
                      ),
                      child: AlarmSlidingPercentage(
                        controller: _priceChangeTC,
                        lastPrice: _marketListModel == null ? 0.0 : MoneyUtils().getPrice(_marketListModel!, null),
                        goalPrice: (lastPrice) {
                          setState(() {
                            _goalPrice = lastPrice;
                          });
                        },
                      ),
                    ),

              const SizedBox(
                height: Grid.m,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: DescriptionTextfield(
                  key: _noteKey,
                  focusNode: _noteFocusNode,
                  controller: _noteController,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 100,
                  showCounter: false,
                  onTap: () => KeyboardUtils().scrollOnFocus(
                    context,
                    _noteKey,
                    _scrollController,
                  ),
                ),
              ),
              const SizedBox(
                height: Grid.l,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: _validityWidget(),
              ),

              _pendingAlarmsWidget(), // Daha önceki oluşturmuş olduğum ve bekleyenler statüsünde olan alarmların listesi.
            ],
          ),
        ),
      ),
      bottomNavigationBar: generalButtonPadding(
        context: context,
        child: PBlocBuilder<AlarmBloc, AlarmState>(
            bloc: _alarmBloc,
            builder: (context, state) {
              return PButton(
                  text: L10n.tr('alarm_kur'),
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (_alarmBloc.state.priceAlarms.length + _alarmBloc.state.newsAlarms.length >= 90) {
                            PBottomSheet.showError(
                              context,
                              content: L10n.tr('max_alarm_limit_reached'),
                            );
                            return;
                          }

                          _alarmBloc.add(
                            // Alarm kurduğumuz event.
                            SetPriceAlarmEvent(
                              condition: _goalPrice > _lastPrice ? '>' : '<',
                              price: _goalPrice,
                              symbolName: _symbol,
                              validity: _selectedValidity,
                              note: _noteController.text,
                              callback: (isSuccess) async {
                                if (isSuccess) {
                                  router.push(
                                    const AlarmSuccessRoute(),
                                  );
                                }
                              },
                            ),
                          );
                        });
            }),
      ),
    );
  }

  Widget _validityWidget() {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      onTap: () {
        PBottomSheet.show(
          context,
          title: L10n.tr('gecerlilik_tarihi'),
          child: Column(
            children: AlarmValidityEnum.values.map((e) {
              return FilterCategoryButton(
                title: L10n.tr(e.name),
                isSelected: _selectedValidity == e,
                hasDivider: e != AlarmValidityEnum.values.last,
                onTap: () {
                  setState(() {
                    _selectedValidity = e;

                    router.maybePop();
                  });
                },
              );
            }).toList(),
          ),
        );
      },
      child: Row(
        spacing: Grid.xs,
        children: [
          Text(
            L10n.tr(_selectedValidity.name),
            style: context.pAppStyle.labelMed14primary,
          ),
          SvgPicture.asset(
            ImagesPath.chevron_down,
            width: 15,
            height: 15,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pendingAlarmsWidget() {
    return PBlocBuilder<AlarmBloc, AlarmState>(
      bloc: _alarmBloc,
      builder: (context, state) {
        if (state.priceAlarms.isEmpty) {
          return const SizedBox.shrink();
        }

        List<PriceAlarm> relatedSymbolList = state.priceAlarms
            .where(
              (element) => element.isActive && element.symbol == _symbol,
            )
            .toList();

        if (relatedSymbolList.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Grid.l,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Grid.s,
                horizontal: Grid.m,
              ),
              child: Text(
                L10n.tr('pending_alarm'),
                style: context.pAppStyle.labelReg14textPrimary,
              ),
            ),
            const SizedBox(
              height: Grid.s,
            ),
            const PDivider(
              padding: EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Grid.s + Grid.xs,
                horizontal: Grid.m,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    L10n.tr('asset'),
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                  Text(
                    L10n.tr('alarm_price'),
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ],
              ),
            ),
            const PDivider(
              padding: EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: relatedSymbolList.length,
              separatorBuilder: (context, index) => const PDivider(
                padding: EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
              ),
              itemBuilder: (context, index) {
                final alarm = relatedSymbolList[index];
                if (!alarm.isActive) return const SizedBox.shrink();

                return AlarmTile(
                  alarm: alarm,
                  isPriceAlarm: true,
                  showCurrentPrice: false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
