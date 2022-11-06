import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  String name;
  String photoUrl;
  int reputation;

  AppUser({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.reputation,
  });

  factory AppUser.fromDoc(DocumentSnapshot<Map> doc) {
    final data = doc.data()!;
    return AppUser(
      id: doc.id,
      name: data['name'],
      photoUrl: data['photoUrl'],
      reputation: data['reputation'],
    );
  }
}
