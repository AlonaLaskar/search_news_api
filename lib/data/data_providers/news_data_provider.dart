import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/news_model.dart';

class NewsDataProvider {
  final Dio dio;
  final String apiKey = dotenv.env['NEWS_API_KEY']!;// API key loaded from .env file

  NewsDataProvider({Dio? dio}) : dio = dio ?? Dio();

  // Fetches news articles based on search query and date range
  Future<List<News>> getNews(String query, String fromDate, String toDate,
      {int page = 1}) async {
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'q': query,
          'from': fromDate,
          'to': toDate,
          'apiKey': apiKey,
          'pageSize': 10,
          'page': page,// Pagination
        },
      );

         // Check if "articles" key exists and is a list
    if (response.data == null || response.data['articles'] == null || response.data['articles'] is! List) {
      return [];
    }

      return (response.data['articles'] as List)// Convert JSON response to a list of News objects
          .map((json) => News.fromJson(json))
          .toList();
    } on DioException {
      return [];
    }
  }
}
