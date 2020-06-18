import 'package:flutter/material.dart';
import 'package:handongsekki/model/model_menu.dart';
import 'package:handongsekki/screen/detail_screen.dart';

class HomeBoxSlider extends StatelessWidget {
  final List<Menu> menus;

  HomeBoxSlider({this.menus});

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
            '이번 달 인기 메뉴',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color.fromRGBO(125, 176, 189, 1),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 120,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: makeBoxImages(context, menus)),
          )
        ],
      ),
    );
  }
}

List<Widget> makeBoxImages(BuildContext context, List<Menu> menus) {
  List<Widget> results = [];

  for (var i = menus.length - 1; i >= 0; i--) {
    results.add(InkWell(
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
//          decoration: boxDecoration(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Image.network(menus[i].image),
        ),
      ),
    ));
  }
  return results;
}

//BoxDecoration boxDecoration() {
//  return BoxDecoration(
//    border: Border.all(
//      color: Colors.red,
//      width: 3.0,
//    ),
//  );
//}
