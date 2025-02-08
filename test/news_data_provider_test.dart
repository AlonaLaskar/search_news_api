import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

import 'package:search_news_api/data/data_providers/news_data_provider.dart';
import 'package:search_news_api/data/models/news_model.dart';


class MockDio extends Mock implements Dio {}

void main()async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  late NewsDataProvider newsDataProvider;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    newsDataProvider = NewsDataProvider(dio: mockDio);
  });

  test("Should return a list of News when API call is successful", () async {
    final mockResponse = {
      "articles": [
        {
          "title": "Alona Laskars Latest Tech Insights",
          "description": "It's not easy being a junior. You have to do assignments for all kinds of companies, but in the end it will pay off and you will get the job.",
          "url": "https://example.com",
          "urlToImage": "https://example.com/image1.jpg",
          "author": "Alona Laskar",
          "source": {"name": "Test Source"},
          "publishedAt": "2024-02-06T12:00:00Z",
          "content": "Alona Laskar is Amazing",
        }
      ]
    };

    when(() => mockDio.get(any(), queryParameters: any(named: "queryParameters")))
        .thenAnswer((_) async => Response(
              data: mockResponse,
              statusCode: 200,
              requestOptions: RequestOptions(path: ''),
            ));

    final result = await newsDataProvider.getNews("Flutter", "2024-02-01", "2024-02-06");

    expect(result, isA<List<News>>());
    expect(result.length, 1);
    expect(result.first.title, "Alona Laskars Latest Tech Insights");
  });

  test("Should return an empty list when API call returns an error", () async {
    when(() => mockDio.get(any(), queryParameters: any(named: "queryParameters")))
        .thenThrow(DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionTimeout));

    final result = await newsDataProvider.getNews("Flutter", "2024-02-01", "2024-02-06");

    expect(result, isEmpty);
  });

  test("Should return an empty list when there is no internet connection", () async {
    when(() => mockDio.get(any(), queryParameters: any(named: "queryParameters")))
        .thenThrow(DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionError));

    final result = await newsDataProvider.getNews("Flutter", "2024-02-01", "2024-02-06");

    expect(result, isEmpty);
  });

  test("Should return an empty list when API returns unexpected response format", () async {
    final mockResponse = {"invalid_key": []};
    
    when(() => mockDio.get(any(), queryParameters: any(named: "queryParameters")))
        .thenAnswer((_) async => Response(
              data: mockResponse,
              statusCode: 200,
              requestOptions: RequestOptions(path: ''),
            ));

    final result = await newsDataProvider.getNews("Flutter", "2024-02-01", "2024-02-06");

    expect(result, isEmpty);
  });
}

