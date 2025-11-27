import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';

class ModelPortfolioModel {
  final String title;
  final String detail;
  final bool isModelPorfolio;
  final String iconFile;
  final List<QuickPortfolioAssetModel> items;

  ModelPortfolioModel({
    required this.title,
    required this.detail,
    required this.isModelPorfolio,
    required this.iconFile,
    required this.items,
  });

  factory ModelPortfolioModel.fromJson(Map<String, dynamic> json) {
    return ModelPortfolioModel(
      title: json['title'],
      detail: json['detail'],
      isModelPorfolio: json['isModelPorfolio'] == true,
      iconFile: json['iconFile'] ?? '',
      items: List<QuickPortfolioAssetModel>.from(
        json['items'].map(
          (x) => QuickPortfolioAssetModel.fromJson(x),
        ),
      ),
    );
  }
}
