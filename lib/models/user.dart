import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  String name;
  String photoUrl;
  int reputation;
  List<String> followingTags;
  List<String> bookmarks; // questionIds

  AppUser({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.reputation,
    required this.followingTags,
    required this.bookmarks,
  });

  factory AppUser.fromDoc(DocumentSnapshot<Map> doc) {
    final data = doc.data()!;
    return AppUser(
      id: doc.id,
      name: data['name'],
      photoUrl: data['photoUrl'],
      reputation: data['reputation'],
      followingTags: List<String>.from(data['followingTags']),
      bookmarks: List<String>.from(data['bookmarks']),
    );
  }
}
