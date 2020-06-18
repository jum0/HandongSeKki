import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:handongsekki/screen/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class MoreScreen extends StatefulWidget {
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String uid;
  String nickName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            // 프로필 사진
            Container(
              padding: EdgeInsets.only(top: 100),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('images/handong_logo2.png'),
              ),
            ),
            // 이름
//            Container(
//              padding: EdgeInsets.only(top: 25),
//              child: Text(
//                'Junmo',
//                style: TextStyle(
//                    fontWeight: FontWeight.bold,
//                    fontSize: 25,
//                ),
//              ),
//            ),
            // 이름 밑에 바
//            Container(
//              padding: EdgeInsets.all(15),
//              width: 140,
//              height: 5,
//              color: Color.fromRGBO(125, 176, 189, 1),
//            ),
            // 링크 걸기
            Container(
              padding: EdgeInsets.all(10),
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  }
                },
                text: "https://hisnet.handong.edu",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                linkStyle: TextStyle(color: Color.fromRGBO(125, 176, 189, 1),),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: FlatButton(
//                onPressed: () async {
//                  final FirebaseUser user = await _auth.currentUser();
//                  await _auth.signOut();
//                  Navigator.pop(context);
//                },
                onPressed: () async {
                  final FirebaseUser user = await _auth.currentUser();
                  await _auth.signOut();

                  Navigator.of(context).push(MaterialPageRoute<Null>(
                      fullscreenDialog: true,
                      builder: (BuildContext context) {
                        return LoginScreen();
                      }));
                },
                child: Container(
                  height: 30,
                  color: Color.fromRGBO(125, 176, 189, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
//                      Icon(
//                        Icons.edit,
//                        color: Colors.white,
//                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '로그아웃',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}