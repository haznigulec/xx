class USTimeModel {
  final String? timestamp;
  final String? nextOpen;
  final String? nextClose;
  final bool isOpen;

  USTimeModel({
    this.timestamp,
    this.nextOpen,
    this.nextClose,
    this.isOpen = false,
  });

  factory USTimeModel.fromJson(Map<String, dynamic> json) {
    return USTimeModel(
        timestamp: json['timestamp'] ?? DateTime.now().toString(),
        nextOpen: json['next_open'] ?? DateTime.now().toString(),
        nextClose: json['next_close'] ?? DateTime.now().toString(),
        isOpen: json['is_open'] ?? false);
  }
}
