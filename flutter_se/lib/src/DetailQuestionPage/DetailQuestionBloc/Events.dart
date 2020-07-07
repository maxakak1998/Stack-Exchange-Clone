abstract class DetailQuestionEvent {}

class FetchUserDetailEvent extends DetailQuestionEvent {
  String userId, siteParam, questionId;
  FetchUserDetailEvent({this.userId, this.questionId, this.siteParam});
}
