import 'package:get/get.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/users_db.dart';

class AnswersStore extends GetxService {
  final _usersDb = Get.find<UsersDbService>();
  MyUser get _currentUser => Get.find<AuthService>().currentUser;

  // ensure this data remains synced throughout the app
  // the same answers may be loaded as separate objects in different
  // pages, resulting in different answer objects. The following ensures that
  // all same answers share the same object, ensuring data remains synced
  // through their reactive fields
  final Map<String, Answer> _answerObjs = {};

  Future<Answer> getAnswer(
    String id,
    String questionId,
    Map<String, dynamic> data, {
    required bool fromFirebase,
  }) async {
    final poster = await _usersDb.getUser(data['poster']);
    bool? myVote;
    if (data['upvotedBy'].contains(_currentUser.id)) {
      myVote = true;
    } else if (data['downvotedBy'].contains(_currentUser.id)) {
      myVote = false;
    }
    Answer answer;
    if (_answerObjs.containsKey(id)) {
      answer = _answerObjs[id]!;
      answer.text.value = data['text'];
      answer.photoUrls.value = List<String>.from(data['photoUrls']);
      answer.myVote.value = myVote;
    } else {
      answer = Answer(
        id: id,
        questionId: questionId,
        text: RxString(data['text']),
        photoUrls: RxList<String>.from(data['photoUrls']),
        poster: poster,
        myVote: Rx<bool?>(myVote),
        timestamp: fromFirebase
            // stored in firebase as Timestamp
            ? data['timestamp'].toDate()
            // stored in algolia as int
            : DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
      );
      _answerObjs[id] = answer;
    }
    return answer;
  }

  void putAnswer(Answer answer) {
    _answerObjs[answer.id] = answer;
  }
}
