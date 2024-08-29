import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../helper/api_helper.dart';
import '../model/api_model.dart';
import '../provider/themeProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> jsonData;
  ImagePicker imagePicker = ImagePicker();
  XFile? xFile;
  File? imageFile;
  ApiQuoteModel? randomQuote;
  List<ApiQuoteModel> apiData = [];

  void loadJson() {
    jsonData = rootBundle.loadString("assets/data/jsonData.json");
  }

  @override
  void initState() {
    super.initState();
    loadJson();
    callRandomQuote();
    fetchAPIQuotes();
  }

  callRandomQuote() async {
    randomQuote = await ApiHelper.apiHelper.fetchRandomQuote();
    setState(() {});
  }

  fetchAPIQuotes() async {
    apiData = await ApiHelper.apiHelper.fetchAPI();
    setState(() {});
  }

  Future<void> pickImage() async {
    xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        imageFile = File(xFile!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                margin: EdgeInsets.all(0),
                currentAccountPicture: GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: imageFile == null
                        ? Icon(Icons.add_a_photo, color: Colors.white, size: 25)
                        : ClipOval(
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            ),
                          ),
                  ),
                ),
                accountName: Text("Patadia Veera"),
                accountEmail: Text("patadiaveera@gmail.com"),
              ),
            ),
            ListTile(
              title: Text(
                "Change Theme",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Icon(
                Icons.palette,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text(
                "Light Theme",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Radio(
                value: "light",
                groupValue: Provider.of<ThemeProvider>(context).currentTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changetheme("light");
                },
              ),
            ),
            ListTile(
              title: Text(
                "Dark Theme",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Radio(
                value: "dark",
                groupValue: Provider.of<ThemeProvider>(context).currentTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changetheme("dark");
                },
              ),
            ),
            ListTile(
              title: Text(
                "System Theme",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Radio(
                value: "system",
                groupValue: Provider.of<ThemeProvider>(context).currentTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changetheme("system");
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Quote App",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('fav_page');
            },
            icon: Icon(Icons.favorite),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: 10,
                right: 10,
                bottom: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://i.pinimg.com/564x/e7/b4/49/e7b4497502913363f8266182abeadecc.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: (randomQuote == null)
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.format_quote_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(height: 10),
                          Text(
                            randomQuote!.quote,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '- ${randomQuote!.author}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: FutureBuilder(
              future: jsonData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("ERROR : ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  String? data = snapshot.data;
                  List allData = (data == null) ? [] : jsonDecode(data);
                  return (data == null)
                      ? Center(
                          child: Text("No data available"),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: allData.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        'detail_page',
                                        arguments: allData[i]);
                                  },
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "${allData[i]['image']}",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${allData[i]['name']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
