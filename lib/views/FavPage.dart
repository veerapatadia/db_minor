import 'package:flutter/material.dart';
import '../helper/db_helper.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favoriteQuotes = [];
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    List<Map<String, dynamic>> favorites = await dbHelper.getFavorites();
    setState(() {
      favoriteQuotes = favorites;
    });
  }

  Future<void> removeFavorite(String quote) async {
    await dbHelper.deleteFavorite(quote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Quote removed from favorites')),
    );
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
      ),
      body: favoriteQuotes.isEmpty
          ? Center(child: Text('No favorites added yet'))
          : ListView.builder(
              itemCount: favoriteQuotes.length,
              itemBuilder: (context, index) {
                final quote = favoriteQuotes[index]['quote'];
                final author = favoriteQuotes[index]['author'];
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        quote,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'Author: $author',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          removeFavorite(quote);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
