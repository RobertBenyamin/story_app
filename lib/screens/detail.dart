import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_time_ago/get_time_ago.dart';

import '../common.dart';
import '../data/model/story.dart';
import '../utils/result_state.dart';
import '../provider/auth_provider.dart';
import '../provider/detail_provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id});

  final String id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<StoryDetailProvider>()
          .fetchStoryDetail(context.read<AuthProvider>().token, widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.detailAppBar,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF37465D),
          foregroundColor: Colors.white,
        ),
        body: Consumer<StoryDetailProvider>(
          builder: (context, provider, _) {
            if (provider.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.state == ResultState.hasData) {
              return StoryDetailWidget(story: provider.storyDetail.story);
            } else if (provider.state == ResultState.error) {
              return Center(child: Text(provider.message));
            } else {
              return const Center(child: Text(''));
            }
          },
        ),
      ),
    );
  }
}

class StoryDetailWidget extends StatelessWidget {
  final Story story;
  const StoryDetailWidget({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: story.id,
            child: Image.network(
              story.photoUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: story.name,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: '\t\t${story.description}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  GetTimeAgo.parse(story.createdAt),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
