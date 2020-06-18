import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class DetailBottomComments extends StatefulWidget {
  final String menuName;

  DetailBottomComments({this.menuName});

  _DetailBottomCommentsState createState() => _DetailBottomCommentsState();
}

class _DetailBottomCommentsState extends State<DetailBottomComments> {
  Firestore firestore = Firestore.instance;
  Stream<QuerySnapshot> streamData;

  String uid;
  int likes;
  int theNumOfComments;
  var date;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    streamData = firestore.collection(widget.menuName).snapshots();
  }

  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      body: _fetchDetailBottomData(context),
//    );
    return _fetchDetailBottomData(context);
  }

  Widget _fetchDetailBottomData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(widget.menuName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildDetailBottomList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildDetailBottomList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    theNumOfComments = snapshot.length;
    return SizedBox(
      height: 850,
      child: Column(
        children: <Widget>[
          _buildDetailMiddleFilter(),
          Divider(
            color: Color.fromRGBO(125, 176, 189, 1),
          ),
          Expanded(
            child: ListView(
              children: snapshot
                  .map((data) => _buildDetailBottomListComment(context, data))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailMiddleFilter() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//      color: Colors.red,
      height: 40,
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
            '리뷰 $theNumOfComments',
            style: TextStyle(
              fontSize: 14,
//              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    setState(() async {
      final FirebaseUser user = await _auth.currentUser();
      uid = user.uid;

      DocumentReference docRef =
          firestore.collection(widget.menuName).document(uid);
      DocumentSnapshot doc = await docRef.get();
      List uids = doc.data['uids'];

      print(uids);
      print(doc.data['likes']);

      if (uids.contains(uid)) {
        print("if here");
        docRef.updateData({
          'uids': FieldValue.arrayRemove([uid])
        });
        _isFavorited = false;
        docRef.updateData({'likes': doc.data['likes'] - 1});
      } else {
        print("else here");
        docRef.updateData({
          'uids': FieldValue.arrayUnion([uid])
        });
        _isFavorited = true;
        docRef.updateData({'likes': doc.data['likes'] + 1});
      }

//      // likes 조정용
//      if (_isFavorited) {
//
//      } else {
//
//      }
    });
  }

  Widget _buildDetailBottomListComment(
      BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    likes = record.likes;
    date = DateTime.fromMillisecondsSinceEpoch(record.time);

    return ListTile(
      title: Container(
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        height: 140,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(
                    record.nickName,
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  Text("  "),
                  Text(
                    "$date",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(child: SizedBox(width: 0.0)),
                  // 댓글 삭제
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () async {
                      final FirebaseUser user = await _auth.currentUser();
                      uid = user.uid;

                      if (data.documentID == uid) {
                        print("삭제 가능");
                        showAskAlertDialog(context, data.documentID);
                      } else {
                        print("삭제 불가능");
                        print("현재 uid = $uid");
                        print(data.documentID);
                        showImpossibleAlertDialog(context);
                      }
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 0.0,
            ),
            Expanded(
              child: Text(
                record.comment,
                textAlign: TextAlign.left,
              ),
            ),
            // 댓글 좋아요 기능
            // 댓글 좋아요 기능 빼면서 height 170 -> 140
//            Container(
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                      child: SizedBox(
//                    width: 0.0,
//                  )),
//                  Container(
//                    child: Row(
//                      children: <Widget>[
//                        IconButton(
//                          icon: (_isFavorited
//                              ? Icon(
//                                  Icons.thumb_up,
//                                  color: Color.fromRGBO(125, 176, 189, 1),
//                                )
//                              : Icon(Icons.thumb_up)),
////                                    onPressed: () => record.reference.updateData({'likes': record.likes + 1})
//                          onPressed: _toggleFavorite,
//                        ),
//                        Text(
//                          "$likes",
//                          style: TextStyle(
//                            fontSize: 12.0,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                  SizedBox(width: 10) // 댓글의 좋아요가 왼쪽으로 오도록
//                ],
//              ),
//            ),
            Divider(
              color: Color.fromRGBO(125, 176, 189, 1),
            ),
          ],
        ),
      ),
    );
  }

  void showAskAlertDialog(BuildContext context, documentID) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('댓글 삭제'),
          content: Text("댓글을 삭제하시겠습니까?"),
          actions: <Widget>[
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
                Navigator.pop(context, "확인");
                deleteDoc(documentID);
              },
            ),
          ],
        );
      },
    );
  }

  void showImpossibleAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('잘못된 접근'),
          content: Text("댓글을 삭제할 권한이 없습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.pop(context, "확인");
              },
            ),
          ],
        );
      },
    );
  }

  void deleteDoc(String docID) {
    firestore.collection(widget.menuName).document(docID).delete();
  }

//  void addLike() {
//    firestore.collection("menu").document(widget.menuName).
//  }
}

class Record {
  final String comment;
  final int likes;
  final String nickName;
  final String own;
  final int time;

//  final List uids;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['comment'] != null),
        assert(map['likes'] != null),
        assert(map['nickName'] != null),
        assert(map['own'] != null),
        assert(map['time'] != null),
        comment = map['comment'],
        likes = map['likes'],
        nickName = map['nickName'],
        own = map['own'],
        time = map['time'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$comment:$likes:$nickName:$own:$time>";
}
