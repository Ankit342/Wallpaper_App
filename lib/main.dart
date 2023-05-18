import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_application_4/fullscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'fade_scale_transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WALL-E',
      color: Colors.black,
      home: ImageSearchPage(),
    );
  }
}

class ImageSearchPage extends StatefulWidget {
  @override
  _ImageSearchPageState createState() => _ImageSearchPageState();
}

class _ImageSearchPageState extends State<ImageSearchPage> {
  final _searchController = TextEditingController();
  List<String> _imageUrls = [];
  String selected = '';
  bool click = false;
  final _searchSuggestions = [
    'Nature',
    'City',
    'Food',
    'Animal',
    'Beach',
    'Mountain',
    'Travel',
    'Business',
    'Art',
    'Technology',
    'Ocean',
    'Tigers',
    'Pears',
    'People',
  ];
  List<Color> _listColors = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    _onSearchSubmitted('');
    _listColors = List.generate(_searchSuggestions.length, (index) {
      return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    _searchController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: (!click)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('WALL-E'),
                    IconButton(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // The background color you want
                          borderRadius: BorderRadius.circular(
                              5), // The border radius you want
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.black, // The icon color you want
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          click = true;
                        });
                      },
                    ),
                  ],
                )
              : Hero(
                  tag: 'searchBar',
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      controller: _searchController,
                      cursorColor: Colors.white,
                      onSubmitted: (value) {
                        setState(() {
                          click = false;
                        });
                        _onSearchSubmitted(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for images...',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              click = false;
                            });
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: Container(
                            decoration: BoxDecoration(
                              color:
                                  Colors.white, // The background color you want
                              borderRadius: BorderRadius.circular(
                                  5), // The border radius you want
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              click = false;
                            });
                            _onSearchSubmitted(_searchController.text);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast),
                  child: Row(
                    children: List.generate(_searchSuggestions.length, (index) {
                      final suggestion = _searchSuggestions[index];

                      return Container(
                          padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                            color: _listColors[
                                _searchSuggestions.indexOf(suggestion)],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              _getImageUrls(suggestion).then((imageUrls) {
                                setState(() {
                                  selected = suggestion;
                                  _imageUrls = imageUrls;
                                });
                              });
                            },
                            child: Text(
                              suggestion,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ));
                    }),
                  )),
            ),
            SizedBox(height: 5),
            Expanded(
              child: Visibility(
                visible: _imageUrls.isEmpty,
                child: Center(child: CircularProgressIndicator()),
                replacement: GridView.builder(
                  cacheExtent: 1000,
                  itemCount: _imageUrls.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemBuilder: (context, index) {
                    final imageUrl = _imageUrls[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            //MaterialPageRoute(
                            //  builder: (context) =>
                            //      FullScreen(imageUrl: imageUrl),
                            //),
                            PageRouteBuilder(
                                transitionDuration: Duration(seconds: 2),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) {
                                  return FadeScaleTransition(
                                    animation: animation,
                                    child: child,
                                  );
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return FullScreen(
                                    imageUrl: imageUrl,
                                  );
                                }));
                      },
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (_searchController.text.isEmpty && selected.isEmpty) {
                  loadmore('');
                } else if (!selected.isEmpty) {
                  loadmore(selected);
                } else if (!_searchController.text.isEmpty) {
                  loadmore(_searchController.text);
                } else {
                  Fluttertoast.showToast(
                      msg: 'Please enter a valid search query');
                }
                Fluttertoast.showToast(
                  msg: 'More Images Loaded',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.deepOrange,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
              child: Container(
                height: 40,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Load More',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  loadmore(String query) async {
    final apiKey = '7gkEPyJBC9UJjiuh2LKbmCLyWn5658kDHt4oW0xxoCelwv76sA5n9hFK';
    setState(() {
      page = page + 1;
    });
    print(query);
    String url;
    if (query.isEmpty) {
      // Load more curated photos
      url = 'https://api.pexels.com/v1/curated?per_page=20&page=$page';
    } else {
      // Load more search results
      url =
          'https://api.pexels.com/v1/search?query=$query&per_page=20&page=$page';
      print(query);
    }
    final urls = url + page.toString();
    final response = await http.get(Uri.parse(urls), headers: {
      'Authorization': apiKey,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newImageUrls = List<String>.from(
          data['photos'].map((photo) => photo['src']['medium']));
      setState(() {
        _imageUrls.addAll(newImageUrls);
      });
    } else {
      print('Error: ${response.statusCode}');
      return [];
    }
  }

  Future<List<String>> _getImageUrls(String query) async {
    final apiKey = '7gkEPyJBC9UJjiuh2LKbmCLyWn5658kDHt4oW0xxoCelwv76sA5n9hFK';
    final url =
        'https://api.pexels.com/v1/search?query=$query&per_page=20&page=1';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': apiKey,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(
          data['photos'].map((photo) => photo['src']['portrait']));
    } else {
      print('Error: ${response.statusCode}');
      return [];
    }
  }

  void _onSearchSubmitted(String query) async {
    final apiKey = '7gkEPyJBC9UJjiuh2LKbmCLyWn5658kDHt4oW0xxoCelwv76sA5n9hFK';

    // If query is empty, fetch popular images
    final url = query.isEmpty
        ? 'https://api.pexels.com/v1/curated?per_page=20&page=3'
        : 'https://api.pexels.com/v1/search?query=$query&per_page=20&page=1';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': apiKey,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _imageUrls = List<String>.from(
            data['photos'].map((photo) => photo['src']['portrait']));
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }
}
