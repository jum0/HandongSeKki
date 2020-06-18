import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handongsekki/model/model_menu.dart';
import 'package:handongsekki/screen/detail_screen.dart';

class HomeCircleSlider extends StatelessWidget {
  final List<Menu> menus;
  HomeCircleSlider({this.menus});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
              color: Color.fromRGBO(125, 176, 189, 1),
          ),
          SizedBox(height: 7),
          Text(
            '이번 주 인기 메뉴',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color.fromRGBO(125, 176, 189, 1),
            ),
          ),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: makeCircleImage(context, menus)
            ),
          )
        ],
      ),
    );
  }
}

List<Widget> makeCircleImage(BuildContext context, List<Menu> menus) {
  List<Widget> results = [];

  for (var i = 0; i < menus.length; i++) {
    results.add(
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<Null>(
                fullscreenDialog: true,
                builder: (BuildContext context) {
                  return DetailScreen(
                    menu: menus[i],
                  );
                }));
          },
          child: Container(
            padding: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                backgroundImage: NetworkImage(menus[i].image),
                radius: 51,
//                backgroundColor: Color(0xffFDCF09),
//                child: CircleAvatar(
//                  backgroundImage: NetworkImage(menus[i].image),
//                  radius: 48,
//                ),
              ),
            ),
          ),
        )
    );
  }
  return results;
}