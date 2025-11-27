import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_bloc.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_event.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_event.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DirectionViopWarrantWidget extends StatefulWidget {
  final String detailSymbolName;
  final String underlyingSymbolName;
  const DirectionViopWarrantWidget({
    super.key,
    required this.detailSymbolName,
    required this.underlyingSymbolName,
  });

  @override
  State<DirectionViopWarrantWidget> createState() => _DirectionViopWarrantWidgetState();
}

class _DirectionViopWarrantWidgetState extends State<DirectionViopWarrantWidget> {
  final WarrantBloc _warrantBloc = getIt<WarrantBloc>();
  final ViopBloc _viopBloc = getIt<ViopBloc>();
  bool _hasViop = false;

  @override
  void initState() {
    _warrantBloc.add(
      HasWarrantOfSymbolEvent(
        symbol: widget.underlyingSymbolName,
      ),
    );
    _viopBloc.add(
      GetUnderlyingListEvent(
        callback: (underlyingList) {
          if (mounted && underlyingList.contains(widget.underlyingSymbolName)) {
            setState(() {
              _hasViop = true;
            });
          }
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<WarrantBloc, WarrantState>(
        bloc: _warrantBloc,
        builder: (context, state) {
          bool showWarrantButton = state.hasWarrant;

          if (!showWarrantButton && !_hasViop) {
            /// hem warantı hem viop'u yoksa butonları gösterme
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Grid.l,
              ),
              Text(
                L10n.tr('perform_the_following'),
                style: context.pAppStyle.labelReg14textSecondary,
              ),
              const SizedBox(
                height: Grid.s + Grid.xs,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (showWarrantButton)
                    Expanded(
                      child: PCustomOutlinedButtonWithIcon(
                        fillParentWidth: true,
                        text: L10n.tr('symbol_warrants', args: [widget.underlyingSymbolName]),
                        textStyle: context.pAppStyle.labelMed14primary,
                        iconSource: ImagesPath.arrow_up_right,
                        buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
                        onPressed: () {
                          if (router.routeNames.contains(WarrantRoute.name) ||
                              router.routeNames.contains(ViopRoute.name)) {
                            router.popUntilRouteWithName(
                              SymbolDetailRoute.name,
                            );

                            router.push(
                              WarrantRoute(
                                underlyingName: widget.underlyingSymbolName,
                                ignoreUnsubList: [widget.detailSymbolName],
                                selectedMarketMaker: '',
                              ),
                            );
                          } else {
                            router.push(
                              WarrantRoute(
                                underlyingName: widget.underlyingSymbolName,
                                ignoreUnsubList: [widget.detailSymbolName],
                                selectedMarketMaker: '',
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  SizedBox(
                    width: showWarrantButton && !_hasViop || !showWarrantButton && _hasViop ? 0 : Grid.s + Grid.xxs,
                  ),
                  if (_hasViop)
                    Expanded(
                      child: PCustomOutlinedButtonWithIcon(
                        fillParentWidth: true,
                        text: L10n.tr('viop_contracts'),
                        textStyle: context.pAppStyle.labelMed14primary,
                        iconSource: ImagesPath.arrow_up_right,
                        buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
                        onPressed: () {
                          if (router.routeNames.contains(WarrantRoute.name) ||
                              router.routeNames.contains(ViopRoute.name)) {
                            router.popUntilRouteWithName(DashboardRoute.name);
                            // viop page dispose süresi için gerekli.
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                router.push(
                                  ViopRoute(
                                    underlyingName: widget.underlyingSymbolName,
                                    ignoreUnsubList: [widget.detailSymbolName],
                                    awaitDisposeTime: true,
                                  ),
                                );
                              },
                            );
                          } else {
                            router.push(
                              ViopRoute(
                                underlyingName: widget.underlyingSymbolName,
                                ignoreUnsubList: [widget.detailSymbolName],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                ],
              )
            ],
          );
        });
  }
}
