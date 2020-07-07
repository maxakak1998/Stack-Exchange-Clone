import 'User.dart';
import 'Site.dart';

class Topic extends Site {
  List<String> tags;
  User owner;
  int viewCount;
  int topicScore;
  int creationDate;
  String topicLink;
  String topicTitle;
  int questionId;
  int answerId;
  bool isHot;
  int answerCount;
  Site site;
  List<Topic> answers;
  String body;
  Topic(
      this.answerCount,
      this.creationDate,
      this.questionId,
      this.isHot,
      this.owner,
      this.tags,
      this.topicLink,
      this.topicScore,
      this.topicTitle,
      this.viewCount,
      this.site,
      {this.answers,
      this.answerId,
      this.body})
      : super(site?.getName, site?.getIconUrl,
            paramAPI: site?.getParamAPI,
            description: site?.getDescription,
            siteType: site?.getSiteType);
}
