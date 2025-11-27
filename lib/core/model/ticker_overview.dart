class TickerOverview {
  final bool? active;
  final Address? address;
  final Branding? branding;
  final String? cik;
  final String? compositeFigi;
  final String? currencyName;
  final String? description;
  final String? homepageUrl;
  final String? listDate;
  final String? locale;
  final String? market;
  final num? marketCap;
  final String? name;
  final String? phoneNumber;
  final String? primaryExchange;
  final int? roundLot;
  final String? shareClassFigi;
  final int? shareClassSharesOutstanding;
  final String? sicCode;
  final String? sicDescription;
  final String ticker;
  final String? tickerRoot;
  final int? totalEmployees;
  final String? type;
  final int? weightedSharesOutstanding;

  TickerOverview({
    this.active,
    this.address,
    this.branding,
    this.cik,
    this.compositeFigi,
    this.currencyName,
    this.description,
    this.homepageUrl,
    this.listDate,
    this.locale,
    this.market,
    this.marketCap,
    this.name,
    this.phoneNumber,
    this.primaryExchange,
    this.roundLot,
    this.shareClassFigi,
    this.shareClassSharesOutstanding,
    this.sicCode,
    this.sicDescription,
    required this.ticker,
    this.tickerRoot,
    this.totalEmployees,
    this.type,
    this.weightedSharesOutstanding,
  });

  factory TickerOverview.fromJson(Map<String, dynamic> json) {
    return TickerOverview(
      active: json['active'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      branding: json['branding'] != null ? Branding.fromJson(json['branding']) : null,
      cik: json['cik'],
      compositeFigi: json['composite_figi'],
      currencyName: json['currency_name'],
      description: json['description'],
      homepageUrl: json['homepage_url'],
      listDate: json['list_date'],
      locale: json['locale'],
      market: json['market'],
      marketCap: json['market_cap'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      primaryExchange: json['primary_exchange'],
      roundLot: json['round_lot'],
      shareClassFigi: json['share_class_figi'],
      shareClassSharesOutstanding: json['share_class_shares_outstanding'],
      sicCode: json['sic_code'],
      sicDescription: json['sic_description'],
      ticker: json['ticker'],
      tickerRoot: json['ticker_root'],
      totalEmployees: json['total_employees'],
      type: json['type'],
      weightedSharesOutstanding: json['weighted_shares_outstanding'],
    );
  }

  TickerOverview copyWith({
    bool? active,
    Address? address,
    Branding? branding,
    String? cik,
    String? compositeFigi,
    String? currencyName,
    String? description,
    String? homepageUrl,
    String? listDate,
    String? locale,
    String? market,
    num? marketCap,
    String? name,
    String? phoneNumber,
    String? primaryExchange,
    int? roundLot,
    String? shareClassFigi,
    int? shareClassSharesOutstanding,
    String? sicCode,
    String? sicDescription,
    String? ticker,
    String? tickerRoot,
    int? totalEmployees,
    String? type,
    int? weightedSharesOutstanding,
  }) {
    return TickerOverview(
      active: active ?? this.active,
      address: address ?? this.address,
      branding: branding ?? this.branding,
      cik: cik ?? this.cik,
      compositeFigi: compositeFigi ?? this.compositeFigi,
      currencyName: currencyName ?? this.currencyName,
      description: description ?? this.description,
      homepageUrl: homepageUrl ?? this.homepageUrl,
      listDate: listDate ?? this.listDate,
      locale: locale ?? this.locale,
      market: market ?? this.market,
      marketCap: marketCap ?? this.marketCap,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      primaryExchange: primaryExchange ?? this.primaryExchange,
      roundLot: roundLot ?? this.roundLot,
      shareClassFigi: shareClassFigi ?? this.shareClassFigi,
      shareClassSharesOutstanding: shareClassSharesOutstanding ?? this.shareClassSharesOutstanding,
      sicCode: sicCode ?? this.sicCode,
      sicDescription: sicDescription ?? this.sicDescription,
      ticker: ticker ?? this.ticker,
      tickerRoot: tickerRoot ?? this.tickerRoot,
      totalEmployees: totalEmployees ?? this.totalEmployees,
      type: type ?? this.type,
      weightedSharesOutstanding: weightedSharesOutstanding ?? this.weightedSharesOutstanding,
    );
  }
}

class Address {
  final String? address1;
  final String? city;
  final String? postalCode;
  final String? state;

  Address({this.address1, this.city, this.postalCode, this.state});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address1: json['address1'],
      city: json['city'],
      postalCode: json['postal_code'],
      state: json['state'],
    );
  }
}

class Branding {
  final String? iconUrl;
  final String? logoUrl;

  Branding({this.iconUrl, this.logoUrl});

  factory Branding.fromJson(Map<String, dynamic> json) {
    return Branding(
      iconUrl: json['icon_url'],
      logoUrl: json['logo_url'],
    );
  }
}
