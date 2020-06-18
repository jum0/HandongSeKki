import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  final String name;
  final String keyword;
  final String image;
  final bool bookmark;
  final int likes;
  final int dislikes;
  final DocumentReference reference;

  Menu.fromMap(Map<String, dynamic> map, {this.reference })
      : name = map['name'],
        keyword = map['keyword'],
        image = map['image'],
        bookmark = map['bookmark'],
        likes = map['likes'],
        dislikes = map['dislikes'];

  Menu.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Menus<$name:$keyword>";
}
