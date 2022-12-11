import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/auth.dart';

class QuestionsStore extends GetxService {
  String get _currentUserId => Get.find<AuthService>().currentUser.id;

  // ensure this data remains synced throughout the app
  // the same questions may be loaded as separate objects in different
  // pages, resulting in different question objects. The following ensures that
  // all same questions share the same object, ensuring data remains synced
  // through their reactive fields
  final Map<String, Question> _questionObjs = {};

  Question getQuestion(
    String id,
    Map<String, dynamic> data, {
    required bool fromFirebase,
  }) {
    bool? myVote;
    if (data['upvotedBy'].contains(_currentUserId)) {
      myVote = true;
    } else if (data['downvotedBy'].contains(_currentUserId)) {
      myVote = false;
    }
    Question question;
    if (_questionObjs.containsKey(id)) {
      question = _questionObjs[id]!;
      question.title.value = data['title'];
      question.text.value = data['text'];
      question.photoUrls.value = List<String>.from(data['photoUrls']);
      question.tags.value = List<String>.from(data['tags']);
      question.myVote.value = myVote;
      question.numAnswers = data['numAnswers'];
    } else {
      question = Question(
        id: id,
        title: RxString(data['title']),
        text: RxString(data['text']),
        photoUrls: RxList<String>.from(data['photoUrls']),
        tags: RxList<String>.from(data['tags']),
        byMe: data['poster'] == _currentUserId,
        myVote: Rx<bool?>(myVote),
        numAnswers: data['numAnswers'],
        timestamp: fromFirebase
            // stored in firebase as Timestamp
            ? data['timestamp'].toDate()
            // stored in algolia as int
            : DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
      );
      _questionObjs[id] = question;
    }
    return question;
  }

  void putQuestion(Question question) {
    _questionObjs[question.id] = question;
  }
}
