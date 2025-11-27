class TaxDetailModel {
  final List<TaxDetails>? taxDetails;
  final double? totalPrice;
  final String? token;

  TaxDetailModel({
    required this.taxDetails,
    required this.totalPrice,
    required this.token,
  });

  factory TaxDetailModel.fromJson(Map<String, dynamic> json) {
    return TaxDetailModel(
      taxDetails: json['taxDetails']
          .map<TaxDetails>(
            (e) => TaxDetails.fromJson(e),
          )
          .toList(),
      totalPrice: double.tryParse(
        json['totalPrice'].toString(),
      ),
      token: json['token'],
    );
  }
}

class TaxDetails {
  final String? finType;
  final List<TaxDetailsInner>? taxDetails;
  final double? totalPrice;

  TaxDetails({
    required this.finType,
    required this.taxDetails,
    required this.totalPrice,
  });

  factory TaxDetails.fromJson(Map<String, dynamic> json) {
    return TaxDetails(
      finType: json['finType'],
      taxDetails: json['taxDetails']
          .map<TaxDetailsInner>(
            (e) => TaxDetailsInner.fromJson(e),
          )
          .toList(),
      totalPrice: json['totalPrice'],
    );
  }
}

class TaxDetailsInner {
  final String? symbol;
  final String? finType;
  final double? price;

  TaxDetailsInner({
    required this.symbol,
    required this.finType,
    required this.price,
  });

  factory TaxDetailsInner.fromJson(Map<String, dynamic> json) {
    return TaxDetailsInner(
      symbol: json['symbol'],
      finType: json['finType'],
      price: json['price'],
    );
  }
}
