import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/providers/user_provider.dart';
import 'package:news_app/screens/home/full_screen.dart';
import 'package:news_app/utilities/extensions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void didChangeDependencies() {
    ref.read(newsRepositoryProvider).addNewsToStore();
    super.didChangeDependencies();
  }

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final newsData = ref.watch(newsProvider);
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          32.height,
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiY_BBq9EJopJ7s6xGctOMFLvDhY7LPCIesM18ezaj&s",
                  fit: BoxFit.cover,
                ),
              ),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome, ${userData.whenData((value) => value.name).value ?? ""}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  4.height,
                  Text(
                    DateFormat("EEEEE, MMMM, d").format(DateTime.now()),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
          27.height,
          TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {});
            },
            onTapOutside: ((event) {
              FocusManager.instance.primaryFocus?.unfocus();
            }),
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
                filled: true,
                isDense: true,
                hintText: "Search for an article...",
                suffixIcon: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: 30,
                    )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8))),
          ),
          20.height,
          Expanded(
            child: newsData.when(
                data: (data) {
                  final articles = data.articles
                      .where((element) =>
                          ("${element.title} ${element.description} ${element.content}")
                              .contains(searchController.text))
                      .toList();

                  return SingleChildScrollView(
                    child: Column(
                      children: List.generate(articles.length, (index) {
                        int random = Random().nextInt(3);
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreen(article: articles[index])));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 2, blurStyle: BlurStyle.inner)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 200.w,
                                    width: double.infinity,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: articles[index].urlToImage != null
                                        ? Image.network(
                                            articles[index].urlToImage!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            "https://source.unsplash.com/featured/300x20$random",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  16.height,
                                  Text(
                                    articles[index].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  8.height,
                                  Row(
                                    children: [
                                      const CircleAvatar(),
                                      8.width,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            articles[index].author ??
                                                "No author",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          4.height,
                                          Text(
                                            DateFormat("MMM, d,yyyy").format(
                                                DateTime.parse(articles[index]
                                                    .publishedAt)),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ]),
                          ),
                        );
                      }),
                    ),
                  );
                },
                error: (e, s) => Text(e.toString()),
                loading: () {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }),
          )
        ],
      ),
    )));
  }
}
