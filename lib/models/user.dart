import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String id;
  String name;
  String photoUrl;
  int reputation;
  List<String> followingTags;
  bool showEverything; // show everything in feed, dont filter by tags
  List<String> bookmarks; // questionIds

  MyUser({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.reputation,
    required this.followingTags,
    required this.showEverything,
    required this.bookmarks,
  });

  factory MyUser.fromDoc(DocumentSnapshot<Map> doc) {
    final data = doc.data()!;
    return MyUser(
      id: doc.id,
      name: data['name'],
      photoUrl: data['photoUrl'],
      reputation: data['reputation'],
      followingTags: List<String>.from(data['followingTags']),
      showEverything: data['showEverything'],
      bookmarks: List<String>.from(data['bookmarks']),
    );
  }
}
