import 'package:get/get.dart';

class Question {
  final String id;
  String title;
  String text;
  List<String> photoUrls;
  List<String> tags;
  bool byMe;
  int numVotes;
  Rx<bool?> myVote;
  int numAnswers;
  DateTime timestamp;

  bool get upvoted => myVote.value == true;
  bool get downvoted => myVote.value == false;

  Question({
    required this.id,
    required this.title,
    required this.text,
    required this.photoUrls,
    required this.tags,
    required this.byMe,
    required this.numVotes,
    required this.myVote,
    required this.numAnswers,
    required this.timestamp,
  });
}
