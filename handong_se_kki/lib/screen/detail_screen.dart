import 'package:flutter/material.dart';
import 'package:handongsekki/model/model_menu.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handongsekki/widget/detail_bottom_comments.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class DetailScreen extends StatefulWidget {
  final Menu menu;

  DetailScreen({this.menu});

  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Firestore firestore = Firestore.instance;
  Stream<QuerySnapshot> streamData;

  String menuName;
  String uid;
  int likes;
  bool bookmark;

//  bool bookmark2;
  int isLikes =
      0; // firestore의 uid collection에 저장되어 있는 각 음식에 대한 좋아요 // 1은 좋아요 표시 / 0은 아무것도 표시하지 않은 것 / -1은 싫어요

  @override
  void initState() {
    super.initState();
    streamData = firestore.collection('menu').snapshots();

//    initMenuFavoriteColor();
    bookmark = widget.menu.bookmark;
    likes = widget.menu.likes;
    menuName = widget.menu.name;
  }

  void initMenuFavoriteColor() async {
//    final FirebaseUser user = await _auth.currentUser();
//    uid = user.uid;
//
//    DocumentReference docRef =
//        firestore.collection("menu").document(widget.menu.name);
//    DocumentSnapshot doc = await docRef.get();
//    List uids = doc.data['uids'];
//
//    if (uids.contains(uid)) {
//      bookmark2 = true;
//    } else {
//      bookmark2 = false;
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _fetchTopMiddleDetailData(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkCommentHistory(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _fetchTopMiddleDetailData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('menu').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildDetail(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildDetail(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Stack(
                children: <Widget>[_topDetailMenuIntroduction()],
              ),
//              _middleDetailFilter(),
//              Divider(
//                color: Colors.grey,
//              ),
              DetailBottomComments(menuName: widget.menu.name)
            ],
          ),
        ),
      ),
    );
  }

  Widget _topDetailMenuIntroduction() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.menu.image),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.1),
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: <Widget>[
                  // 맨 위 닫기 아이콘
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  // 메뉴 이미지
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: ClipRRect(
//                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(
                        widget.menu.image,
                        height: 200.0,
                        width: 200.0,
                      ),
                    ),
                  ),

                  Container(
//                    padding: EdgeInsets.all(7),
                    child: Text(
                      widget.menu.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    child: Text(
                      widget.menu.keyword,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white
                      ),
                    ),
                  ),
                  //
                  Container(
                    padding: EdgeInsets.all(3),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
//                              setState(() {
//                                bookmark2 = !bookmark2;
//                                bookmark = bookmark2;
//
//                                bookmark
//                                    ? widget.menu.reference.updateData(
//                                        {
//                                          'uids': FieldValue.arrayUnion([uid])
//                                        },
//                                      )
//                                    : widget.menu.reference.updateData(
//                                        {
//                                          'uids': FieldValue.arrayRemove([uid])
//                                        },
//                                      );
//                              });
                              setState(() {
                                bookmark = !bookmark;
                                widget.menu.reference
                                    .updateData({'bookmark': bookmark});
                              });
//                              setState(() async {
//                                DocumentReference docRef =
//                                firestore.collection("menu").document(menuName);
//                                DocumentSnapshot doc = await docRef.get();
//                                List uids = doc.data['uids'];
//
//                                bookmark2 = !bookmark2;
//
//                                print(uid);
//                                print(bookmark2);
//                                print(uids);
//
//                                if (uids.contains(uid)) {
//                                  docRef.updateData({'uids': FieldValue.arrayRemove([uid])});
//                                } else {
//                                  docRef.updateData({'uids': FieldValue.arrayUnion([uid])});
//                                }
//
//                              });
                            },
                            color: Colors.white, // 테두리만 색 하도록?
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                bookmark
                                    ? Icon(
                                        Icons.favorite,
                                        color: Color.fromRGBO(125, 176, 189, 1),
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: Color.fromRGBO(125, 176, 189, 1),
//                                  color: Colors.amber,
                                      ),
                                Padding(padding: EdgeInsets.all(5)),
                                Text(
                                  '찜',
                                  style: TextStyle(
                                    fontSize: 15,
//                                    color: Colors.white60,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 1),
                        Expanded(
                          child: FlatButton(
//                            onPressed: () =>
//                                bottomModal.mainBottomSheet(context),
                            onPressed: () {},
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.send,
                                  color: Color.fromRGBO(125, 176, 189, 1),
                                ),
                                Text('  공유'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 여기부터는 blur 밖에 있는 것 갘아. 나중에 조정
//                  Container(
//                    padding: EdgeInsets.all(5),
//                    alignment: Alignment.centerLeft,
//                    child: Text(widget.menu.toString() +
//                        widget.menu.toString() +
//                        widget.menu.toString() +
//                        widget.menu.toString()),
//                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _middleDetailFilter() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//      color: Colors.red,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '필터',
            style: TextStyle(
              fontSize: 16,
//              color: Colors.white60,
            ),
          ), // bottom sheet 추가
          Expanded(
              child: SizedBox(
            width: 0.0,
          )),
          Text(
            '리뷰 25',
            style: TextStyle(
              fontSize: 12,
//              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
//    return Container(
//      color: Colors.black54,
//      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          // 좋아요
//          Container(
//            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//            child: InkWell(
//              onTap: () async {
//                // uid
//                final FirebaseUser user = await _auth.currentUser();
//                final String uid = user.uid;
//
//                // firestore for each menu
//                DocumentReference docRef = Firestore.instance
//                    .collection('menu')
//                    .document(widget.menu.name);
//                DocumentSnapshot doc = await docRef.get();
//                List uids = doc.data['uids'];
//
//                // 메뉴에 대한 평가가 없는 경우
//                if (uids.contains(uid) == false) {
//                  // collection 만들
//                  createDocFromLikes(uid);
//                  // 음식 목록에 좋아요 한 리스트 menu collection에 음식의 uids에 uid 추가
//                  docRef.updateData({
//                    'uids': FieldValue.arrayUnion([uid])
//                  });
//                  // 좋아요 한 개 올리기
//                  widget.menu.reference.updateData({'likes': likes + 1});
//
//                  // 메뉴에 대한 평가가 있는 경우(likes 혹은 dislikes)
//                } else {
//                  // firestore for each uid
//                  DocumentReference docRef_uid = Firestore.instance
//                      .collection(uid)
//                      .document(widget.menu.name);
//                  DocumentSnapshot doc_uid = await docRef_uid.get();
//                  isLikes = doc_uid.data["isLiked"];
//
//                  // 싫어요로 평가했던 경우
//                  if (isLikes == -1) {
//                    widget.menu.reference
//                        .updateData({'dislikes': dislikes - 1}); // 싫어요가 1 줄어들고
//                    widget.menu.reference
//                        .updateData({'likes': likes + 1}); // 좋아요가 1 늘어남
//                    isLikes = 1; // flag를 좋아요로
//                    // 좋아요로 평가했던 경우
//                  } else {
//                    // 좋아요 꺼지
//                    widget.menu.reference.updateData({'likes': likes - 1});
//                    isLikes = 0; // 다시 중립으로
//                  }
//                }
//
//                setState(() {
//                  print("setState in likes");
//
////                            isLikes = !isLikes;
////                            Firestore.instance.collection(uid).document(widget.menu.name).updateData({'isLiked': isLikes});
//                });
//              },
//              child: Column(
//                children: <Widget>[
//                  isLikes == 1
//                      ? Icon(
//                          Icons.thumb_up,
//                          color: Colors.amber,
//                        )
//                      : Icon(
//                          Icons.thumb_up,
//                          color: Colors.white30,
//                        ),
//                  Padding(padding: EdgeInsets.all(5)),
//                  Text(
//                    '$likes',
//                    style: TextStyle(
//                      fontSize: 11,
//                      color: Colors.white60,
//                    ),
//                  )
//                ],
//              ),
//            ),
//          ),
//
//          // 싫어요
//          Container(
//            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//            child: InkWell(
//              onTap: () async {
//                // uid
//                final FirebaseUser user = await _auth.currentUser();
//                final String uid = user.uid;
//
//                // firestore for each menu
//                DocumentReference docRef = Firestore.instance
//                    .collection('menu')
//                    .document(widget.menu.name);
//                DocumentSnapshot doc = await docRef.get();
//                List uids = doc.data['uids'];
//
//                // 메뉴에 대한 평가가 없는 경우
//                if (uids.contains(uid) == false) {
//                  // collection 만들
//                  createDocFromDislikes(uid);
//                  // 음식 목록에 싫어요 한 리스트 menu collection에 음식의 uids에 uid 추가
//                  docRef.updateData({
//                    'uids': FieldValue.arrayUnion([uid])
//                  });
//                  // 싫어요 한 개 올리기
//                  widget.menu.reference.updateData({'dislikes': dislikes + 1});
//                  // 메뉴에 대한 평가가 있는 경우(likes 혹은 dislikes)
//                } else {
//                  // firestore for each uid
//                  DocumentReference docRef_uid = Firestore.instance
//                      .collection(uid)
//                      .document(widget.menu.name);
//                  DocumentSnapshot doc_uid = await docRef_uid.get();
//                  isLikes = doc_uid.data["isLiked"];
//                  print(uid);
//
//                  // 싫어요로 평가했던 경우
//                  if (isLikes == false) {
//                    // 이전에 싫어요 찍었다는 것
//                    // 싫어요 꺼지게
//                    // 싫어요 숫자 하나 줄이기
//                    // 좋아요 숫자 하나 증가
////                              widget.menu.reference.updateData({'likes': likes + 1});
//                    // 좋아요로 평가했던 경우
//                  } else {
//                    // 이전에 좋아요 찍었다는 것
////                              widget.menu.reference.updateData({'likes': likes - 1});
//                  }
//                }
//
//                setState(() {
//                  print("setState in dislikes");
////                            isLikes = !isLikes;
//                  Firestore.instance
//                      .collection(uid)
//                      .document(widget.menu.name)
//                      .updateData({'isLiked': isLikes});
//                });
//              },
//              child: Column(
//                children: <Widget>[
//                  true
//                      ? Icon(
//                          Icons.thumb_down,
//                          color: Colors.white30,
//                        )
//                      : Icon(
//                          Icons.thumb_down,
//                          color: Colors.amber,
//                        ),
//                  Padding(padding: EdgeInsets.all(5)),
//                  Text(
//                    '$likes',
//                    style: TextStyle(
//                      fontSize: 11,
//                      color: Colors.white60,
//                    ),
//                  )
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
  }

  void updateBookmark(bool jjim) async {
//    jjim ?
//    final sFirebaseUser user = await _auth.currentUser();
//    uid = user.uid;
//
//    print("save menu bookmark");
//    print(uid);
//
//    firestore.collection("user").document(uid).setData({
//      "$menuName": false,
//    });

//    print(bookmark2);
//    widget.menu.reference.updateData({'bookmark': bookmark});
  }

  void createNewComment(String comment) {
    print("create new comment");

    firestore.collection(widget.menu.name).document(uid).setData({
      "likes": 0,
      "comment": comment,
      "own": uid,
      "nickName": "익명",
      "time": DateTime.now().millisecondsSinceEpoch,
      "uids": [],
    });
  }

  void checkCommentHistory(BuildContext context) async {
    final FirebaseUser user = await _auth.currentUser();
    uid = user.uid;

    final snapShot =
        await firestore.collection(widget.menu.name).document(uid).get();

    // 댓글 기록이 있으면
    if (snapShot.exists) {
//      print("it exists");
      showAskAlertDialog(context);
    } else {
//      print("it doesn't exists");
      showNewCommentAlertDialog(context);
    }
  }

  void showAskAlertDialog(BuildContext context) async {
    print("showAskAlertDialog");

    final snapShot =
        await firestore.collection(widget.menu.name).document(uid).get();
    final like = snapShot.data['likes'];
    final date = DateTime.fromMillisecondsSinceEpoch(snapShot.data['time']);
    final nickName = snapShot.data['nickName'];

    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('댓글 삭제'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
//                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "$nickName",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        Text("  "),
                        Text(
                          "$date",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(snapShot.data['comment']),

//                    좋아요 아이콘이랑 숫자
//                    SizedBox(height: 10.0),
//                    Container(
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.end,
//                        children: <Widget>[
//                          Icon(Icons.thumb_up),
//                          SizedBox(width: 10.0),
//                          Text('$like')
//                        ],
//                      ),
//                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "기존의 댓글을 삭제하고 새로운 댓글을 작성합니다. 계속 진행하시겠습니까?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text('취소'),
                  onPressed: () {
                    Navigator.pop(context, "취소");
                  },
                ),
                FlatButton(
                  child: Text(
                    '삭제',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "삭제");
                    showNewCommentAlertDialog(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showNewCommentAlertDialog(BuildContext context) async {
    TextEditingController _newCommentCon = TextEditingController();

    final FirebaseUser user = await _auth.currentUser();
    uid = user.uid;

    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('새로운 댓글'),
          content: TextField(
            controller: _newCommentCon,
            decoration: InputDecoration(hintText: "댓글을 입력해주세요 :)"),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text('취소'),
                  onPressed: () {
                    _newCommentCon.clear();
                    Navigator.pop(context, "취소");
                  },
                ),
                FlatButton(
                  child: Text('추가'),
                  onPressed: () {
                    if (_newCommentCon.text.isNotEmpty) {
                      createNewComment(_newCommentCon.text);
                    }
                    _newCommentCon.clear();
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
