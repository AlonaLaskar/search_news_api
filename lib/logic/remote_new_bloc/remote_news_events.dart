abstract class RemoteNewsEvent {
  const RemoteNewsEvent();
}

class GetNews extends RemoteNewsEvent {
  final String query;
  final String fromDate;
  final String toDate;

  const GetNews({
    required this.query,
    required this.fromDate,
    required this.toDate,
  });
}

class LoadMoreNews extends RemoteNewsEvent {
  final String query;
  final String fromDate;
  final String toDate;

  const LoadMoreNews({
    required this.query,
    required this.fromDate,
    required this.toDate,
  });
}
