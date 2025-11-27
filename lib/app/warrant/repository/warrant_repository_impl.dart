import 'package:piapiri_v2/app/warrant/repository/warrant_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';

class WarrantRepositoryImpl extends WarrantRepository {
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<List<Map<String, dynamic>>> getMarketMakersDropDownList() async {
    List<Map<String, dynamic>> marketMakerDataList = await dbHelper.getMarketMakersDropDownList();
    return marketMakerDataList;
  }

  @override
  Future<List<dynamic>> getUnderlyindAssetDropDownList({
    required String selectedMarketMaker,
  }) async {
    List<dynamic> underlyingAssetData = await dbHelper.getUnderlyindAssetDropDownList(selectedMarketMaker) ?? [];
    return underlyingAssetData;
  }

  @override
  Future<ApiResponse> filterWarrants({
    required String issuer,
    required String underlying,
    String? risk,
    String? type,
  }) {
    String riskFilter = '';
    String typeFilter = '';
    String underlyingFilter = '&underlyings=$underlying';
    String issuerFilter = issuer.isEmpty ? issuer : 'issuers=$issuer';
    if (risk != null) {
      riskFilter = '&risk=$risk';
    }
    if (type != null) {
      typeFilter = '&type=$type';
    }
    return getIt<PPApi>().matriksApiClient.get(
          '${getIt<MatriksBloc>().state.endpoints!.rest!.warrantCoach!.warrants?.url ?? ''}?$issuerFilter$underlyingFilter$riskFilter$typeFilter',
        );
  }

  @override
  Future<List<Map<String, dynamic>>> getDetailsOfSymbols({required List<dynamic> symbols}) async {
    return await dbHelper.getDetailsOfSymbols(symbols);
  }

  @override
  Future<bool> hasUnderlying({
    required String symbol,
  }) async {
    bool marketMakerDataList = await dbHelper.underlyingNameExists(
      symbol,
    );

    return marketMakerDataList;
  }
}
