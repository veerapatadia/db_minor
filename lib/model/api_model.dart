class ApiQuoteModel {
  final int id;
  final String quote;
  final String author;

  ApiQuoteModel({
    required this.id,
    required this.quote,
    required this.author,
  });

  factory ApiQuoteModel.fromMap({required Map data}) {
    return ApiQuoteModel(
      id: data['id'],
      quote: data['quote'],
      author: data['author'],
    );
  }
}
