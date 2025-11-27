import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_bloc.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_event.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_state.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class SymbolDetailAdvicesWidget extends StatefulWidget {
  final MarketListModel symbol;
  const SymbolDetailAdvicesWidget({
    super.key,
    required this.symbol,
  });

  @override
  State<SymbolDetailAdvicesWidget> createState() => _SymbolDetailAdvicesWidgetState();
}

class _SymbolDetailAdvicesWidgetState extends State<SymbolDetailAdvicesWidget> {
  final AdvicesBloc _advicesBloc = getIt<AdvicesBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();

  @override
  initState() {
    super.initState();
    if (_authBloc.state.isLoggedIn) {
      _advicesBloc.add(
        GetAdvicesEvent(
          symbolName: widget.symbol.symbolCode,
          fetchRoboSignals: true,
          mainGroup: MarketTypeEnum.marketBist.value,
        ),
      );
      _advicesBloc.add(
        GetAdviceHistoryEvent(
          symbolName: widget.symbol.symbolCode,
          mainGroup: MarketTypeEnum.marketBist.value,
          year: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AdvicesBloc, AdvicesState>(
      bloc: _advicesBloc,
      builder: (context, state) {
        final isLoading = state.advicesState == PageState.loading;

        /// --- 1) UI Visibility decide ---
        final hasData =
            state.adviceBySymbolNameList.isNotEmpty || (state.adviceHistoryModel.closedAdvices?.isNotEmpty ?? false);

        // Veri yok + loading değil → hiç gösterme
        if (!isLoading && !hasData) {
          return const SizedBox.shrink();
        }

        /// --- 2) Decide Icon Color ---
        final Color iconColor = _resolveIconColor(state, context, isLoading);

        /// --- 3) UI Output ---
        return Shimmerize(
          enabled: isLoading,
          child: InkWell(
            onTap: () {
              if (isLoading) return;
              router.push(
                AdvicesRoute(
                  symbol: widget.symbol,
                  advices: state.adviceBySymbolNameList,
                  closedAdvices: state.adviceHistoryModel.closedAdvices ?? [],
                ),
              );
            },
            child: SvgPicture.asset(
              ImagesPath.oneri,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _resolveIconColor(
    AdvicesState state,
    BuildContext context,
    bool isLoading,
  ) {
    if (isLoading) {
      return context.pColorScheme.iconPrimary;
    }

    if (state.adviceBySymbolNameList.isNotEmpty) {
      final first = state.adviceBySymbolNameList[0];
      return first.adviceSideId == 1 ? context.pColorScheme.success : context.pColorScheme.critical;
    }

    if (state.adviceHistoryModel.closedAdvices?.isNotEmpty == true) {
      return context.pColorScheme.iconPrimary;
    }

    // default fallback (normalde buraya düşmez)
    return context.pColorScheme.iconPrimary;
  }
}
