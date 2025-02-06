import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:search_news_api/data/models/news_model.dart';
import 'package:search_news_api/data/data_providers/news_data_provider.dart';
import 'package:search_news_api/logic/remote_new_bloc/remote_news_bloc.dart';
import 'package:search_news_api/logic/remote_new_bloc/remote_news_events.dart';
import 'package:search_news_api/logic/remote_new_bloc/remote_news_state.dart';

// יצירת מחלקה מדומה לרפוזיטורי
class MockNewsDataProvider extends Mock implements NewsDataProvider {}

void main() {
  late RemoteNewsBloc remoteNewsBloc;
  late MockNewsDataProvider mockNewsRepository;

  setUp(() {
    mockNewsRepository = MockNewsDataProvider();
    remoteNewsBloc = RemoteNewsBloc(newsRepository: mockNewsRepository);
    registerFallbackValue(GetNews(query: "", fromDate: "", toDate: ""));
  });

  tearDown(() {
    remoteNewsBloc.close();
  });

  final mockNewsList = [
    News(
      title: "Test News 1",
      description: "Description 1",
      url: "https://example.com",
      urlToImage: "https://example.com/image1.jpg",
      author: "Author 1",
      sourceName: "Test Source",
      publishedAt: "2024-02-06T12:00:00Z",
      content: "Sample content 1",
    ),
    News(
      title: "Test News 2",
      description: "Description 2",
      url: "https://example.com",
      urlToImage: "https://example.com/image2.jpg",
      author: "Author 2",
      sourceName: "Test Source",
      publishedAt: "2024-02-06T13:00:00Z",
      content: "Sample content 2",
    ),
  ];

  test("Initial state should be RemoteNewsLoading", () {
    expect(remoteNewsBloc.state, equals(const RemoteNewsLoading()));
  });

  blocTest<RemoteNewsBloc, RemoteNewsState>(
    "Emits [RemoteNewsLoading, RemoteNewsDone] when GetNews is added and API returns data",
    build: () {
      when(() => mockNewsRepository.getNews(any(), any(), any(), page: any(named: "page")))
          .thenAnswer((_) async => mockNewsList);
      return remoteNewsBloc;
    },
    act: (bloc) => bloc.add(const GetNews(query: "Flutter", fromDate: "2024-02-01", toDate: "2024-02-06")),
    expect: () => [
      const RemoteNewsLoading(),
      RemoteNewsDone(mockNewsList, hasReachedMax: false),
    ],
  );

  blocTest<RemoteNewsBloc, RemoteNewsState>(
    "Emits [RemoteNewsLoading, RemoteNewsEmpty] when GetNews is added and API returns empty list",
    build: () {
      when(() => mockNewsRepository.getNews(any(), any(), any(), page: any(named: "page")))
          .thenAnswer((_) async => []);
      return remoteNewsBloc;
    },
    act: (bloc) => bloc.add(const GetNews(query: "Flutter", fromDate: "2024-02-01", toDate: "2024-02-06")),
    expect: () => [
      const RemoteNewsLoading(),
      const RemoteNewsEmpty(),
    ],
  );

  blocTest<RemoteNewsBloc, RemoteNewsState>(
    "Emits [RemoteNewsLoading, RemoteNewsError] when GetNews throws an error",
    build: () {
      when(() => mockNewsRepository.getNews(any(), any(), any(), page: any(named: "page")))
          .thenThrow(Exception("API Error"));
      return remoteNewsBloc;
    },
    act: (bloc) => bloc.add(const GetNews(query: "Flutter", fromDate: "2024-02-01", toDate: "2024-02-06")),
    expect: () => [
      const RemoteNewsLoading(),
      const RemoteNewsError("Failed to fetch news: Exception: API Error"),
    ],
  );
}
