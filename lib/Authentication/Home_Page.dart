import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    home: Home_Page(username: 'Hamayoun'),
  ));
}

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  late List<dynamic> data = [];
  late List<dynamic> filteredData = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    getData();
  }

  Future<void> getData() async {
    try {
      http.Response response = await http.get(
          Uri.parse("https://jsonplaceholder.typicode.com/photos"));
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          filteredData = List.from(data);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _search(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = List.from(data);
      });
      return;
    }

    setState(() {
      filteredData = data.where((item) =>
      item["id"].toString().toLowerCase().contains(query.toLowerCase()) ||
          item["title"].toString().toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        backgroundColor: Colors.indigo.withOpacity(0.5),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search...",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _search('');
                  },
                ),
              ),
              onChanged: (query) => _search(query),
            ),
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 10,
              radius: Radius.circular(20), //corner radius of scrollbar
              scrollbarOrientation: ScrollbarOrientation.right,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredData.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detail_Page(item: filteredData[index]),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(filteredData[index]["url"]),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Username: ${filteredData[index]["id"]}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Description: ${filteredData[index]["title"]}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Detail_Page extends StatefulWidget {
  final Map<String, dynamic> item;
  final List<String> additionalImageUrls = [
    "https://i.pinimg.com/564x/7b/63/f1/7b63f1f39819010eb7a0a3e72e367ac1.jpg",
    "https://i.pinimg.com/564x/ef/f4/b0/eff4b0fdc5411d8f38c02839cce33d7f.jpg",
    "https://i.pinimg.com/564x/4c/05/f6/4c05f6d318bf91b3c17d01c9a4b3099d.jpg",
    "https://i.pinimg.com/564x/17/81/e5/1781e5d3e1d2d73f42cd89c900ec9f2c.jpg",
    "https://i.pinimg.com/564x/1b/85/60/1b856060759004836b21807819fff430.jpg",
  ];

  Detail_Page({Key? key, required this.item}) : super(key: key);

  @override
  _Detail_PageState createState() => _Detail_PageState();
}

class _Detail_PageState extends State<Detail_Page> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      enlargeCenterPage: true,
                      autoPlay: false, // Disable auto play for additional control
                      aspectRatio: 20 / 5,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.8,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: widget.additionalImageUrls.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detail_Page(
                                    item: {"id": 0, "url": imageUrl, "title": "Additional Image"},
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: "image_additional_${widget.additionalImageUrls.indexOf(imageUrl)}",
                              child: Container(
                                margin: EdgeInsets.all(0.2),
                                height: 50,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(imageUrl),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 35,
                    right: 35,
                    top: 195,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.additionalImageUrls.asMap().entries.map((entry) {
                            int index = entry.key;
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentIndex ? Colors.white : Colors.grey, // Change indicator color based on selection
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Username: ${widget.item["id"]}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                child: Text(
                  "Description: ${widget.item["title"]}",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
