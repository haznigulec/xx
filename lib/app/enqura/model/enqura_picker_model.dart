import 'package:piapiri_v2/app/enqura/model/item_list_model.dart';

class EnquraPickerModel {
  bool isVisible;
  bool isTextField;
  String label;
  List<ItemListModel> selectableItems;
  ItemListModel? listValue;
  String? textValue;
  bool? keyboaryIsNumber;
  int? minLength;
  int? maxLength;
  double? minValue;
  double? maxValue;

  EnquraPickerModel({
    this.isVisible = true,
    this.isTextField = false,
    required this.label,
    required this.selectableItems,
    this.listValue,
    this.textValue,
    this.keyboaryIsNumber,
    this.minLength,
    this.maxLength,
    this.minValue,
    this.maxValue,
  });
}
