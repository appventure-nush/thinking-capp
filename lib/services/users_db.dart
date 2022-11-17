import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/user.dart';

class UsersDbService extends GetxService {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  Future<bool> hasUser(String id) async {
    return (await _usersRef.doc(id).get()).exists;
  }

  Future<AppUser> getUser(String id) async {
    return AppUser.fromDoc(await _usersRef.doc(id).get());
  }

  Future<AppUser> newUser(String id, String name) async {
    await _usersRef.doc(id).set({
      'name': name,
      'photoUrl': '',
      'reputation': 0,
      'followingTags': [],
      'bookmarks': [],
    });
    return AppUser(
      id: id,
      name: name,
      photoUrl: '',
      reputation: 0,
      followingTags: [],
      bookmarks: [],
    );
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _usersRef.doc(id).update(data);
  }

  Future<List<AppUser>> getTopRanked(int? startAfterScore) async {
    final subQuery = _usersRef.orderBy('reputation', descending: true);
    final snapshot = await (startAfterScore == null
            ? subQuery
            : subQuery.startAfter([startAfterScore]))
        .limit(10)
        .get();
    return snapshot.docs.map((doc) => AppUser.fromDoc(doc)).toList();
  }

  Future<void> addBookmark(String userId, String questionId) async {
    await _usersRef.doc(userId).update({
      'bookmarks': FieldValue.arrayUnion([questionId]),
    });
  }

  Future<void> removeBookmark(String userId, String questionId) async {
    await _usersRef.doc(userId).update({
      'bookmarks': FieldValue.arrayRemove([questionId]),
    });
  }
}
