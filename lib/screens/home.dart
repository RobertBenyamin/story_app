import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../data/model/story.dart';
import '../utils/result_state.dart';
import '../widgets/card_story.dart';
import '../provider/auth_provider.dart';
import '../provider/list_provider.dart';
import '../widgets/flag_icon_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context
        .read<StoryListProvider>()
        .fetchStoryList(context.read<AuthProvider>().token);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Story',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF37465D),
          foregroundColor: Colors.white,
          actions: [
            const FlagIconWidget(),
            IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFFef4444)),
              onPressed: () {
                context.read<AuthProvider>().logout();
              },
            ),
          ],
        ),
        body: Consumer<StoryListProvider>(
          builder: (context, provider, _) {
            if (provider.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.state == ResultState.hasData) {
              return ListStoryWidget(storyList: provider.storyList.listStory);
            } else if (provider.state == ResultState.error) {
              return Center(child: Text(provider.message));
            } else {
              return const Center(child: Text(''));
            }
          },
        ),
        floatingActionButton: SizedBox(
          width: 75,
          height: 75,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                context.goNamed('add_story');
              },
              backgroundColor: const Color(0xFF37465D),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListStoryWidget extends StatelessWidget {
  final List<Story> storyList;
  const ListStoryWidget({
    super.key,
    required this.storyList,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Welcome, ${context.read<AuthProvider>().userName}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: storyList.length,
              itemBuilder: (context, index) {
                final story = storyList[index];
                return InkWell(
                  child: CardStory(story: story),
                  onTap: () {
                    context.go('/stories/${story.id}');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
