import 'package:flutter_test/flutter_test.dart';

import 'package:search_news_api/data/models/news_model.dart';

void main() {
  group('News Model Test', () {
    test('News.fromJson should correctly parse JSON', () {
      final json = {
        'source': {'name': 'Famous'},
        'author': 'Alona Laskar',
        'title': 'The best Developer ever!',
        'description':
            'A special event was recorded as Alona, the leading developer, was seen in Tel Aviv.',
        'url': 'https://example.com/alonatlv',
        'urlToImage': 'https://example.com/image.jpg',
        'publishedAt': '2025-02-06T12:00:00Z',
        'content': 'The amazing Alona',
      };

      final news = News.fromJson(json);

      expect(news.sourceName, 'Famous');
      expect(news.author, 'Alona Laskar');
      expect(news.title, 'The best Developer ever!');
      expect(news.description,
          'A special event was recorded as Alona, the leading developer, was seen in Tel Aviv.');
      expect(news.url, 'https://example.com/alonatlv');
      expect(news.urlToImage, 'https://example.com/image.jpg');
      expect(news.publishedAt, '2025-02-06T12:00:00Z');
      expect(news.content, 'The amazing Alona');
    });

    test('News.fromJson should handle missing or null fields gracefully', () {
      final json = {
        'source': null,
        'author': null,
        'title': null,
        'description': null,
        'url': null,
        'urlToImage': null,
        'publishedAt': null,
        'content': null,
      };

      final news = News.fromJson(json);
      expect(news.author, 'Unknown Author');
      expect(news.title, 'No Title');
      expect(news.description, 'No Description');
      expect(news.url, '');
      expect(news.urlToImage, '');
      expect(news.publishedAt, '');
      expect(news.content, 'No content available');
    });
  });
}
