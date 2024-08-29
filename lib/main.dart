import 'package:db_minorquote/provider/themeProvider.dart';
import 'package:db_minorquote/views/DetailPage.dart';
import 'package:db_minorquote/views/EditPage.dart';
import 'package:db_minorquote/views/FavPage.dart';
import 'package:db_minorquote/views/HomePage.dart';
import 'package:db_minorquote/views/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Quote App',
          themeMode: themeProvider.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => SplashScreen(),
            'home_page': (context) => HomePage(),
            'detail_page': (context) => DetailPage(),
            'fav_page': (context) => FavoritesPage(),
            'edit_page': (context) => EditPage(),
          },
        );
      },
    );
  }
}
