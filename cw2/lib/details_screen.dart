import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final String recipe;
  final List<String> ingredients;
  final Function(bool) onFavoriteToggle;
  final bool isFavorite; // New parameter to track favorite status

  DetailsScreen({
    required this.recipe,
    required this.ingredients,
    required this.onFavoriteToggle,
    required this.isFavorite,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite =
        widget.isFavorite; // Initialize with the passed favorite status
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      widget.onFavoriteToggle(isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.recipe} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients for ${widget.recipe}:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...widget.ingredients
                .map((ingredient) => Text(
                      '- $ingredient',
                      style: TextStyle(fontSize: 18),
                    ))
                .toList(),
            SizedBox(height: 20),
            Text('Recipe details and instructions go here...'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleFavorite,
              child:
                  Text(isFavorite ? 'Unmark as Favorite' : 'Mark as Favorite'),
            ),
          ],
        ),
      ),
    );
  }
}
