import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/fund_special_list_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/model_portfolio_detail_info_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/model_portfolio_item_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/robotic_and_fund_basket_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_bist_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/repository/quick_portfolio_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class QuickPortfolioBloc extends PBloc<QuickPortfolioState> {
  final QuickPortfolioRepository _quickPortfolioRepository;

  QuickPortfolioBloc({
    required QuickPortfolioRepository quickPortfolioRepository,
  })  : _quickPortfolioRepository = quickPortfolioRepository,
        super(initialState: const QuickPortfolioState()) {
    on<GetRoboticBasketsEvent>(_onGetRoboticBaskets);
    on<GetModelPortfolioEvent>(_onGetModelPortfolio);
    on<GetPreparedPortfolioEvent>(_onGetFundPortfolio);
    on<GetSpecificListEvent>(_onGetSpecificList);
    on<GetModelPortfolioByIdEvent>(_onModelPortfolioGetById);
    on<GetFundInfoFromSpecialListByIdEvent>(_onGetFundInfoFromSpecialListById);
    on<GetDetailsOfSymbolsEvent>(_onGetDetailsOfSymbols);
    on<GetFundFounderCodeEvent>(_onGetFundFounder);
  }
  FutureOr<void> _onGetRoboticBaskets(
    GetRoboticBasketsEvent event,
    Emitter<QuickPortfolioState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _quickPortfolioRepository.getRoboticBaskets(event.portfolioId);

    if (response.success) {
      List<QuickPortfolioAssetModel> newRoboticPortfolios = response.data['Varliklar']
          .map<QuickPortfolioAssetModel>(
            (e) => QuickPortfolioAssetModel.fromJson(e).copyWith(portfolioId: event.portfolioId),
          )
          .toList();

      List<QuickPortfolioAssetModel> updatedRoboticPortfolios = [
        ...state.roboticPortfolios,
        ...newRoboticPortfolios,
      ];
      emit(
        state.copyWith(
          type: PageState.success,
          roboticPortfolios: updatedRoboticPortfolios,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            message: response.error?.message ?? '',
            showErrorWidget: false,
            errorCode: '03QCKP01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetModelPortfolio(
    GetModelPortfolioEvent event,
    Emitter<QuickPortfolioState> emit,
  ) async {
    if (state.modelPortfolios.isNotEmpty &&
        state.modelPortfoliosLangKey.isNotEmpty &&
        state.modelPortfoliosLangKey == getIt<LanguageBloc>().state.languageCode) {
      return;
    }

    emit(
      state.copyWith(
        type: PageState.loading,
        modelPortfoliosLangKey: getIt<LanguageBloc>().state.languageCode,
      ),
    );

    ApiResponse response = await _quickPortfolioRepository.getModelPortfolio(
      languageCode: getIt<LanguageBloc>().state.languageCode,
    );
    if (response.success) {
      List<ModelPortfolioModel> modelPortfolios = response.data['portfolios']
          .where((element) => element['isModelPortfolio'] == true)
          .map<ModelPortfolioModel>((dynamic item) => ModelPortfolioModel.fromJson(item))
          .toList();

      emit(
        state.copyWith(
          modelPortfolios: modelPortfolios,
          type: PageState.success,
        ),
      );

      event.callback?.call(modelPortfolios);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '03QCKP02',
          ),
        ),
      );
    }
  }

//model portfolio detay
  FutureOr<void> _onModelPortfolioGetById(
    GetModelPortfolioByIdEvent event,
    Emitter<QuickPortfolioState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _quickPortfolioRepository.getById(
      id: event.id,
      languageCode: getIt<LanguageBloc>().state.languageCode,
    );

    if (response.success) {
      ModelPortfolioDetailInfoModel modelPortfolioDetail = ModelPortfolioDetailInfoModel.fromJson(
        response.data,
      );

      emit(
        state.copyWith(
          modelPortfolioDetail: modelPortfolioDetail,
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '03QCKP02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFundPortfolio(
    GetPreparedPortfolioEvent event,
    Emitter<QuickPortfolioState> emit,
  ) async {
    if (event.portfolioKey == 'robotik_sepet' &&
        state.fundPortfolios['robotik_sepet'] != null &&
        state.robotikSepetFundPortfoliosLangKey.isNotEmpty &&
        state.robotikSepetFundPortfoliosLangKey == getIt<LanguageBloc>().state.languageCode) {
      return;
    }

    emit(
      state.copyWith(
        type: PageState.loading,
        robotikSepetFundPortfoliosLangKey: event.portfolioKey == 'robotik_sepet'
            ? getIt<LanguageBloc>().state.languageCode
            : state.robotikSepetFundPortfoliosLangKey,
      ),
    );

    ApiResponse response = await _quickPortfolioRepository.getPreparedPortfolios(
      porfolioKey: event.portfolioKey,
      languageCode: getIt<LanguageBloc>().state.languageCode,
    );

    if (response.success) {
      List<RoboticAndFundBasketModel> portfolio = response.data['settings'][event.portfolioKey]
          .map<RoboticAndFundBasketModel>((e) => RoboticAndFundBasketModel.fromJson(e))
          .toList();

      Map<String, List<RoboticAndFundBasketModel>> fundPortfolios = Map.from(state.fundPortfolios);
      fundPortfolios[event.portfolioKey] = portfolio;
      if (event.callback != null) {
        event.callback!(portfolio);
      }
      emit(
        state.copyWith(
          type: PageState.success,
          fundPortfolios: fundPortfolios,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '03QCKP03',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetSpecificList(
    GetSpecificListEvent event,
    Emitter<QuickPortfolioState> emit,
  ) async {
    if (event.mainGroup == MarketTypeEnum.marketBist.value &&
        state.equitySymbolList.isNotEmpty &&
        state.viopSymbolList.isNotEmpty &&
        state.warrantSymbolList.isNotEmpty &&
        state.specificListLangKey.isNotEmpty &&
        state.specificListLangKey == getIt<LanguageBloc>().state.languageCode) {
      return;
    }
    emit(
      state.copyWith(
        type: PageState.loading,
        specificListLangKey: getIt<LanguageBloc>().state.languageCode,
      ),
    );

    ApiResponse response = await _quickPortfolioRepository.getSpecificList(
      mainGroup: event.mainGroup,
    );

    if (response.success) {
      List<SpecificListModel> specificList =
          response.data['specificList'].map<SpecificListModel>((e) => SpecificListModel.fromJson(e)).toList();
      specificList.sort((a, b) => a.orderNo.compareTo(b.orderNo));

      if (event.mainGroup == BistType.fundBist.type) {
        for (var list in specificList) {
          final hasListSymbolType = list.symbolType?.isNotEmpty == true;
          if (!hasListSymbolType) {
            list.symbolType = SymbolTypes.fund.dbKey;
          }
        }
      }

      // Geçici değişkenler
      List<String> fundFounderList = [...state.fundFounderList];
      List<MarketListModel> newSymbolList = [];
      List<MarketListModel> homeBistSymbolList = [
        ...state.homepageEquitySymbolList,
        ...state.homepageWarrantSymbolList,
        ...state.homepageViopSymbolList
      ];
      List<String> homepageFundSymbolList = [...state.homepageFundSymbolList];
      List<String> homepageUsFilteredList = [...state.homepageUsSymbolList];

//homepagedeki bist listelerini filtreler
      final List<SpecificListModel> homepageBistFilteredList = specificList
          .where((e) =>
              e.symbolType == SpecialListSymbolTypeEnum.equity.type ||
              e.symbolType == SpecialListSymbolTypeEnum.viop.type ||
              e.symbolType == SpecialListSymbolTypeEnum.warrant.type)
          .toList();

//homepagedeki amerikan hazır listelerini filtreler
      if (event.mainGroup == MarketTypeEnum.home.value) {
        homepageUsFilteredList = specificList
            .where((e) => e.symbolType == SpecialListSymbolTypeEnum.foreign.type)
            .expand((e) => e.symbolNames)
            .toSet()
            .toList();
      }
//homepagedeki fundları filtreler
      final List<SpecificListModel> homepageFundFilteredList = specificList
          .where((e) =>
              e.symbolType == SpecialListSymbolTypeEnum.fund.type ||
              (e.symbolType != null && e.symbolType!.isEmpty) && event.mainGroup == MarketTypeEnum.home.value)
          .toList();

      // fund founder kodlarını al
      if (event.mainGroup == MarketTypeEnum.marketFund.value && specificList.isNotEmpty && fundFounderList.isEmpty) {
        _quickPortfolioRepository.fetchFundFounderCodes(specificList.expand((e) => e.symbolNames).toSet().toList());
      } else if (event.mainGroup == MarketTypeEnum.home.value &&
          homepageFundFilteredList.isNotEmpty &&
          homepageFundSymbolList.isEmpty) {
        _quickPortfolioRepository
            .fetchFundFounderCodes(homepageFundFilteredList.expand((e) => e.symbolNames).toSet().toList());
      }

      // sembol bilgilerini çek //bist veya homepagede gösterilerbilir
      if (event.mainGroup == MarketTypeEnum.marketBist.value) {
        List<String> symbolList = specificList.expand((e) => e.symbolNames).toSet().toList();
        newSymbolList = await _quickPortfolioRepository.fetchSymbolDetails(symbolList);
      } else if (event.mainGroup == MarketTypeEnum.home.value && homepageBistFilteredList.isNotEmpty) {
        List<String> symbolList = homepageBistFilteredList.expand((e) => e.symbolNames).toSet().toList();
        homeBistSymbolList = await _quickPortfolioRepository.fetchSymbolDetails(symbolList);
      }

      emit(
        state.copyWith(
          fundFounderList: fundFounderList,
          equitySymbolList: newSymbolList
              .where((e) =>
                  e.type == SymbolTypes.equity.dbKey ||
                  e.type == SymbolTypes.right.dbKey ||
                  e.type == SymbolTypes.etf.dbKey)
              .toList(),
          viopSymbolList: newSymbolList
              .where((e) => e.type == SymbolTypes.future.dbKey || e.type == SymbolTypes.option.dbKey)
              .toList(),
          warrantSymbolList: newSymbolList
              .where(
                (e) => e.type == SymbolTypes.warrant.dbKey || e.type == SymbolTypes.certificate.dbKey,
              )
              .toList(),
          specificList: specificList,
          homeSpecificList: event.mainGroup == MarketTypeEnum.home.value ? specificList : state.homeSpecificList,
          homepageEquitySymbolList: homeBistSymbolList
              .where((e) =>
                  e.type == SymbolTypes.equity.dbKey ||
                  e.type == SymbolTypes.right.dbKey ||
                  e.type == SymbolTypes.etf.dbKey)
              .toList(),
          homepageWarrantSymbolList: homeBistSymbolList
              .where((e) => e.type == SymbolTypes.warrant.dbKey || e.type == SymbolTypes.certificate.dbKey)
              .toList(),
          homepageViopSymbolList: homeBistSymbolList
              .where((e) => e.type == SymbolTypes.future.dbKey || e.type == SymbolTypes.option.dbKey)
              .toList(),
          homepageFundSymbolList: homepageFundSymbolList,
          homepageUsSymbolList: homepageUsFilteredList,
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '03SPCL01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFundInfoFromSpecialListById(
    GetFundInfoFromSpecialListByIdEvent event,
    Emitter<QuickPortfolioState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _quickPortfolioRepository.getFundInfoFromSpecialListById(
      specialListId: event.specialListId,
    );

    if (response.success) {
      List<FundSpecialListModel> fundSpecialList =
          response.data['specialList'].map<FundSpecialListModel>((e) => FundSpecialListModel.fromJson(e)).toList();

      emit(
        state.copyWith(
          fundSpecialList: fundSpecialList,
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '03SPCL02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetDetailsOfSymbols(
    GetDetailsOfSymbolsEvent event,
    Emitter<QuickPortfolioState> emit,
  ) async {
    List<MarketListModel> symbolList = await _quickPortfolioRepository.fetchSymbolDetails(event.codes);
    await event.callback?.call(symbolList);
  }

  FutureOr<void> _onGetFundFounder(
    GetFundFounderCodeEvent event,
    Emitter<QuickPortfolioState> emit,
  ) async {
    List<String> homepageFundSymbolList = await _quickPortfolioRepository.fetchFundFounderCodes(event.codes);
    await event.callback?.call(homepageFundSymbolList);
  }
}
