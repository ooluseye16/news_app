import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/repositories/news_repository.dart';

final newsRepositoryProvider = Provider((ref) => NewsRepository(ref));

final newsProvider =
    FutureProvider<News>((ref) => ref.watch(newsRepositoryProvider).getNews());
