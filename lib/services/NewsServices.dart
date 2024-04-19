import 'package:miguel_news/model/Article.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsServices {
  static const String _baseUrl2 =
      'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f2e8af535f55488bbf0d802ad152b47d';
  static const String _baseUrl =
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=f2e8af535f55488bbf0d802ad152b47d';

  static Future<List<Article>> getNews() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Article> listArticles = [];
      for (var article in jsonData['articles']) {
        listArticles.add(Article.fromJson(article));
      }

      // print(listArticles);
      return listArticles;
    } else {
      // print('Failed to load news');
      throw Exception('Failed to load news');
    }
  }

  static Future<List<Article>> getHighlightNews() async {
    final response = await http.get(Uri.parse(_baseUrl2));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Article> listArticles = [];
      for (var article in jsonData['articles']) {
        listArticles.add(Article.fromJson(article));
      }

      // print(listArticles);
      return listArticles;
    } else {
      // print('Failed to load news');
      throw Exception('Failed to load news');
    }
  }
}
