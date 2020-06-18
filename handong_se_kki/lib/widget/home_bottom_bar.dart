import 'package:flutter/material.dart';

class HomeBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(125, 176, 189, 1),
      child: SafeArea(
        child: Container(
          height: 50,
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.transparent,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.home,
                  size: 20,
                ),
                child: Text(
                  '홈',
                  style: TextStyle(fontSize: 9),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.search,
                  size: 20,
                ),
                child: Text(
                  '검색',
                  style: TextStyle(fontSize: 9),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.favorite,
                  size: 20,
                ),
                child: Text(
                  '찜',
                  style: TextStyle(fontSize: 9),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list,
                  size: 20,
                ),
                child: Text(
                  '더 보기',
                  style: TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
