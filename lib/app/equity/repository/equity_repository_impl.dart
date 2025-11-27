import 'package:piapiri_v2/app/equity/repository/equity_repository.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/filter_category_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class EquityRepositoryImpl extends EquityRepository {
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<List<MarketListModel>> getSymbolInfo({
    required FilterCategoryItemModel selectedList,
  }) async {
    List<Map<String, dynamic>> symbols = [];
    if (selectedList.type == '2') {
      symbols = await dbHelper.getIndexListSubItemList(selectedList);
    } else {
      String mainListName = await dbHelper.getListDropDownList(selectedList);

      symbols = await dbHelper.getListSubItemList(selectedList, mainListName);
    }

    return symbols
        .map(
          (e) => MarketListModel(
            symbolCode: e['Name'],
            updateDate: '',
            type: e['TypeCode'],
            underlying: e['UnderlyingName'] ?? '',
            marketCode: e['MarketCode'] ?? '',
            description: e['Description'] ?? '',
            swapType: e['SwapType'] ?? '',
            actionType: e['ActionType'] ?? '',
            issuer: e['Issuer'] ?? '',
          ),
        )
        .toList();
  }
}
