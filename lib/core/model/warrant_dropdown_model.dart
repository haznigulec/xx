import 'package:equatable/equatable.dart';

class WarrantDropdownModel extends Equatable {
  final String name;
  final String key;

  const WarrantDropdownModel({
    required this.name,
    required this.key,
  });

  @override
  List<Object?> get props => [
        name,
        key,
      ];
}
