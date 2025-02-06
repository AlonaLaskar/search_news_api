import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'remote_news_events.dart';
import 'remote_news_state.dart';

import '../../data/models/news_model.dart';
import '../../data/data_providers/news_data_provider.dart';

class RemoteNewsBloc extends Bloc<RemoteNewsEvent, RemoteNewsState> {
  final NewsDataProvider newsRepository; // Data provider for fetching news
  int currentPage = 1; // Current page for pagination
  bool isFetching = false; 
  bool hasReachedMax =false; 

  RemoteNewsBloc({required this.newsRepository})
      : super(const RemoteNewsLoading()) {
    on<GetNews>(_onGetNews);// Event for fetching news
    on<LoadMoreNews>(_onLoadMoreNews);// Event for loading more news (pagination)
  }

  Future<void> _onGetNews(GetNews event, Emitter<RemoteNewsState> emit) async {  // Handles fetching initial news data
    emit(const RemoteNewsLoading()); // Set loading state
    currentPage = 1;
    hasReachedMax = false; 
try{
final List<News> newsList = await newsRepository.getNews(
      event.query,
      event.fromDate,
      event.toDate,
      page: currentPage,
    );

    if (newsList.isEmpty) {
      emit(const RemoteNewsEmpty());// Emit empty state if no news found
      return;
    }
    emit(RemoteNewsDone(newsList, hasReachedMax: false));// Emit news data
}catch (e) {
    emit(RemoteNewsError("Failed to fetch news: ${e.toString()}")); // Emit error state
  }
  
  }

  Future<void> _onLoadMoreNews(
      LoadMoreNews event, Emitter<RemoteNewsState> emit) async {
    if (state is RemoteNewsDone && !isFetching && !hasReachedMax) {
      final currentState = state as RemoteNewsDone;
      isFetching = true;
      currentPage++;

      try {
        final List<News> moreNews = await newsRepository.getNews(
          event.query,
          event.fromDate,
          event.toDate,
          page: currentPage,
        );

        if (moreNews.isEmpty) {
          hasReachedMax = true; 
          emit(RemoteNewsDone(currentState.news, hasReachedMax: true));
        } else {
          emit(RemoteNewsDone([...currentState.news, ...moreNews],
              hasReachedMax: false));
        }
      } on DioException {
        emit(RemoteNewsDone(currentState.news, hasReachedMax: false));
      } catch (e) {
        emit(RemoteNewsDone(currentState.news, hasReachedMax: false));
      } finally {
        isFetching = false;
      }
    }
  }
}
