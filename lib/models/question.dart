import 'package:get/get.dart';
import 'package:thinking_capp/services/voting.dart';

class Question {
  final String id;
  final RxString title;
  final RxString text;
  final RxList<String> photoUrls;
  final RxList<String> tags;
  final bool byMe;
  late final Stream<int> numVotes;
  final Rx<bool?> myVote;
  int numAnswers;
  final DateTime timestamp;

  bool get upvoted => myVote.value == true;
  bool get downvoted => myVote.value == false;

  Question({
    required this.id,
    required this.title,
    required this.text,
    required this.photoUrls,
    required this.tags,
    required this.byMe,
    required this.myVote,
    required this.numAnswers,
    required this.timestamp,
  }) {
    numVotes = Get.find<VotingService>().numVotesStream(id);
  }
}
