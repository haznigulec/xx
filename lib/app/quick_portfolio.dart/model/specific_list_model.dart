import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/language_enum.dart';

class SpecificListModel {
  int id;
  bool isActive;
  String mainGroup;
  String tab;
  String listName;
  String description;
  List<String> symbolNames;
  int orderNo;
  String image;
  String? symbolType;

  SpecificListModel(
      {required this.id,
      required this.isActive,
      required this.mainGroup,
      required this.tab,
      required this.listName,
      required this.description,
      required this.symbolNames,
      required this.orderNo,
      required this.image,
      this.symbolType});

  factory SpecificListModel.fromJson(Map<String, dynamic> json) => SpecificListModel(
        id: json['id'] ?? 0,
        isActive: json['isActive'] ?? false,
        mainGroup: json['mainGroup'] ?? '',
        tab: json['tab'] ?? '',
        listName: getIt<LanguageBloc>().state.languageCode == LanguageEnum.turkish.value
            ? json['listName'] ?? ''
            : json['listNameEn'] ?? '',
        description: getIt<LanguageBloc>().state.languageCode == LanguageEnum.turkish.value
            ? json['description'] ?? ''
            : json['descriptionEn'] ?? '',
        symbolNames: json['symbolNames'] != null ? List<String>.from(json['symbolNames'].map((x) => x)) : [],
        orderNo: json['orderNo'] ?? 0,
        image: json['image'] ?? '',
        symbolType: json['symbolType'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'isActive': isActive,
        'mainGroup': mainGroup,
        'tab': tab,
        'listName': listName,
        'description': description,
        'symbolNames': List<dynamic>.from(symbolNames.map((x) => x)),
        'orderNo': orderNo,
        'image': image,
        'symbolType': symbolType,
      };
}
