import 'package:miguel_news/model/Article.dart';
import 'package:miguel_news/services/NewsServices.dart';

class NewsRepository{
  List<Article> _list = [];

  Future<List<Article>> fetchNews() async {
    _list = NewsServices.getNews() as List<Article>;
    return _list;
  }
}