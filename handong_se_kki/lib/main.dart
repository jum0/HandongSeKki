import 'package:flutter/material.dart';
import 'package:handongsekki/screen/home_screen.dart';
import 'package:handongsekki/screen/bookmark_screen.dart';
import 'package:handongsekki/screen/login_screen.dart';
import 'package:handongsekki/screen/more_screen.dart';
import 'package:handongsekki/screen/search_screen.dart';
import 'package:handongsekki/widget/home_bottom_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TabController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HandongSeKki',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        accentColor: Colors.white,
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
//              LoginScreen(),
              HomeScreen(),
              SearchScreen(),
              LikeScreen(),
              MoreScreen(),
            ],
          ),
          bottomNavigationBar: HomeBottomBar(),
        ),
      ),
      initialRoute: '/login_screen',
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login_screen') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginScreen(),
      fullscreenDialog: true,
    );
  }
}
