import 'package:thinking_capp/models/user.dart';

class Answer {
  final String id;
  String text;
  List<String> photoUrls;
  AppUser poster;
  int upvotes;
  bool? myVote;
  DateTime timestamp;

  Answer({
    required this.id,
    required this.text,
    required this.photoUrls,
    required this.poster,
    required this.upvotes,
    required this.myVote,
    required this.timestamp,
  });
}
