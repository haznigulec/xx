import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_state.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/list/settings_bottomsheet_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/depth_type_enum.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class DepthSettingsPage extends StatefulWidget {
  const DepthSettingsPage({super.key});

  @override
  State<DepthSettingsPage> createState() => _DepthSettingsPageState();
}

class _DepthSettingsPageState extends State<DepthSettingsPage> {
  late AppSettingsBloc _appSettingsBloc;
  final List<int> _stageList = [];
  late int _depthRowCount;
  late DepthTypeEnum _depthType;
  @override
  void initState() {
    super.initState();
    _appSettingsBloc = getIt<AppSettingsBloc>();
    _stageList.addAll(List<int>.generate(25, (index) => index + 1));
    _depthRowCount = _appSettingsBloc.state.orderSettings.depthCount;
    _depthType = _appSettingsBloc.state.orderSettings.depthType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PInnerAppBar(
          title: L10n.tr('depth_preferences'),
        ),
        body: PBlocBuilder<AppSettingsBloc, AppSettingsState>(
          bloc: _appSettingsBloc,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: PLoading(),
              );
            }
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                child: Column(
                  children: [
                    const SizedBox(
                      height: Grid.m + Grid.xs,
                    ),
                    SettingsBottomsheetTile(
                      title: L10n.tr('depth_row_count'),
                      selectedValue: _depthRowCount,
                      items: _stageList
                          .map(
                            (e) => DropdownModel(
                              name: '$e ${L10n.tr('stage')}',
                              value: e,
                            ),
                          )
                          .toList(),
                      onSelect: (value) => setState(() {
                        _depthRowCount = value;
                      }),
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    SettingsBottomsheetTile(
                      title: L10n.tr('total_depth'),
                      selectedValue: _depthType,
                      items: DepthTypeEnum.values
                          .map(
                            (e) => DropdownModel(
                              name: L10n.tr(e.localizationKey),
                              value: e,
                            ),
                          )
                          .toList(),
                      onSelect: (value) => setState(() {
                        _depthType = value;
                      }),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: generalButtonPadding(
                context: context,
                child: PButton(
                  variant: PButtonVariant.brand,
                  fillParentWidth: true,
                  text: L10n.tr('kaydet'),
                  onPressed: () {
                    _appSettingsBloc.add(
                      SetOrderSettingsEvent(
                        depthCount: _depthRowCount,
                        depthType: _depthType,
                        onSuccess: (message, isSuccsess) async {
                          if (isSuccsess) {
                            await router.maybePop();
                          }
                          PBottomSheet.showError(
                            NavigatorKeys.navigatorKey.currentContext ?? context,
                            content: L10n.tr(
                              isSuccsess ? 'transaction_was_successfully_completed' : 'message',
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ));
  }
}
