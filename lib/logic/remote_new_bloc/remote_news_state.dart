import 'package:equatable/equatable.dart';

import '../../data/models/news_model.dart';

abstract class RemoteNewsState extends Equatable {
  const RemoteNewsState();

  @override
  List<Object?> get props => [];
}

class RemoteNewsLoading extends RemoteNewsState {// State when news data is being fetched (loading state)
  const RemoteNewsLoading();
}

class RemoteNewsDone extends RemoteNewsState {// State when news fetching is successful
  final List<News> news;
  final bool hasReachedMax; 

  const RemoteNewsDone(this.news, {this.hasReachedMax = false});

  @override
  List<Object?> get props => [news, hasReachedMax];
}

class RemoteNewsEmpty extends RemoteNewsState {// State when no news results are found

  const RemoteNewsEmpty();
}

class RemoteNewsError extends RemoteNewsState {// State when an error occurs while fetching news

  final String message;

  const RemoteNewsError(this.message);

  @override
  List<Object> get props => [message];
}
