import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_se/src/DetailQuestionPage/DetailQuestionBloc/Events.dart';
import 'package:flutter_se/src/DetailQuestionPage/DetailQuestionBloc/Repo.dart';
import 'package:flutter_se/src/DetailQuestionPage/DetailQuestionBloc/State.dart';
import 'package:flutter_se/src/common/Topic.dart';
import 'package:flutter_se/src/common/User.dart';

class DetailQuestionBloc
    extends Bloc<DetailQuestionEvent, DetailQuestionState> {
  Repo repo = new Repo();
  @override
  DetailQuestionState get initialState => Initializing();

  @override
  Stream<DetailQuestionState> mapEventToState(
      DetailQuestionEvent event) async* {
    if (event is FetchUserDetailEvent) {
      User user = await repo.fetchUserById(
          id: event.userId, siteParam: event.siteParam);
      List<Topic> answers =
          await repo.fetchAnswers(event.questionId, event.siteParam);
      Topic question =
          await repo.fetchQuestion(event.questionId, event.siteParam);
      yield Loaded(user: user, answers: answers, question: question);
    }
  }

  void onFetchUserDetail(String userId, String questionId, String siteParam) {
    add(FetchUserDetailEvent(
        userId: userId, questionId: questionId, siteParam: siteParam));
  }
}
