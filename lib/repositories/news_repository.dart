import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/api_key.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/providers/auth_provider.dart';

class NewsRepository {
  NewsRepository(this.ref);
  final Ref ref;

  CollectionReference newsRef = FirebaseFirestore.instance.collection('news');

  Future<News> getNewsFromHttp() async {
    final uri = Uri.https("newsapi.org", "/v2/everything", {"q": "a"});
    final response = await http.get(uri,
        headers: {"Authorization": apiKey});

    final news = News.fromJson(jsonDecode(response.body));
    return news;
  }

  void addNewsToStore() async {
    final userId = ref.watch(authStateProvider).value!.uid;
    final news = await getNewsFromHttp();
    newsRef.doc(userId).set(news.toJson());
  }

  Future<News> getNews() async {
    final userId = ref.watch(authStateProvider).value!.uid;

    final response = await newsRef.doc(userId).get();
    final news = News.fromJson(response.data() as Map<String, dynamic>);
    return news;
  }
}
