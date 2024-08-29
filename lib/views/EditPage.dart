import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import '../utils/globalData.dart';

class EditPage extends StatefulWidget {
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  GlobalKey repaintKey = GlobalKey();
  String backgroundImageUrl =
      "https://i.pinimg.com/564x/b7/f6/a5/b7f6a524a96895532ac182ca1a4c8b5f.jpg";

  TextAlign textAlign = TextAlign.center;
  String selectedFontFamily = 'Roboto';
  Color selectedTextColor = Colors.white;
  List<String> fontFamilies = GoogleFonts.asMap().keys.toList();

  Future<void> shareImage() async {
    RenderRepaintBoundary renderRepaintBoundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    var image = await renderRepaintBoundary.toImage(pixelRatio: 5);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List fetchImage = byteData!.buffer.asUint8List();

    Directory directory = await getApplicationCacheDirectory();
    String path = directory.path;
    File file = File('$path.png');

    file.writeAsBytes(fetchImage);
    ShareExtend.share(file.path, "image");
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final quote = args['quote'];
    final author = args['author'];

    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(
            key: repaintKey,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        backgroundImageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.6),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      alignment: Alignment.center,
                      height: 800,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                      ),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            quote,
                            style: GoogleFonts.getFont(
                              selectedFontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: selectedTextColor,
                            ),
                            textAlign: textAlign,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Author: $author',
                            style: GoogleFonts.getFont(
                              selectedFontFamily,
                              fontStyle: FontStyle.italic,
                              fontSize: 19,
                              color: selectedTextColor,
                            ),
                            textAlign: textAlign,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.all(16.0),
                                height: 350,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Text Alignment',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.format_align_left),
                                          onPressed: () {
                                            setState(() {
                                              textAlign = TextAlign.left;
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.format_align_center),
                                          onPressed: () {
                                            setState(() {
                                              textAlign = TextAlign.center;
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.format_align_right),
                                          onPressed: () {
                                            setState(() {
                                              textAlign = TextAlign.right;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Font Family',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: fontFamilies
                                            .map(
                                              (e) => (fontFamilies.indexOf(e) <=
                                                      10)
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedFontFamily =
                                                              e;
                                                        });
                                                      },
                                                      icon: Text(
                                                        "Aa",
                                                        style:
                                                            GoogleFonts.getFont(
                                                          e,
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    Text(
                                      'Text Color',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: Colors.accents
                                            .map(
                                              (e) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedTextColor =
                                                        e; // Set the selected text color
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10, top: 10),
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: e,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.text_fields_outlined,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 25,
                      child: IconButton(
                        onPressed: () async {
                          await AsyncWallpaper.setWallpaper(
                            url: backgroundImageUrl,
                            wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
                            goToHome: false,
                            toastDetails: ToastDetails.success(),
                            errorToastDetails: ToastDetails.error(),
                          );
                        },
                        icon: Icon(
                          Icons.wallpaper,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 25,
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            scrollControlDisabledMaxHeightRatio: 8 / 10,
                            elevation: 0.5,
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select an Image',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Divider(),
                                    Expanded(
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 8,
                                          childAspectRatio: 4 / 7,
                                        ),
                                        itemCount: allImageData.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                backgroundImageUrl =
                                                    allImageData[index]
                                                        ["image-url"];
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Image.network(
                                              allImageData[index]["image-url"],
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.image,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 25,
                      child: IconButton(
                        onPressed: () async {
                          await shareImage();
                        },
                        icon: Icon(
                          Icons.share,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
