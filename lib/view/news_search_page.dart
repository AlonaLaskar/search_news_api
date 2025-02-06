import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../logic/remote_new_bloc/remote_news_bloc.dart';
import '../logic/remote_new_bloc/remote_news_events.dart';

import 'widgets/date_range_picker.dart';
import 'widgets/news_list.dart';
import 'widgets/search_bar.dart';

class NewsSearchScreen extends StatefulWidget {
  const NewsSearchScreen({super.key});

  @override
  State<NewsSearchScreen> createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  // Fetch news based on search query and date range
  void _fetchNews() {
    context.read<RemoteNewsBloc>().add(
          GetNews(
            query: _searchController.text.isEmpty
                ? "technology"
                : _searchController.text,
            fromDate: _dateFormat.format(_fromDate),
            toDate: _dateFormat.format(_toDate),
          ),
        );
  }

//  date picker and update selected date range
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = isFromDate ? _fromDate : _toDate;
    DateTime firstDate = isFromDate ? DateTime(2000) : _fromDate;
    DateTime lastDate = DateTime.now();

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
//Updates the selected date range while ensuring the start date is not later than the end date.
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          if (picked.isAfter(_toDate)) {
            _fromDate = picked;
            _toDate = picked;
          } else {
            _fromDate = picked;
          }
        } else {
          _toDate = picked;
        }
      });
    }
  }
// Load more news when scrolled near bottom
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {//When reaching 100 PX before the bottom
      context.read<RemoteNewsBloc>().add(
            LoadMoreNews(
              query: _searchController.text.isEmpty
                  ? "technology"
                  : _searchController.text,
              fromDate: _dateFormat.format(_fromDate),
              toDate: _dateFormat.format(_toDate),
            ),
          );
    }
  }

  @override
  
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _fetchNews();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Search')),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  SizedBox(height: 8),
                 
                  SearchBarWidget( /// Search bar for entering news queries
                    controller: _searchController,
                    onSearch: _fetchNews,
                  ),

                  const SizedBox(height: 10),

                  DateRangePicker( // Date range picker for filtering news
                    fromDate: _fromDate,
                    toDate: _toDate,
                    selectDate: (isFromDate) =>
                        _selectDate(context, isFromDate),
                  ),

                  const SizedBox(height: 10),
                  
                  ElevatedButton(
                    onPressed: _fetchNews,
                    child: const Text('Search with Dates'),
                  ),
                  
                ],
              ),
            ),
            NewsList(onRetry: _fetchNews,),  // Display list of news articles
          ],
        ),
      ),
    );
  }
}
