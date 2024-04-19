import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miguel_news/article_news.dart';
import 'package:miguel_news/bloc/news_bloc.dart';
import 'package:miguel_news/bloc/news_events.dart';
import 'package:miguel_news/bloc/news_states.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsHomePage> {
  String g =
      "https://i.pinimg.com/564x/8d/f8/48/8df848551eb3effb0ad7bf351eac292d.jpg";

  late final NewsBloc _newsBloc;

  @override
  void initState() {
    super.initState();
    _newsBloc = NewsBloc();
    _newsBloc.inputNews.add(LoadNews());
    _newsBloc.inputHighlightNews.add(LoadHighlightNews());
  }

  String processTitleLength(String title) {
    if (title.length > 40) {
      title = "${title.substring(0, 45)}...";
    }

    return title;
  }

  String processTitleLength2(String title) {
    if (title.length > 20) {
      title = "${title.substring(0, 19)}...";
    }

    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Miguel News",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
              )),
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: [
                textHeadlineNews("Highlight"),
                _buildHighlightListView(),
                textHeadlineNews("Today"),
                _buildNewsListView()
              ],
            )),
          ),
        ],
      ),
    ));
  }

  StreamBuilder<NewsState> _buildNewsListView() {
    return StreamBuilder<NewsState>(
        // output news
        stream: _newsBloc.outputNews,
        builder: (context, state) {
          if (state is NewsLoadingState) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.black));
          } else if (state.data is NewsLoadedState) {
            final list = state.data?.articles ?? [];
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadNews(
                            title: list[index].title,
                            content: list[index].content,
                            imageUrl: list[index].imageUrl,
                          ),
                        ),
                      );
                    },
                    child: buildNewsItem(
                        list[index].imageUrl,
                        list[index].title,
                        list[index].author,
                        list[index].publishedAt),
                  );
                });
          } else {
            return const Center(child: Text("No data"));
          }
        });
  }

  SizedBox _buildHighlightListView() {
    return SizedBox(
      height: 230.0,
      child: StreamBuilder<NewsState>(
          // outpit highlight news
          stream: _newsBloc.outputHighlightNews,
          builder: (context, state) {
            if (state is NewsLoadingState) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.black));
            } else if (state.data is NewsLoadedState) {
              final list = state.data?.articles ?? [];
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 6, // show only 6 headlines
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadNews(
                              title: list[index].title,
                              content: list[index].content,
                              imageUrl: list[index].imageUrl,
                            ),
                          ),
                        );
                      },
                      child: buildNewsTopic(list[index].author,
                          list[index].title, list[index].imageUrl),
                    );
                  });
            } else {
              return const Center(child: Text("No data"));
            }
          }),
    );
  }

  Align textHeadlineNews(String textTopic) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(textTopic,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 29,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget buildNewsTopic(
      String newsAuthor, String newsTitle, String newsImageURL) {
    return Stack(
      children: [
        Card(
          elevation: 2.0,
          child: Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            height: 200.0,
            width: 280.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: newsImageURL == ""
                      ? CachedNetworkImageProvider(g)
                      : CachedNetworkImageProvider(newsImageURL),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned(
          bottom: 30.0,
          left: 10.0,
          right: 0.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black.withOpacity(0.5),
            child: Text(processTitleLength(newsTitle),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        Positioned(
          top: 13.0,
          left: 10.0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.only(left: 1, right: 2),
              child: Text(
                processTitleLength2(newsAuthor),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildNewsItem(
      String imageUrl, String title, String author, String publishedAt) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: Container(
                height: 100,
                width: 90,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageUrl == ""
                          ? CachedNetworkImageProvider(g)
                          : CachedNetworkImageProvider(imageUrl),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    processTitleLength(title),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 1, right: 2),
                    child: Text(
                      processTitleLength2(author),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  publishedAt,
                  style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
