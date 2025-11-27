import 'package:dio/dio.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_event.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:tw_queue/tw_queue.dart';

class MatriksService {
  final MatriksApiClient matriksApiClient;
  final ApiClient apiClient;

  MatriksService(
    this.matriksApiClient,
    this.apiClient,
  );

  Future<ApiResponse> getTopics(String url) {
    return matriksApiClient.get(
      url,
      options: Options(
        responseType: ResponseType.json,
        headers: {
          'rt': getIt<AuthBloc>().state.isLoggedIn,
        },
      ),
    );
  }

  Future<ApiResponse> getDiscovery() {
    return matriksApiClient.get(
      '${AppConfig.instance.matriksUrl}/disco-v2.json',
      options: Options(
        headers: {
          'rt': getIt<AuthBloc>().state.isLoggedIn,
        },
        extra: {'skipToken': true},
      ),
    );
  }

  Future<ApiResponse> warrantCalculate({required String symbol}) {
    return matriksApiClient.get(
      '${AppConfig.instance.matriksUrl}/dumrul/v1/warrant-calculator?symbol=$symbol',
      options: Options(
        headers: {
          'rt': getIt<AuthBloc>().state.isLoggedIn,
        },
      ),
    );
  }

  Future<ApiResponse> companyCard(
    String symbolName,
    String url,
  ) async {
    return matriksApiClient.get(
      '$url?symbol=$symbolName',
    );
  }

  Future<ApiResponse> warrantCalculateDetails({
    required String symbol,
    required String referenceDate,
    required double underlyingValue,
    required double volatility,
    required double interestRate,
  }) {
    return matriksApiClient.get(
      '${AppConfig.instance.matriksUrl}/dumrul/v1/warrant-calculator?symbol=$symbol&referenceDate=$referenceDate&underlyingValue=$underlyingValue&volatility=$volatility&interestRate=$interestRate',
      options: Options(
        headers: {
          'rt': getIt<AuthBloc>().state.isLoggedIn,
        },
      ),
    );
  }

  Future<ApiResponse> getHolidays(String url) {
    return matriksApiClient.get(
      '$url?startdate=${DateTime.now().year}-01-01',
      options: Options(
        headers: {
          'rt': getIt<AuthBloc>().state.isLoggedIn,
        },
      ),
    );
  }

  Future<ApiResponse> getNewsDetail({required String contentId}) {
    MatriksBloc matriksBloc = getIt<MatriksBloc>();
    return matriksApiClient.get(
      '${matriksBloc.state.endpoints!.rest!.news!.id!.url}?id=$contentId',
      options: Options(
        headers: {
          'rt': getIt<AuthBloc>().state.isLoggedIn,
        },
      ),
    );
  }

  Future<ApiResponse> getToken({
    String? id,
    bool isRealtime = false,
    bool isLoggedIn = false,
  }) {
    String url = '/Matriks/getjwttokenbydeviceid';
    bool authorized = false;
    Map<String, dynamic> body = {
      'isRealtime': isRealtime,
    };

    if (isLoggedIn) {
      url = '/Matriks/getjwttokenbycustomerextid';
      authorized = true;
      body['customerExtId'] = UserModel.instance.customerId;
    } else {
      body['deviceId'] = id;
    }

    return apiClient.post(
      url,
      body: body,
      tokenized: authorized,
    );
  }

  Future<String> getMatriksTokenByQueue({bool? forceDelayedToken}) async {
    return getIt<TWQueue>().add(() => getMatriksToken(forceDelayedToken));
  }

Future<String> getMatriksToken(bool? forceDelayedToken) async {
    final matriksBloc = getIt<MatriksBloc>();
    final appInfoBloc = getIt<AppInfoBloc>();
    final authBloc = getIt<AuthBloc>();
    final localStorage = getIt<LocalStorage>();

    String token = matriksBloc.state.token;
    int tokenTime = matriksBloc.state.tokenTime;
    DateTime checkTime = DateTime.fromMillisecondsSinceEpoch(tokenTime);

    bool shouldGetToken = DateTime.now().difference(checkTime).inMinutes > matriksTokenInvalidateTime;

    if (!shouldGetToken) {
      return matriksBloc.state.token;
    }

    // Kullanıcı bilgilerini oku
    String? customerId = await localStorage.readSecure(LocalKeys.loginTcCustomerNo);
    String? phoneNumber = UserModel.instance.phone;
    if (appInfoBloc.state.hasMembership['status'] == true) {
      phoneNumber = appInfoBloc.state.hasMembership['gsm'];
    }
    int lastLoginDate = localStorage.read(LocalKeys.lastLoginDate) ?? 0;
    bool isInThisMonth = DateTime.now().month == DateTime.fromMillisecondsSinceEpoch(lastLoginDate).month &&
        DateTime.now().year == DateTime.fromMillisecondsSinceEpoch(lastLoginDate).year;
  
    String id = '';
    bool isRealtime = false;
    if (forceDelayedToken == true && phoneNumber != null) {
      id = phoneNumber;
      isRealtime = false;
    } else if (authBloc.state.isLoggedIn) {
      // Login olduysa -> her zaman realtime, customerId üzerinden
      id = customerId ?? phoneNumber ?? '';
      isRealtime = true;
    } else if (customerId != null && isInThisMonth) {
      // Login değil ama müşteri, bu ay login olmuş -> realtime
      id = customerId;
      isRealtime = true;
    } else if (phoneNumber != null) {
      // Sadece üye -> delayed
      id = phoneNumber;
      isRealtime = false;
    } else {
      // Ne login, ne müşteri, ne de üye -> token alınmaz
      throw Exception("Token alınamaz: Kullanıcı login/üye/müşteri değil.");
    }

    ApiResponse response = await getIt<PPApi>().matriksService.getToken(
          id: id.trim(),
          isRealtime: isRealtime,
          isLoggedIn: authBloc.state.isLoggedIn,
        );

    if (response.success) {
      token = response.data['matriksToken'];
      matriksBloc.add(
        MatriksSetTokenEvent(
          token: token,
          tokenTime: DateTime.now().millisecondsSinceEpoch,
          isRealTime: isRealtime,
        ),
      );
    }

    return token;
  }

  void deleteMatriksTokens() {
    getIt<LocalStorage>().delete('MatriksToken');
    getIt<LocalStorage>().delete('MatriksTokenTime');
  }

  Future<ApiResponse> symbolDetailBar(
    String symbolName,
    ChartFilter filter, {
    MapEntry<String, String>? dates,
    required String derivedUrl,
    required String barUrl,
    required CurrencyEnum currencyEnum,
    bool isPerformance = false,
    String? period,
  }) async {
    String url = barUrl;

    if (filter == ChartFilter.oneWeek ||
        filter == ChartFilter.oneMonth ||
        filter == ChartFilter.threeMonth ||
        filter == ChartFilter.sixMonth ||
        filter == ChartFilter.oneYear ||
        filter == ChartFilter.threeYear ||
        filter == ChartFilter.fiveYear) {
      url = derivedUrl;
    }

    if (dates == null) {
      String startDate = DateTime.now().formatToJson();
      String endDate = DateTime.now().formatToJson();
      if (filter == ChartFilter.oneYear || filter == ChartFilter.fiveYear) {
        startDate = DateTime(1990, 01, 01).formatToJson();
      } else {
        startDate = DateTime.now().subtract(filter.duration).formatToJson();
      }
      dates = MapEntry<String, String>(startDate, endDate);
    }

    url =
        '$url?symbol=$symbolName&start=${dates.key}&end=${dates.value}&period=${period ?? (isPerformance ? filter.performancePeriod : filter.period)}';

    if (currencyEnum == CurrencyEnum.dollar) {
      url += '&divisorSymbol=USDTRY';
    }
    return getIt<PPApi>().matriksApiClient.get(url);
  }

  Future<ApiResponse> symbolDetailBarByDateRange(
    String symbolName, {
    required String barUrl,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    String url = barUrl;
    String period = '1day';

    return getIt<PPApi>().matriksApiClient.get(
          '$url?symbol=$symbolName&start=${startDate.formatToJson()}&end=${endDate.formatToJson()}&period=$period',
        );
  }

  Future balance(
    String symbolName,
    int month,
    String year,
    bool isConsolidate,
    String url,
  ) async {
    String period = year + _handleDate(month);
    String newSymbolName = symbolName;

    if (isConsolidate && !symbolName.endsWith('@C')) {
      newSymbolName = "$symbolName@C";
    }

    ApiResponse response = await getIt<PPApi>().matriksApiClient.get(
          '$url?symbols=$newSymbolName&periods=$period',
        );

    return response.data;
  }

  Future incomeStatement(
    String symbolName,
    int month,
    String year,
    bool isConsolide,
    String url,
  ) async {
    String period = year + _handleDate(month);
    String symbolName0 = symbolName;

    if (isConsolide && !symbolName.endsWith('@C')) {
      symbolName0 = '$symbolName@C';
    }

    ApiResponse response = await getIt<PPApi>().matriksApiClient.get(
          '$url?symbols=$symbolName0&periods=$period',
        );

    if (response.success) {
      return response.data;
    } else {
      return [];
    }
  }

  String _handleDate(int value) {
    if (value < 10) {
      return '0$value';
    } else {
      return '$value';
    }
  }

  // Future swapDataTop5(
  //   String date,
  //   String symbol,
  //   String url,
  // ) async {
  //   ApiResponse response = await getIt<PPApi>().matriksApiClient.get(
  //         '$url?symbol=$symbol&top=10&date=$date',
  //       );

  //   if (response.success) {
  //     return response.data;
  //   } else {
  //     return [];
  //   }
  // }

  // Future swapData(
  //   String date,
  //   String symbol,
  //   String url,
  // ) async {
  //   ApiResponse response = await getIt<PPApi>().matriksApiClient.get(
  //         '$url?symbol=$symbol&date=$date',
  //       );

  //   if (response.success) {
  //     return response.data;
  //   } else {
  //     return [];
  //   }
  // }

  Future stageAnalysis(
    String symbolName,
    String url,
  ) async {
    ApiResponse response = await getIt<PPApi>().matriksApiClient.get(
          '$url?symbol=$symbolName',
        );

    if (response.success) return response.data;

    return {};
  }
}
