import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DropdownModel<T> extends Equatable {
  final String name;
  final T value;
  final Widget? icon;

  const DropdownModel({
    required this.name,
    required this.value,
    this.icon,
  });

  factory DropdownModel.fromJson(Map<String, dynamic> json) {
    return DropdownModel(
      name: json['name'],
      value: json['value'],
    );
  }

  @override
  List<Object?> get props => [
        name,
        value,
        icon,
      ];
}
