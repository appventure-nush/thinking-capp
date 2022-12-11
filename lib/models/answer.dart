import 'package:get/get.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/voting.dart';

class Answer {
  final String id;
  final String questionId;
  final RxString text;
  final RxList<String> photoUrls;
  final MyUser poster;
  late final Stream<int> numVotes;
  Rx<bool?> myVote;
  final DateTime timestamp;

  bool get upvoted => myVote.value == true;
  bool get downvoted => myVote.value == false;

  Answer({
    required this.id,
    required this.questionId,
    required this.text,
    required this.photoUrls,
    required this.poster,
    required this.myVote,
    required this.timestamp,
  }) {
    numVotes = Get.find<VotingService>().numVotesStream(
      questionId,
      answerId: id,
    );
  }
}
