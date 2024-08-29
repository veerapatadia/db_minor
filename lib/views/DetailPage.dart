import '../helper/db_helper.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart'
    show ByteData, Clipboard, ClipboardData, rootBundle;

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<dynamic> quotes = [];
  List<dynamic> selectedQuotes = [];
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    loadQuotes();
  }

  Future<void> toggleFavorite(String quote, String author) async {
    bool isFavorite = await dbHelper.isFavorite(quote);

    if (isFavorite) {
      await dbHelper.deleteFavorite(quote);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote removed from favorites')),
      );
    } else {
      await dbHelper.insertFavorite(quote, author);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote added to favorites')),
      );
    }

    setState(() {});
  }

  Future<void> loadQuotes() async {
    String jsonString =
        await rootBundle.loadString('assets/data/jsonData.json');
    setState(() {
      quotes = json.decode(jsonString);

      final args = ModalRoute.of(context)!.settings.arguments as Map;
      final chapterNumber = args['name'];

      selectedQuotes = quotes.firstWhere(
        (quotes) => quotes['name'] == chapterNumber,
        orElse: () => {},
      )['quotes'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/564x/b7/f6/a5/b7f6a524a96895532ac182ca1a4c8b5f.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          selectedQuotes.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  physics: PageScrollPhysics(),
                  itemCount: selectedQuotes.length,
                  itemBuilder: (context, i) {
                    final category = selectedQuotes[i];
                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 850,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        padding: EdgeInsets.only(top: 30, left: 20, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${category["quote"]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Author: ${category["author"]}',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 19,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FutureBuilder<bool>(
                                    future:
                                        dbHelper.isFavorite(category["quote"]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.favorite_outline,
                                            color: Colors.white,
                                          ),
                                        );
                                      } else {
                                        bool isFavorite =
                                            snapshot.data ?? false;
                                        return IconButton(
                                          onPressed: () async {
                                            await toggleFavorite(
                                                category["quote"],
                                                category["author"]);
                                          },
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: isFavorite
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final quoteText =
                                          selectedQuotes[i]["quote"];
                                      final quoteAuthor =
                                          selectedQuotes[i]["author"];

                                      await Clipboard.setData(
                                        ClipboardData(
                                            text: "$quoteText \n$quoteAuthor"),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Quote copied to clipboard',
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          'edit_page',
                                          arguments: selectedQuotes[i]);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
