import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../model/api_model.dart';

class ApiHelper {
  ApiHelper._();

  static ApiHelper apiHelper = ApiHelper._();

  // fetch api
  fetchAPI() async {
    String URL = "https://dummyjson.com/quotes/";
    http.Response response = await http.get(Uri.parse(URL));

    if (response.statusCode == 200) {
      Map decodedData = jsonDecode(response.body);
      List quotes = decodedData['quotes'];
      List mainData = quotes
          .map(
            (e) => ApiQuoteModel.fromMap(data: e),
          )
          .toList();

      return mainData;
    }
  }

  // random quote
  fetchRandomQuote() async {
    String URL = "https://dummyjson.com/quotes/random";
    http.Response response = await http.get(Uri.parse(URL));

    if (response.statusCode == 200) {
      Map decodedData = jsonDecode(response.body);
      log(decodedData.toString());
      ApiQuoteModel randomQuote = ApiQuoteModel.fromMap(
        data: decodedData,
      );
      return randomQuote;
    }
  }
}
