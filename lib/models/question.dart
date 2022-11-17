import 'package:get/get.dart';
import 'package:thinking_capp/models/user.dart';

class Question {
  final String id;
  String title;
  String text;
  List<String> photoUrls;
  List<String> tags;
  AppUser poster;
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
    required this.poster,
    required this.numVotes,
    required this.myVote,
    required this.numAnswers,
    required this.timestamp,
  });
}
