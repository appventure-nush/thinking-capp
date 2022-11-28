import 'package:get/get.dart';
import 'package:thinking_capp/models/user.dart';

class Answer {
  final String id;
  final String questionId;
  String text;
  List<String> photoUrls;
  MyUser poster;
  int numVotes;
  Rx<bool?> myVote;
  DateTime timestamp;

  bool get upvoted => myVote.value == true;
  bool get downvoted => myVote.value == false;

  Answer({
    required this.id,
    required this.questionId,
    required this.text,
    required this.photoUrls,
    required this.poster,
    required this.numVotes,
    required this.myVote,
    required this.timestamp,
  });
}
