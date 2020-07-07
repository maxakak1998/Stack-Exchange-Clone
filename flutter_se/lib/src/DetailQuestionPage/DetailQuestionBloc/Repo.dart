import 'package:flutter_se/src/common/Service.dart';
import 'package:flutter_se/src/common/Topic.dart';
import 'package:flutter_se/src/common/User.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;

class Repo {
  Future<User> fetchUserById({String id, String siteParam}) async {
    String api = Service.getUserApiById(siteParam: siteParam, id: id);
    print("Api is $api");
    final response = await http.get(api);
    if (response.statusCode == 200) {
      List<dynamic> body = (convert.jsonDecode(response.body)["items"]);
      User user = new User.fromJson(body?.first);
      return user;
    }
    return null;
  }

  Future<List<Topic>> fetchAnswers(String id, String siteParam) async {
    String api = Service.getAnswersApi(
      id,
      siteParam,
    );
    final response = await http.get(api);
    if (response.statusCode == 200) {
      List<dynamic> body = (convert.jsonDecode(response.body)["items"]);
      if (body[0]["answer_count"] == 0) {
        print("No answers !!!");
        return [];
      }
      List<Topic> answers = body[0]["answers"]
          .toList()
          .map<Topic>((item) => Topic(
              null,
              item["creation_date"],
              item["question_id"],
              null,
              new User(
                  profileImageUrl: item["owner"]["profile_image"],
                  profileUrl: item["owner"]["link"],
                  reputation: item["owner"]["reputation"],
                  userId: item["owner"]["user_id"],
                  userName: item["owner"]["display_name"],
                  badge: null),
              null,
              null,
              item["score"],
              null,
              null,
              null,
              answerId: item["answer_id"],
              body: item["body"]))
          .toList();

      List<Future> futures = new List<Future>();

      for (Topic topic in answers) {
        futures.add(fetchUserById(
            id: topic.owner.userId.toString(), siteParam: siteParam));

//        User user = await fetchUserById(
//            id: topic.owner.userId.toString(), siteParam: siteParam);
//topic.owner = user;
      }

      List<User> users = new List<User>();
      final userFuture = (await Future.wait(futures)).toList();
      for (User user in userFuture) {
        users.add(user);
      }

      assert(users != null, "User cant be null");

      for (int i = 0; i < answers.length; i++) {
        answers[i].owner = users[i];
      }

      return answers;
    }
    return null;
  }

  Future<Topic> fetchQuestion(String questionId, String siteParam) async {
    String api = Service.getQuestionApi(
      questionId,
      siteParam,
    );
    final response = await http.get(api);
    if (response.statusCode == 200) {
      List<dynamic> body = (convert.jsonDecode(response.body)["items"]);
      final topic = Topic(
          body.first["answer_count"],
          body.first["creation_date"],
          body.first["question_id"],
          false,
          new User(
              profileImageUrl: body.first["owner"]["profile_image"],
              profileUrl: body.first["owner"]["link"],
              reputation: body.first["owner"]["reputation"],
              userId: body.first["owner"]["user_id"],
              userName: body.first["owner"]["display_name"],
              badge: null),
          (body.first["tags"] as List).cast<String>(),
          body.first["link"],
          body.first["score"],
          body.first["title"],
          body.first["view_count"],
          null,
          body: body.first["body"]);
      return topic;
    }

    print("Topic is null");

    return null;
  }
}
