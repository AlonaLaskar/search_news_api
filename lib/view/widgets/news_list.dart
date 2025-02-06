import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/news_model.dart';
import '../../logic/remote_new_bloc/remote_news_bloc.dart';
import '../../logic/remote_new_bloc/remote_news_state.dart';
import '../web_view_screen.dart';
import 'news_card.dart';

class NewsList extends StatelessWidget {
  final VoidCallback onRetry;// Callback function for retrying the request

  const NewsList({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<RemoteNewsBloc, RemoteNewsState>(
        builder: (context, state) {
          if (state is RemoteNewsLoading) {
            return const Center(child: CircularProgressIndicator());// Show loading spiner while fetching news

          } else if (state is RemoteNewsDone) {
            return Column(
              spacing: 16,
              children: [...state.news, null].map((News? news) {
                if (news == null) {
                  return state.hasReachedMax // Show either a message if there are no more articles or a loading indicator
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              "✅ No more articles available.",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : const Center(
                          child:
                              CircularProgressIndicator()); 
                }

                return NewsCard(
                  title: news.title,
                  description: news.description,
                  imageUrl: news.urlToImage,
                  author: news.author,
                  onTap: () {
                    if (news.url != null) {
                      Navigator.push( // Navigate to WebView screen when tapping a news card
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(url: news.url!),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            );
          }
          if (state is RemoteNewsEmpty) {
            return const Center(child: Text("No results found."));// Show message when no results are found
          }
          if (state is RemoteNewsError) {   // Show error message and retry button
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(state.message, textAlign: TextAlign.center),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          {
            return const Center(child: Text('Unexpected error occurred.'));
          }
        },
      ),
    );
  }
}
