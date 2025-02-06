import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'view/news_search_page.dart';
import 'logic/remote_new_bloc/remote_news_bloc.dart';
import 'data/data_providers/news_data_provider.dart';


Future main() async {
  await dotenv.load(fileName: "assets/.env"); // Load the api key from .env file
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RemoteNewsBloc(newsRepository: NewsDataProvider()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News Search App',
        theme: ThemeData.dark(),
        home: const NewsSearchScreen(),
      ),
    );
  }
}
