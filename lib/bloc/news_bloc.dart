import 'dart:async';
import 'package:miguel_news/bloc/news_events.dart';
import 'package:miguel_news/bloc/news_states.dart';
import 'package:miguel_news/model/Article.dart';
import 'package:miguel_news/repository.dart';
import 'package:miguel_news/services/NewsServices.dart';

class NewsBloc {
  // Repository
  final repository = NewsRepository();

  // news controllers for input and output
  final StreamController<NewsEvent> _inputNewsController =
      StreamController<NewsEvent>();
  final StreamController<NewsState> _outputNewsController =
      StreamController<NewsState>();

  // highlight news controllers for input and output
  final StreamController<NewsEvent> _inputHighlightNewsController =
      StreamController<NewsEvent>();
  final StreamController<NewsState> _outputHighlightNewsController =
      StreamController<NewsState>();

  // getters for news
  Sink<NewsEvent> get inputNews => _inputNewsController.sink;
  Stream<NewsState> get outputNews => _outputNewsController.stream;

  // getters for highlights news
  Sink<NewsEvent> get inputHighlightNews => _inputHighlightNewsController.sink;
  Stream<NewsState> get outputHighlightNews =>
      _outputHighlightNewsController.stream;

  NewsBloc() {
    _inputNewsController.stream.listen(_mapEventToState);
    _inputHighlightNewsController.stream.listen(_mapHighlightEventToState);
  }

  void _mapEventToState(NewsEvent event) async {
    List<Article> articlesList = [];

    // loading state
    _outputNewsController.add(NewsLoadingState());

    if (event is LoadNews) {
      try {
        // Fetch news and wait for the result
        articlesList = await NewsServices.getNews();
        // loaded state
        _outputNewsController.add(NewsLoadedState(list: articlesList));
      } catch (e) {
        // Error state
        _outputNewsController
            .add(NewsErrorState(error: Exception(e.toString())));
      }
    }
  }

  void _mapHighlightEventToState(NewsEvent event) async {
    List<Article> articlesList = [];

    _outputHighlightNewsController.add(NewsLoadingState());

    if (event is LoadHighlightNews) {
      try {
        // Fetch news and wait for the result
        articlesList = await NewsServices.getHighlightNews();
        // loaded state
        _outputHighlightNewsController.add(NewsLoadedState(list: articlesList));
      } catch (e) {
        // Error state
        _outputHighlightNewsController
            .add(NewsErrorState(error: Exception(e.toString())));
      }
    }
  }
}
