import 'package:flutter_se/src/common/Topic.dart';
import 'package:flutter_se/src/common/User.dart';

abstract class DetailQuestionState {}

class Initializing extends DetailQuestionState {}

class Loaded extends DetailQuestionState {
  User user;
  List<Topic> answers;
  Topic question;
  Loaded({this.user, this.answers, this.question})
      : assert(user != null, "Topic can't be null");
}
