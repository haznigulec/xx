import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class IpoLastPriceWidget extends StatefulWidget {
  final IpoModel ipo;
  final String symbol;
  final bool showIpoPrice;
  const IpoLastPriceWidget({
    super.key,
    required this.ipo,
    required this.symbol,
    this.showIpoPrice = true,
  });

  @override
  State<IpoLastPriceWidget> createState() => _IpoLastPriceWidgetState();
}

class _IpoLastPriceWidgetState extends State<IpoLastPriceWidget> with AutomaticKeepAliveClientMixin {
  late SymbolBloc _symbolBloc;
  MarketListModel? _selectedItem;
  String _symbolName = '';
  bool _isSubscribed = false;
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _symbolBloc = getIt<SymbolBloc>();
    // Widget tam olarak mount olduktan sonra subscribe ol
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposed) {
        _initializeSymbol();
      }
    });
  }

  void _initializeSymbol() {
    _symbolName = (widget.symbol.contains('.HE')
            ? widget.symbol.replaceAll('.HE', '')
            : getIt<AppInfoBloc>().state.symbolSuffixList.any((e) => e.name == widget.symbol)
                ? getIt<AppInfoBloc>()
                    .state
                    .symbolSuffixList
                    .firstWhere(
                      (e) => e.name == widget.symbol,
                    )
                    .nameWithSuffix
                : widget.symbol)
        .trim();

    if (!_isSubscribed && !_isDisposed && mounted) {
      _symbolBloc.add(
        SymbolSubOneTopicEvent(
          symbol: _symbolName,
        ),
      );
      _isSubscribed = true;
    }

    _updateSelectedItem();
  }

  void _updateSelectedItem() {
    if (_isDisposed || !mounted) return;

    final newModel = _symbolBloc.state.watchingItems.firstWhereOrNull(
      (element) => element.symbolCode == _symbolName,
    );

    if (newModel != null && _selectedItem?.last != newModel.last) {
      if (mounted && !_isDisposed) {
        setState(() {
          _selectedItem = newModel;
        });
      }
    }
  }

  @override
  void didUpdateWidget(IpoLastPriceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // SADECE symbol değiştiğinde işlem yap
    if (oldWidget.symbol == widget.symbol) {
      return;
    }
    _unsubscribeFromSymbol();
    _isSubscribed = false;
    _selectedItem = null;

    // Yeni symbol için subscribe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposed) {
        _initializeSymbol();
      }
    });
  }

  void _unsubscribeFromSymbol() {
    if (_isSubscribed && !_isDisposed) {
      // Eğer _selectedItem varsa onunla unsubscribe yap
      if (_selectedItem != null) {
        _symbolBloc.add(
          SymbolUnsubsubscribeEvent(
            symbolList: [_selectedItem!],
          ),
        );
      } else {
        // Eğer _selectedItem yoksa, state'ten bul
        final item = _symbolBloc.state.watchingItems.firstWhereOrNull(
          (element) => element.symbolCode == _symbolName,
        );
        if (item != null) {
          _symbolBloc.add(
            SymbolUnsubsubscribeEvent(
              symbolList: [item],
            ),
          );
        }
      }
      _isSubscribed = false;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _unsubscribeFromSymbol();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PBlocConsumer<SymbolBloc, SymbolState>(
      bloc: _symbolBloc,
      listenWhen: (previous, current) {
        if (_isDisposed) return false;

        // İlk data geldiğinde veya güncelleme olduğunda dinle
        final currentItem = current.watchingItems.firstWhereOrNull(
          (item) => item.symbolCode == _symbolName,
        );

        final previousItem = previous.watchingItems.firstWhereOrNull(
          (item) => item.symbolCode == _symbolName,
        );

        // İlk kez data geldi veya last fiyat değişti
        return currentItem != null && (previousItem == null || previousItem.last != currentItem.last);
      },
      listener: (context, state) {
        if (_isDisposed) return;

        final newModel = state.watchingItems.firstWhereOrNull(
          (element) => element.symbolCode == _symbolName,
        );

        if (newModel != null) {
          if (_selectedItem == null || _selectedItem!.last != newModel.last) {
            if (mounted && !_isDisposed) {
              setState(() {
                _selectedItem = newModel;
              });
            }
          }
        }
      },
      buildWhen: (previous, current) {
        if (_isDisposed) return false;

        // State değiştiğinde ve symbol'ümüz varsa rebuild et
        final hasMySymbol = current.watchingItems.any(
          (item) => item.symbolCode == _symbolName,
        );

        return hasMySymbol;
      },
      builder: (context, state) {
        if (_isDisposed) {
          return const SizedBox.shrink();
        }

        // İlk olarak state'ten güncel veriyi al
        final currentSymbol = state.watchingItems.firstWhereOrNull(
          (element) => element.symbolCode == _symbolName,
        );

        // Eğer state'te varsa ama _selectedItem null ise, direkt state'teki veriyi kullan
        if (currentSymbol != null && _selectedItem == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_isDisposed) {
              setState(() {
                _selectedItem = currentSymbol;
              });
            }
          });
        }

        // Loading kontrolü - hem state hem de _selectedItem'a bak
        if (state.isFetching && _selectedItem == null && currentSymbol == null) {
          return const PLoading();
        }

        // Kullanılacak veriyi belirle (state'teki güncel veriyi tercih et)
        final symbolToUse = currentSymbol ?? _selectedItem;

        if (symbolToUse == null) {
          return Text(
            L10n.tr('demand_is_gathering'),
            style: context.pAppStyle.labelReg14primary.copyWith(
              fontWeight: FontWeight.bold,
            ),
          );
        }

        double oldPrice = 0.0;
        double totalChange = 0.0;
        String startPrice = '';
        String endPrice = '';

        if (widget.ipo.startPrice != null) {
          oldPrice = widget.ipo.startPrice!;
          startPrice = MoneyUtils().readableMoney(widget.ipo.startPrice!);
        }

        if (widget.ipo.endPrice != null) {
          endPrice = '-${MoneyUtils().readableMoney(widget.ipo.endPrice!)}';
        }

        if (oldPrice > 0) {
          totalChange = ((MoneyUtils().getPrice(symbolToUse, null) / oldPrice) * 100) - 100;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.showIpoPrice) ...[
              Text(
                widget.ipo.startDate != null && widget.ipo.endDate != null
                    ? '${L10n.tr('ipo_price')}: ₺$startPrice$endPrice'
                    : L10n.tr('ipo_application_process'),
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              const SizedBox(
                height: Grid.xxs,
              ),
            ],
            Text(
              '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(MoneyUtils().getPrice(symbolToUse, null))}',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
            const SizedBox(
              height: Grid.xxs,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  totalChange > 0 ? ImagesPath.trending_up : ImagesPath.trending_down,
                  width: Grid.m,
                  height: Grid.m,
                  colorFilter: ColorFilter.mode(
                    totalChange > 0 ? context.pColorScheme.success : context.pColorScheme.critical,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: Grid.xxs / 4,
                ),
                Text(
                  MoneyUtils().readableMoney(totalChange).formatNegativePriceAndPercentage(),
                  style: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m - Grid.xxs,
                    color: totalChange > 0 ? context.pColorScheme.success : context.pColorScheme.critical,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
