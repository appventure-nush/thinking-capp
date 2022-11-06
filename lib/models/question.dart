import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/auth.dart';

class Question {
  final String id;
  String title;
  String text;
  List<String> photoUrls;
  List<String> tags;
  AppUser poster;
  int upvotes;
  bool? myVote;
  DateTime timestamp;

  Question({
    required this.id,
    required this.title,
    required this.text,
    required this.photoUrls,
    required this.tags,
    required this.poster,
    required this.upvotes,
    required this.myVote,
    required this.timestamp,
  });
}
