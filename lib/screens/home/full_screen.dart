import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/utilities/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class FullScreen extends StatelessWidget {
  const FullScreen({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              32.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new)),
                  const Text(
                    "Details",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.more_vert_outlined)
                ],
              ),
              36.height,
              Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                width: double.infinity,
                height: 250.h,
                child: article.urlToImage != null
                    ? Image.network(
                        article.urlToImage!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "https://source.unsplash.com/featured/300x201",
                        fit: BoxFit.cover,
                      ),
              ),
              12.height,
              Row(
                children: [
                  const CircleAvatar(),
                  8.width,
                  Text(
                    article.author ?? "No author",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat("MMM, d,yyyy")
                        .format(DateTime.parse(article.publishedAt)),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              16.height,
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      8.height,
                      Text(
                        article.description ?? "",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              16.height,
              12.height,
              Text(
                article.content ?? "",
                maxLines: null,
              ),
              2.height,
              InkWell(
                onTap: () {
                  _launchUrl(article.url);
                },
                child: Text(
                  article.url,
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.lightBlueAccent),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
