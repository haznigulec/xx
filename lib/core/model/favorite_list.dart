import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/model/symbol_soruce_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

FavoriteList favoriteListFromJson(String str) => FavoriteList.fromJson(json.decode(str));

String favoriteListToJson(FavoriteList data) => json.encode(data.toJson());

class FavoriteList {
  int id;
  String name;
  FavoriteSortingEnum sortingEnum;
  List<FavoriteListItem> favoriteListItems;

  FavoriteList({
    required this.id,
    required this.name,
    required this.sortingEnum,
    required this.favoriteListItems,
  });

  factory FavoriteList.fromJson(Map<String, dynamic> json) => FavoriteList(
        id: json['id'],
        name: json['name'],
        sortingEnum:
            FavoriteSortingEnum.values.firstWhereOrNull((element) => element.value == json['sort']) ??
            FavoriteSortingEnum.alphabetic,
        favoriteListItems: json['items'].isNotEmpty
            ? List<FavoriteListItem>.from(json['items'].map((x) => FavoriteListItem.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sort': sortingEnum.value,
        'favoriteListItems': List<dynamic>.from(favoriteListItems.map((x) => x.toJson())),
      };
}

class FavoriteListItem {
  String symbol;
  String description;
  String underlyingName;
  SymbolTypes symbolType;
  SymbolSourceEnum symbolSource;

  FavoriteListItem({
    required this.symbol,
    this.description = '',
    this.underlyingName = '',
    required this.symbolType,
    required this.symbolSource,
  });

  factory FavoriteListItem.fromJson(Map<String, dynamic> json) => FavoriteListItem(
        symbol: json['symbol'],
        symbolType: SymbolTypes.values.firstWhere((element) => element.dbKey == json['symbolType']),
        symbolSource: SymbolSourceEnum.values.firstWhere((element) => element.value == json['symbolSource']),
      );

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'symbolType': symbolType.dbKey,
        'symbolSource': symbolSource.value,
      };
}
