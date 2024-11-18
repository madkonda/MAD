import 'package:flutter/material.dart';
import 'drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> boards = [
    {"title": "Games", "image": "assets/games.png", "argument": "Games"},
    {
      "title": "Business",
      "image": "assets/business.png",
      "argument": "Business"
    },
    {
      "title": "Public Health",
      "image": "assets/public_health.png",
      "argument": "Public Health"
    },
    {"title": "Study", "image": "assets/study.png", "argument": "Study"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message Boards"),
      ),
      drawer: DrawerMenu(),
      body: ListView.separated(
        padding: EdgeInsets.all(16.0),
        itemCount: boards.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final board = boards[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(board["image"]!),
            ),
            title: Text(
              board["title"]!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Last message preview..."),
            onTap: () => Navigator.pushNamed(
              context,
              '/chat',
              arguments: board["argument"],
            ),
          );
        },
      ),
    );
  }
}
