class News {
  String? date;
  int? timestamp;
  List? symbol;
  List? category;
  List? source;
  String? language;
  String? dailyNewsNo;
  bool? isFlash;
  String? id;
  String? content;
  String? headline;
  News({
    required this.date,
    required this.timestamp,
    required this.symbol,
    required this.category,
    required this.source,
    required this.language,
    required this.dailyNewsNo,
    required this.isFlash,
    required this.id,
    required this.content,
    required this.headline,
  });

  factory News.fromJson(Map<String, dynamic> map) {
    return News(
      date: map['date'],
      timestamp: map['timestamp'],
      symbol: map['symbol'],
      category: map['category'],
      source: map['source'],
      language: map['language'],
      dailyNewsNo: map['dailyNewsNo'],
      isFlash: map['isFlash'],
      id: map['id'],
      content: map['content'],
      headline: map['headline'],
    );
  }
}
