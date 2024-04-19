import 'package:miguel_news/model/Article.dart';
// states
class NewsState {
  final List<Article> articles;
  NewsState({required this.articles});
}
// initial state
class NewsInitialState extends NewsState {
  NewsInitialState() : super(articles: []);
}
// loading state
class NewsLoadingState extends NewsState {
  NewsLoadingState() : super(articles: []);
}
// loaded state
class NewsLoadedState extends NewsState {
  NewsLoadedState({required List<Article> list}) : super(articles: list);
}
// error state
class NewsErrorState extends NewsState {
  final Exception error;
  NewsErrorState({required this.error}) : super(articles: []);
}
