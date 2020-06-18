// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

//import 'package:Shrine/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱 바 여기 안에 signout 메서드 들어있음 나중에 확인하
//      appBar: AppBar(
////        title: Text(widget.title),
//        actions: <Widget>[
//          Builder(builder: (BuildContext context) {
//            return FlatButton(
//              child: const Text('Sign out'),
//              textColor: Theme.of(context).buttonColor,
//              onPressed: () async {
//                final FirebaseUser user = await _auth.currentUser();
//                if (user == null) {
//                  Scaffold.of(context).showSnackBar(const SnackBar(
//                    content: Text('No one has signed in.'),
//                  ));
//                  return;
//                }
//                _signOut();
//                final String uid = user.uid;
//                Scaffold.of(context).showSnackBar(SnackBar(
//                  content: Text(uid + ' has successfully signed out.'),
//                ));
//              },
//            );
//          })
//        ],
//      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(height: 200.0),
            Column(
              children: <Widget>[
                Image.asset('images/logo_handong_se_kki.png'),
                SizedBox(height: 16.0),
              ],
            ),
            SizedBox(height: 120.0),
            _GoogleSignInSection(),
            _AnonymouslySignInSection(),
          ],
        );
      }),
    );
  }
}

// Google Sign In Section
class _GoogleSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  bool _success;
  String _userID;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ButtonTheme(
          minWidth: 350.0,
          height: 50.0,
          buttonColor: Colors.red.withOpacity(0.6),
          child: RaisedButton(
            child: Text(
              'Google로 계속하기',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              _signInWithGoogle();
            },
          ),
        ),

        // 로그인 되었을 때 표시되는 Container
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _success == null
                ? ''
                : (_success
                    ? 'Successfully signed in, uid: ' + _userID
                    : 'Sign in failed'),
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }

  // Example code of how to sign in with google.
  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      // 구글 로그인 취소 누르면 넘어가지 않음
      if (user != null) {
        _success = true;
        _userID = user.uid;

//        print(_userID);

        Navigator.pop(context);
      } else {
        _success = false;
      }
    });
  }
}

// Anonymously Sign In Section
class _AnonymouslySignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnonymouslySignInSectionState();
}

class _AnonymouslySignInSectionState extends State<_AnonymouslySignInSection> {
  bool _success;
  String _userID;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ButtonTheme(
          minWidth: 350.0,
          height: 50.0,
          buttonColor: Color.fromRGBO(184, 215, 223, 1),
          child: RaisedButton(
            child: Text(
              '익명으로 계속하기',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              _signInAnonymously();
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _success == null
                ? ''
                : (_success
                    ? 'Successfully signed in, uid: ' + _userID
                    : 'Sign in failed'),
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }

  // Example code of how to sign in anonymously.
  void _signInAnonymously() async {
    final FirebaseUser user = (await _auth.signInAnonymously()).user;
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null);
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _success = true;
        _userID = user.uid;

        // 익명 id 출력
//        print(_userID);

        // 익명 로그인
        Navigator.pop(context);
      } else {
        _success = false;
      }
    });
  }
}
