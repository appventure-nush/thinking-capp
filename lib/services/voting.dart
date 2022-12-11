import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/services/auth.dart';

class VotingService extends GetxService {
  String get _currentUserId => Get.find<AuthService>().currentUser.id;

  final _questionsRef = FirebaseFirestore.instance.collection('questions');

  Stream<int> numVotesStream(String questionId, {String? answerId}) {
    var ref = _questionsRef.doc(questionId);
    if (answerId != null) {
      ref = ref.collection('answers').doc(answerId);
    }
    return ref.snapshots().map<int>((doc) {
      return doc.data()!['numVotes'];
    });
  }

  Future<void> upvote(
    String questionId, {
    String? answerId,
    required bool removeDownvote,
  }) async {
    var ref = _questionsRef.doc(questionId);
    if (answerId != null) {
      ref = ref.collection('answers').doc(answerId);
    }
    await ref.update({
      'upvotedBy': FieldValue.arrayUnion([_currentUserId]),
      if (removeDownvote)
        'downvotedBy': FieldValue.arrayRemove([_currentUserId]),
      'numVotes': FieldValue.increment(removeDownvote ? 2 : 1),
    });
  }

  Future<void> downvote(
    String questionId, {
    String? answerId,
    required bool removeUpvote,
  }) async {
    var ref = _questionsRef.doc(questionId);
    if (answerId != null) {
      ref = ref.collection('answers').doc(answerId);
    }
    await ref.update({
      'downvotedBy': FieldValue.arrayUnion([_currentUserId]),
      if (removeUpvote) 'upvotedBy': FieldValue.arrayRemove([_currentUserId]),
      'numVotes': FieldValue.increment(removeUpvote ? -2 : -1),
    });
  }

  Future<void> removeVote(
    String questionId, {
    String? answerId,
    required bool oldVote,
  }) async {
    var ref = _questionsRef.doc(questionId);
    if (answerId != null) {
      ref = ref.collection('answers').doc(answerId);
    }
    await ref.update({
      if (oldVote) 'upvotedBy': FieldValue.arrayRemove([_currentUserId]),
      if (!oldVote) 'downvotedBy': FieldValue.arrayRemove([_currentUserId]),
      'numVotes': FieldValue.increment(oldVote ? -1 : 1),
    });
  }
}
