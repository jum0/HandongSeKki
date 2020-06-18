import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:handongsekki/model/model_menu.dart';
import 'package:handongsekki/screen/detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class HomeCarouselImage extends StatefulWidget {
  final List<Menu> menus;

  HomeCarouselImage({this.menus});

  _HomeCarouselImageState createState() => _HomeCarouselImageState();
}

class _HomeCarouselImageState extends State<HomeCarouselImage> {
  List<Menu> menus;
  List<String> names;
  List<Widget> images;
//  List<String> keywords;
  List<bool> bookmarks;
  int _currentPage = 0; // carsousslider에서 어느 위치에 있는지 그 인덱스를 저장하는 변수
//  String _currentKeyword;
  String _currentTitle;

  @override
  void initState() {
    super.initState();
    menus = widget.menus;
    names = menus.map((m) => m.name).toList();
    images = menus.map((m) => Image.network(m.image)).toList();
//    keywords = menus.map((m) => m.keyword).toList();
    bookmarks = menus.map((m) => m.bookmark).toList();
//    _currentKeyword = keywords[0];
    _currentTitle = names[0];

    print(images);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
          ),
          CarouselSlider(
            items: images,
            options: CarouselOptions(onPageChanged: (index, reason) {
              setState(() {
                _currentPage = index;
//                _currentKeyword = keywords[_currentPage];
                _currentTitle = names[_currentPage];
              });
            }),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 3),
            child: Text(
//              _currentKeyword,
              _currentTitle,
              style: TextStyle(fontSize: 14),
            ),
          ),
//          SizedBox(height: 10),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    bookmarks[_currentPage]
                        ? IconButton(
                            icon: Icon(Icons.favorite),
                            color: Color.fromRGBO(125, 176, 189, 1),
                            iconSize: 25,
                            onPressed: () {
                              setState(() {
                                print(bookmarks);
                                bookmarks[_currentPage] = !bookmarks[_currentPage];
                                menus[_currentPage]
                                    .reference
                                    .updateData({'bookmark': bookmarks[_currentPage]});
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.favorite_border),
                            color: Color.fromRGBO(125, 176, 189, 1),
                            onPressed: () {
                              setState(() {
                                bookmarks[_currentPage] = !bookmarks[_currentPage];
                                menus[_currentPage]
                                    .reference
                                    .updateData({'bookmark': bookmarks[_currentPage]});
                              });
                            },
                          ),
                    Text(
                      '찜',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(right: 3),
                  child: Column(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.info),
                          color: Color.fromRGBO(125, 176, 189, 1),
                          iconSize: 25,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                fullscreenDialog: true,
                                builder: (BuildContext context) {
                                  return DetailScreen(
                                    menu: menus[_currentPage],
                                  );
                                }));
                          }),
                      Text(
                        '정보',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: makeIndicator(bookmarks, _currentPage)),
          ),
        ],
      ),
    );
  }
}

List<Widget> makeIndicator(List list, int _currentPage) {
  List<Widget> results = [];
  for (var i = 0; i < list.length; i++) {
    results.add(Container(
      width: 8,
      height: 8,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == i
              ? Color.fromRGBO(125, 176, 189, 0.9)
              : Color.fromRGBO(0, 0, 0, 0.2)),
    ));
  }
  return results;
}
