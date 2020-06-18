import 'package:flutter/material.dart';
import 'package:handongsekki/model/model_menu.dart';
import 'package:handongsekki/widget/home_monthly_best_menus.dart';
import 'package:handongsekki/widget/home_carousel_slider.dart';
import 'package:handongsekki/widget/home_weekly_best_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Firestore firestore = Firestore.instance;
  Stream<QuerySnapshot> streamData;

  @override
  void initState() {
    super.initState();
    streamData = firestore.collection('menu').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('menu').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<Menu> menus = snapshot.map((d) => Menu.fromSnapshot(d)).toList();
    return ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            HomeCarouselImage(menus: menus),
            TopBar(),
          ],
        ),
        HomeCircleSlider(menus: menus),
        HomeBoxSlider(menus: menus,)
      ],
    );
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/logo_handong_se_kki.png',
            fit: BoxFit.contain,
            height: 40,
          ),
//          Container(
//            padding: EdgeInsets.only(right: 1),
//            child: Text(
//              '학관',
//              style: TextStyle(fontSize: 14),
//            ),
//          ),
//          Container(
//            padding: EdgeInsets.only(right: 1),
//            child: Text(
//              '맘스',
//              style: TextStyle(fontSize: 14),
//            ),
//          ),
//          Container(
//            padding: EdgeInsets.only(right: 1),
//            child: Text(
//              '행복동 식당',
//              style: TextStyle(fontSize: 14),
//            ),
//          ),
        ],
      ),
    );
  }
}
