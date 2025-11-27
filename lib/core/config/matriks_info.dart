class MatriksInfo {
  Rest? rest;
  Mqtt? mqtt;

  MatriksInfo({this.rest, this.mqtt});

  MatriksInfo.fromJson(Map<String, dynamic> json) {
    rest = json['rest'] != null ? Rest.fromJson(json['rest']) : null;
    mqtt = json['mqtt'] != null ? Mqtt.fromJson(json['mqtt']) : null;
  }
}

class Rest {
  HistoricTick? historicTick;
  NewsInfo? news;
  MetaData? metaData;
  MetaData? metaDataV4;
  Meta? priceStep;
  Meta? priceStepV2;
  Meta? sessionHourStatic;
  GetRule? akd;
  GetRule? tpd;
  GetRule? agentAssets;
  GetRule? bar;
  GetRule? lineChart;
  GetRule? topach;
  GetRule? widget;
  GetRule? companyCards;
  GetRule? derivedBar;
  GetRule? holidays;
  Arf? arf;
  TechAnalysis? techAnalysis;
  Fundamentals? fundamentals;
  TwitterRule? twitter;
  EconomicCalendar? economicCalendar;
  WarrantCoach? warrantCoach;

  Rest({
    this.historicTick,
    this.news,
    this.metaData,
    this.metaDataV4,
    this.priceStep,
    this.priceStepV2,
    this.sessionHourStatic,
    this.akd,
    this.tpd,
    this.agentAssets,
    this.bar,
    this.lineChart,
    this.topach,
    this.widget,
    this.companyCards,
    this.derivedBar,
    this.holidays,
    this.arf,
    this.techAnalysis,
    this.fundamentals,
    this.twitter,
    this.economicCalendar,
    this.warrantCoach,
  });

  Rest.fromJson(Map<String, dynamic> json) {
    historicTick = json['historicTick'] != null ? HistoricTick.fromJson(json['historicTick']) : null;
    news = json['news'] != null ? NewsInfo.fromJson(json['news']) : null;
    metaData = json['metaData'] != null ? MetaData.fromJson(json['metaData']) : null;
    metaDataV4 = json['metaDataV4'] != null ? MetaData.fromJson(json['metaDataV4']) : null;
    priceStep = json['priceStep'] != null ? Meta.fromJson(json['priceStep']) : null;
    priceStepV2 = json['priceStepV2'] != null ? Meta.fromJson(json['priceStepV2']) : null;
    sessionHourStatic = json['sessionHourStatic'] != null ? Meta.fromJson(json['sessionHourStatic']) : null;
    akd = json['akd'] != null ? GetRule.fromJson(json['akd']) : null;
    tpd = json['tpd'] != null ? GetRule.fromJson(json['tpd']) : null;
    agentAssets = json['agentAssets'] != null ? GetRule.fromJson(json['agentAssets']) : null;
    bar = json['bar'] != null ? GetRule.fromJson(json['bar']) : null;
    lineChart = json['lineChart'] != null ? GetRule.fromJson(json['lineChart']) : null;
    topach = json['topach'] != null ? GetRule.fromJson(json['topach']) : null;
    widget = json['widget'] != null ? GetRule.fromJson(json['widget']) : null;
    companyCards = json['companyCards'] != null ? GetRule.fromJson(json['companyCards']) : null;
    derivedBar = json['derivedBar'] != null ? GetRule.fromJson(json['derivedBar']) : null;
    holidays = json['holidays'] != null ? GetRule.fromJson(json['holidays']) : null;
    arf = json['arf_v2'] != null ? Arf.fromJson(json['arf_v2']) : null;
    techAnalysis = json['techAnalysis'] != null ? TechAnalysis.fromJson(json['techAnalysis']) : null;
    fundamentals = json['fundamentals'] != null ? Fundamentals.fromJson(json['fundamentals']) : null;
    twitter = json['twitter'] != null ? TwitterRule.fromJson(json['twitter']) : null;
    economicCalendar = json['economicCalendar'] != null ? EconomicCalendar.fromJson(json['economicCalendar']) : null;
    warrantCoach = json['warrantCoach'] != null ? WarrantCoach.fromJson(json['warrantCoach']) : null;
  }
}

class TwitterRule {
  GetRule? twitter;

  TwitterRule({this.twitter});

  TwitterRule.fromJson(Map<String, dynamic> json) {
    twitter = json['twitter'] != null ? GetRule.fromJson(json['twitter']) : null;
  }
}

class GetRule {
  String? url;
  List<String>? parameters;
  bool? gzAvailable;

  GetRule({this.url, this.parameters, this.gzAvailable});

  GetRule.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    parameters = json['parameters']?.cast<String>();
    gzAvailable = json['gzAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['parameters'] = parameters;
    data['gzAvailable'] = gzAvailable;
    return data;
  }
}

class HistoricTick {
  GetRule? depth;
  GetRule? settlement;
  GetRule? totalsize;
  GetRule? trade;
  GetRule? tradebs;
  GetRule? bestbidoffer;
  GetRule? barCsv;
  GetRule? openinterest;

  HistoricTick({
    this.depth,
    this.settlement,
    this.totalsize,
    this.trade,
    this.tradebs,
    this.bestbidoffer,
    this.barCsv,
    this.openinterest,
  });

  HistoricTick.fromJson(Map<String, dynamic> json) {
    depth = json['depth'] != null ? GetRule.fromJson(json['depth']) : null;
    settlement = json['settlement'] != null ? GetRule.fromJson(json['settlement']) : null;
    totalsize = json['totalsize'] != null ? GetRule.fromJson(json['totalsize']) : null;
    trade = json['trade'] != null ? GetRule.fromJson(json['trade']) : null;
    tradebs = json['tradebs'] != null ? GetRule.fromJson(json['tradebs']) : null;
    bestbidoffer = json['bestbidoffer'] != null ? GetRule.fromJson(json['bestbidoffer']) : null;
    barCsv = json['barCsv'] != null ? GetRule.fromJson(json['barCsv']) : null;
    openinterest = json['openinterest'] != null ? GetRule.fromJson(json['openinterest']) : null;
  }
}

class NewsInfo {
  GetRule? search;
  GetRule? page;
  GetRule? id;
  GetRule? meta;

  NewsInfo({this.search, this.page, this.id, this.meta});

  NewsInfo.fromJson(Map<String, dynamic> json) {
    search = json['search'] != null ? GetRule.fromJson(json['search']) : null;
    page = json['page'] != null ? GetRule.fromJson(json['page']) : null;
    id = json['id'] != null ? GetRule.fromJson(json['id']) : null;
    meta = json['meta'] != null ? GetRule.fromJson(json['meta']) : null;
  }
}

class Meta {
  String? url;
  bool? gzAvailable;
  int? lastUpdate;

  Meta({this.url, this.gzAvailable, this.lastUpdate});

  Meta.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    gzAvailable = json['gzAvailable'];
    lastUpdate = json['lastUpdate'];
  }
}

class MetaData {
  GetRule? symbols;
  Meta? viopMarkets;
  Meta? markets;
  Meta? members;
  Meta? exchanges;
  Meta? sectors;
  GetRule? sessionHours;
  GetRule? dayCounter;

  MetaData({
    this.symbols,
    this.viopMarkets,
    this.markets,
    this.members,
    this.exchanges,
    this.sectors,
    this.sessionHours,
    this.dayCounter,
  });

  MetaData.fromJson(Map<String, dynamic> json) {
    symbols = json['symbols'] != null ? GetRule.fromJson(json['symbols']) : null;
    viopMarkets = json['viopMarkets'] != null ? Meta.fromJson(json['viopMarkets']) : null;
    markets = json['markets'] != null ? Meta.fromJson(json['markets']) : null;
    members = json['members'] != null ? Meta.fromJson(json['members']) : null;
    exchanges = json['exchanges'] != null ? Meta.fromJson(json['exchanges']) : null;
    sectors = json['sectors'] != null ? Meta.fromJson(json['sectors']) : null;
    sessionHours = json['sessionHours'] != null ? GetRule.fromJson(json['sessionHours']) : null;
    dayCounter = json['dayCounter'] != null ? GetRule.fromJson(json['dayCounter']) : null;
  }
}

class TechAnalysis {
  GetRule? pivots;
  GetRule? indPos;

  TechAnalysis({this.pivots, this.indPos});

  TechAnalysis.fromJson(Map<String, dynamic> json) {
    pivots = json['pivots'] != null ? GetRule.fromJson(json['pivots']) : null;
    indPos = json['indPos'] != null ? GetRule.fromJson(json['indPos']) : null;
  }
}

class Arf {
  GetRule? insertRule;
  GetRule? updateRule;
  GetRule? getAllRules;
  GetRule? getRule;
  GetRule? deleteRule;

  Arf({
    this.insertRule,
    this.updateRule,
    this.getAllRules,
    this.getRule,
    this.deleteRule,
  });

  Arf.fromJson(Map<String, dynamic> json) {
    insertRule = json['insertRule'] != null ? GetRule.fromJson(json['insertRule']) : null;
    updateRule = json['updateRule'] != null ? GetRule.fromJson(json['updateRule']) : null;
    getAllRules = json['getAllRules'] != null ? GetRule.fromJson(json['getAllRules']) : null;
    getRule = json['getRule'] != null ? GetRule.fromJson(json['getRule']) : null;
    deleteRule = json['deleteRule'] != null ? GetRule.fromJson(json['deleteRule']) : null;
  }
}

class Fundamentals {
  GetRule? periods;
  GetRule? bS;
  GetRule? cF;
  GetRule? iNC;
  GetRule? bSCSV;
  GetRule? cFCSV;
  GetRule? iNCCSV;

  Fundamentals({this.periods, this.bS, this.cF, this.iNC, this.bSCSV, this.cFCSV, this.iNCCSV});

  Fundamentals.fromJson(Map<String, dynamic> json) {
    periods = json['periods'] != null ? GetRule.fromJson(json['periods']) : null;
    bS = json['BS'] != null ? GetRule.fromJson(json['BS']) : null;
    cF = json['CF'] != null ? GetRule.fromJson(json['CF']) : null;
    iNC = json['INC'] != null ? GetRule.fromJson(json['INC']) : null;
    bSCSV = json['BS_CSV'] != null ? GetRule.fromJson(json['BS_CSV']) : null;
    cFCSV = json['CF_CSV'] != null ? GetRule.fromJson(json['CF_CSV']) : null;
    iNCCSV = json['INC_CSV'] != null ? GetRule.fromJson(json['INC_CSV']) : null;
  }
}

class EconomicCalendar {
  GetRule? calendar;
  GetRule? indicators;
  GetRule? country;

  EconomicCalendar({this.calendar, this.indicators, this.country});

  EconomicCalendar.fromJson(Map<String, dynamic> json) {
    calendar = json['calendar'] != null ? GetRule.fromJson(json['calendar']) : null;
    indicators = json['indicators'] != null ? GetRule.fromJson(json['indicators']) : null;
    country = json['country'] != null ? GetRule.fromJson(json['country']) : null;
  }
}

class WarrantCoach {
  GetRule? underlyings;
  GetRule? warrants;
  GetRule? issuers;

  WarrantCoach({
    this.underlyings,
    this.warrants,
    this.issuers,
  });

  WarrantCoach.fromJson(Map<String, dynamic> json) {
    underlyings = json['underlyings'] != null ? GetRule.fromJson(json['underlyings']) : GetRule();
    warrants = json['warrants'] != null ? GetRule.fromJson(json['warrants']) : GetRule();
    issuers = json['issuers'] != null ? GetRule.fromJson(json['issuers']) : GetRule();
  }
}

class Mqtt {
  MxInfo? mxNews;
  MxInfo? mxNewsComment;
  MxInfo? mxNewsKap;
  MxInfo? mxNewsAa;
  MxInfo? mxSymbol;
  MxInfo? mxDerivative;
  MxInfo? mxStatsHigh;
  MxInfo? mxStatsHighWeekly;
  MxInfo? mxStatsHighMonthly;
  MxInfo? mxStatsHighYearly;
  MxInfo? mxStatsLow;
  MxInfo? mxStatsLowWeekly;
  MxInfo? mxStatsLowMonthly;
  MxInfo? mxStatsLowYearly;
  MxInfo? mxStatsVolume;
  MxInfo? mxStatsWarrantHigh;
  MxInfo? mxStatsWarrantLow;
  MxInfo? mxStatsWarrantVolume;
  MxInfo? mxStatsDbWarrantHigh;
  MxInfo? mxStatsDbWarrantLow;
  MxInfo? mxStatsDbWarrantQuantity;
  MxInfo? mxStatsOsmWarrantHigh;
  MxInfo? mxStatsOsmWarrantLow;
  MxInfo? mxStatsOsmWarrantVolume;
  MxInfo? mxStatsFutureHigh;
  MxInfo? mxStatsFutureLow;
  MxInfo? mxStatsFutureVolume;
  MxInfo? mxStatsOptionHigh;
  MxInfo? mxStatsOptionLow;
  MxInfo? mxStatsOptionVolume;
  MxInfo? mxTrade;
  MxInfo? mxDepth;
  MxInfo? mxDepthstats;
  MxInfo? mxBooklet;
  MxInfo? mxAnalyticsOption;
  MxInfo? mxAnalyticsWarrant;
  MxInfo? mxAnalyticsDbWarrant;
  MxInfo? mxArf;
  MxInfo? mxTimestamp;
  MxInfo? mxEventPrimeSymbol;
  MxInfo? mxEventPrimeDerivative;
  MxInfo? mxEventPrimeIndex;

  Mqtt({
    this.mxNews,
    this.mxNewsComment,
    this.mxNewsKap,
    this.mxNewsAa,
    this.mxSymbol,
    this.mxDerivative,
    this.mxStatsHigh,
    this.mxStatsHighWeekly,
    this.mxStatsHighMonthly,
    this.mxStatsHighYearly,
    this.mxStatsLow,
    this.mxStatsLowWeekly,
    this.mxStatsLowMonthly,
    this.mxStatsLowYearly,
    this.mxStatsVolume,
    this.mxStatsWarrantHigh,
    this.mxStatsWarrantLow,
    this.mxStatsWarrantVolume,
    this.mxStatsDbWarrantHigh,
    this.mxStatsDbWarrantLow,
    this.mxStatsDbWarrantQuantity,
    this.mxStatsOsmWarrantHigh,
    this.mxStatsOsmWarrantLow,
    this.mxStatsOsmWarrantVolume,
    this.mxStatsFutureHigh,
    this.mxStatsFutureLow,
    this.mxStatsFutureVolume,
    this.mxStatsOptionHigh,
    this.mxStatsOptionLow,
    this.mxStatsOptionVolume,
    this.mxTrade,
    this.mxDepth,
    this.mxDepthstats,
    this.mxBooklet,
    this.mxAnalyticsOption,
    this.mxAnalyticsWarrant,
    this.mxAnalyticsDbWarrant,
    this.mxArf,
    this.mxTimestamp,
    this.mxEventPrimeSymbol,
    this.mxEventPrimeDerivative,
    this.mxEventPrimeIndex,
  });

  Mqtt.fromJson(Map<String, dynamic> json) {
    mxNews = json['mx/news'] != null ? MxInfo.fromJson(json['mx/news']) : null;
    mxNewsComment = json['mx/news@comment'] != null ? MxInfo.fromJson(json['mx/news@comment']) : null;
    mxNewsKap = json['mx/news@kap'] != null ? MxInfo.fromJson(json['mx/news@kap']) : null;
    mxNewsAa = json['mx/news@aa'] != null ? MxInfo.fromJson(json['mx/news@aa']) : null;
    mxSymbol = json['mx/symbol'] != null ? MxInfo.fromJson(json['mx/symbol']) : null;
    mxDerivative = json['mx/derivative'] != null ? MxInfo.fromJson(json['mx/derivative']) : null;
    mxStatsHigh = json['mx/stats/high'] != null ? MxInfo.fromJson(json['mx/stats/high']) : null;
    mxStatsHighWeekly = json['mx/stats/high/weekly'] != null ? MxInfo.fromJson(json['mx/stats/high/weekly']) : null;
    mxStatsHighMonthly = json['mx/stats/high/monthly'] != null ? MxInfo.fromJson(json['mx/stats/high/monthly']) : null;
    mxStatsHighYearly = json['mx/stats/high/yearly'] != null ? MxInfo.fromJson(json['mx/stats/high/yearly']) : null;
    mxStatsLow = json['mx/stats/low'] != null ? MxInfo.fromJson(json['mx/stats/low']) : null;
    mxStatsLowWeekly = json['mx/stats/low/weekly'] != null ? MxInfo.fromJson(json['mx/stats/low/weekly']) : null;
    mxStatsLowMonthly = json['mx/stats/low/monthly'] != null ? MxInfo.fromJson(json['mx/stats/low/monthly']) : null;
    mxStatsLowYearly = json['mx/stats/low/yearly'] != null ? MxInfo.fromJson(json['mx/stats/low/yearly']) : null;
    mxStatsVolume = json['mx/stats/volume'] != null ? MxInfo.fromJson(json['mx/stats/volume']) : null;
    mxStatsWarrantHigh = json['mx/stats/warrant/high'] != null ? MxInfo.fromJson(json['mx/stats/warrant/high']) : null;
    mxStatsWarrantLow = json['mx/stats/warrant/low'] != null ? MxInfo.fromJson(json['mx/stats/warrant/low']) : null;
    mxStatsWarrantVolume =
        json['mx/stats/warrant/volume'] != null ? MxInfo.fromJson(json['mx/stats/warrant/volume']) : null;
    mxStatsDbWarrantHigh =
        json['mx/stats/db/warrant/high'] != null ? MxInfo.fromJson(json['mx/stats/db/warrant/high']) : null;
    mxStatsDbWarrantLow =
        json['mx/stats/db/warrant/low'] != null ? MxInfo.fromJson(json['mx/stats/db/warrant/low']) : null;
    mxStatsDbWarrantQuantity =
        json['mx/stats/db/warrant/quantity'] != null ? MxInfo.fromJson(json['mx/stats/db/warrant/quantity']) : null;
    mxStatsOsmWarrantHigh =
        json['mx/stats/osm/warrant/high'] != null ? MxInfo.fromJson(json['mx/stats/osm/warrant/high']) : null;
    mxStatsOsmWarrantLow =
        json['mx/stats/osm/warrant/low'] != null ? MxInfo.fromJson(json['mx/stats/osm/warrant/low']) : null;
    mxStatsOsmWarrantVolume =
        json['mx/stats/osm/warrant/volume'] != null ? MxInfo.fromJson(json['mx/stats/osm/warrant/volume']) : null;
    mxStatsFutureHigh = json['mx/stats/future/high'] != null ? MxInfo.fromJson(json['mx/stats/future/high']) : null;
    mxStatsFutureLow = json['mx/stats/future/low'] != null ? MxInfo.fromJson(json['mx/stats/future/low']) : null;
    mxStatsFutureVolume =
        json['mx/stats/future/volume'] != null ? MxInfo.fromJson(json['mx/stats/future/volume']) : null;
    mxStatsOptionHigh = json['mx/stats/option/high'] != null ? MxInfo.fromJson(json['mx/stats/option/high']) : null;
    mxStatsOptionLow = json['mx/stats/option/low'] != null ? MxInfo.fromJson(json['mx/stats/option/low']) : null;
    mxStatsOptionVolume =
        json['mx/stats/option/volume'] != null ? MxInfo.fromJson(json['mx/stats/option/volume']) : null;
    mxTrade = json['mx/trade'] != null ? MxInfo.fromJson(json['mx/trade']) : null;
    mxDepth = json['mx/depth'] != null ? MxInfo.fromJson(json['mx/depth']) : null;
    mxDepthstats = json['mx/depthstats'] != null ? MxInfo.fromJson(json['mx/depthstats']) : null;
    mxBooklet = json['mx/booklet'] != null ? MxInfo.fromJson(json['mx/booklet']) : null;
    mxAnalyticsOption = json['mx/analytics/option'] != null ? MxInfo.fromJson(json['mx/analytics/option']) : null;
    mxAnalyticsWarrant = json['mx/analytics/warrant'] != null ? MxInfo.fromJson(json['mx/analytics/warrant']) : null;
    mxAnalyticsDbWarrant =
        json['mx/analytics/db/warrant'] != null ? MxInfo.fromJson(json['mx/analytics/db/warrant']) : null;
    mxArf = json['mx/arf'] != null ? MxInfo.fromJson(json['mx/arf']) : null;
    mxTimestamp = json['mx/timestamp'] != null ? MxInfo.fromJson(json['mx/timestamp']) : null;
    mxEventPrimeSymbol = json['mx/event/prime/symbol'] != null ? MxInfo.fromJson(json['mx/event/prime/symbol']) : null;
    mxEventPrimeDerivative =
        json['mx/event/prime/derivative'] != null ? MxInfo.fromJson(json['mx/event/prime/derivative']) : null;
    mxEventPrimeIndex = json['mx/event/prime/index'] != null ? MxInfo.fromJson(json['mx/event/prime/index']) : null;
  }
}

class MxInfo {
  Qos? qos;

  MxInfo({this.qos});

  MxInfo.fromJson(Map<String, dynamic> json) {
    qos = json['qos'] != null ? Qos.fromJson(json['qos']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (qos != null) {
      data['qos'] = qos!.toJson();
    }
    return data;
  }
}

class Qos {
  String? dl;
  String? rt;
  Ws? ws;
  Ws? wss;
  Ws? tcp;

  Qos({this.dl, this.rt, this.ws, this.wss, this.tcp});

  Qos.fromJson(Map<String, dynamic> json) {
    dl = json['dl'];
    rt = json['rt'];
    ws = json['ws'] != null ? Ws.fromJson(json['ws']) : null;
    wss = json['wss'] != null ? Ws.fromJson(json['wss']) : null;
    tcp = json['tcp'] != null ? Ws.fromJson(json['tcp']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dl'] = dl;
    data['rt'] = rt;
    if (ws != null) {
      data['ws'] = ws!.toJson();
    }
    if (wss != null) {
      data['wss'] = wss!.toJson();
    }
    if (tcp != null) {
      data['tcp'] = tcp!.toJson();
    }
    return data;
  }
}

class Ws {
  String? dl;
  String? rt;

  Ws({this.dl, this.rt});

  Ws.fromJson(Map<String, dynamic> json) {
    dl = json['dl'];
    rt = json['rt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dl'] = dl;
    data['rt'] = rt;

    return data;
  }
}
