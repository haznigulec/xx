import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_state.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/position_list_tile.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_fake_field.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolPositionList extends StatelessWidget {
  final String? accountId;
  final bool showSearch;
  final Function(PositionModel)? onTapPosition;
  const SymbolPositionList({
    super.key,
    this.accountId,
    this.showSearch = false,
    this.onTapPosition,
  });

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<SymbolSearchBloc, SymbolSearchState>(
      bloc: getIt<SymbolSearchBloc>(),
      builder: (context, state) {
        if (state.isLoading) {
          return const PLoading();
        }
        return Column(
          children: [
            if (showSearch)
              SymbolSearchFakeField(
                onTap: () {
                  Navigator.pop(context);
                  router.push(
                    SymbolSearchRoute(
                      filterList: const [
                        SymbolSearchFilterEnum.future,
                        SymbolSearchFilterEnum.option,
                      ],
                      onTapSymbol: (List<SymbolModel> symbolList) {
                        SymbolModel symbolModel = symbolList.first;
                        onTapPosition?.call(
                          PositionModel(
                            symbolName: symbolModel.name,
                            description: symbolModel.description,
                            accountId: accountId,
                            underlyingName: symbolModel.underlyingName,
                            symbolType: stringToSymbolType(symbolModel.typeCode),
                            qty: 0,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            state.positionList.isEmpty
                ? SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    child: NoDataWidget(
                      iconName: ImagesPath.search,
                      message: L10n.tr('no_position'),
                    ),
                  )
                : Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.6,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.positionList.length,
                      separatorBuilder: (context, index) => const PDivider(),
                      itemBuilder: (context, index) {
                        PositionModel positionModel = state.positionList[index];
                        return PositionListTile(
                          positionModel: positionModel,
                          onTap: () {
                            onTapPosition?.call(positionModel);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }
}
