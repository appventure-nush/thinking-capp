import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  String name;
  String photoUrl;
  int reputation;
  List<String> modules;
  List<String> bookmarks; // questionIds

  AppUser({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.reputation,
    required this.modules,
    required this.bookmarks,
  });

  factory AppUser.fromDoc(DocumentSnapshot<Map> doc) {
    final data = doc.data()!;
    return AppUser(
      id: doc.id,
      name: data['name'],
      photoUrl: data['photoUrl'],
      reputation: data['reputation'],
      modules: List<String>.from(data['modules']),
      bookmarks: List<String>.from(data['bookmarks']),
    );
  }
}
