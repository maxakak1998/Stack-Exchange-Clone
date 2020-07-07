import 'dart:developer';
import 'dart:math';

import 'package:flutter_se/src/Feed/FeedBloc/State.dart';
import 'package:flutter_se/src/Feed/TopicRows.dart';
import 'package:flutter_se/src/common/User.dart';
import 'package:flutter_se/src/common/Service.dart';
import 'package:flutter_se/src/common/Site.dart';

import 'package:flutter_se/src/common/Topic.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;

class Repo {
  List<Site> allSites;
  Repo({this.allSites});
  Future<List<Topic>> getTopics(
      Site site, int pageSize, int currentDayInSecs) async {
    Map<String, String> api = Service.getTopicsApiBySiteName(site,
        pageSize: pageSize, currentDayInSec: currentDayInSecs);
    print("API is ${api.entries.first.value}");

    final response = await http.get(api.entries.first.value);
    if (response.statusCode == 200) {
      List<dynamic> body = convert.jsonDecode(response.body)["items"];
      bool isHot = api.entries.first.key == "Hot" ? true : false;

      List<Topic> topic = body
          .map((item) => Topic(
              item["answer_count"],
              item["creation_date"],
              item["question_id"],
              isHot,
              new User(
                profileImageUrl: item["owner"]["profile_image"],
                profileUrl: item["owner"]["link"],
                reputation: item["owner"]["reputation"],
                userId: item["owner"]["user_id"],
                userName: item["owner"]["display_name"],
              ),
              (item["tags"] as List<dynamic>).cast<String>().toList(),
              item["link"],
              item["score"],
              item["title"],
              item["view_count"],
              site))
          .toList();

      return topic;
    } else {
      return null;
    }
  }

  Future<Topic> getHotTopic({Site site}) async {
    if (site == null) {
      site = getRandomSite();
      print("Hot topic site is ${site.getName}");
    }
    String api = Service.getHotTopicApiBySiteName(site: site);
    print("Api is $api");

    final response = await http.get(api);
    if (response.statusCode == 200) {
      List<dynamic> body = convert.jsonDecode(response.body)["items"];

      Topic topic = body
          .map((item) => Topic(
              item["answer_count"],
              item["creation_date"],
              item["question_id"],
              true,
              new User(
                profileImageUrl: item["owner"]["profile_image"],
                profileUrl: item["owner"]["link"],
                reputation: item["owner"]["reputation"],
                userId: item["owner"]["user_id"],
                userName: item["owner"]["display_name"],
              ),
              (item["tags"] as List<dynamic>).cast<String>().toList(),
              item["link"],
              item["score"],
              item["title"],
              item["view_count"],
              site))
          .firstWhere((item) => item != null, orElse: () => null);

      return topic;
    } else {
      print("Error is ${response.statusCode}");
      return null;
    }
  }

  Future<List<List<Topic>>> getRowsOfTopics(int _rowSizeForAnotherPage,
      {int time}) async {
    List<List<Topic>> topicRows = new List<List<Topic>>();
    for (var i = 0; i < _rowSizeForAnotherPage; i++) {
      int _pageSize = 1 + new Random().nextInt(8 - 1);
      Site _site = getRandomSite();
      if (_site != null) {
        //each row
        List<Topic> topics = await getTopics(_site, _pageSize, time);
        if (topics != null && topics.isNotEmpty) {
          topicRows.add(topics);
        }
      }
    }
    return topicRows;
  }

//  Future<Topic> getTheHotTopic({Site site}) async {
//    if (site == null) {
//      site = getRandomSite();
//      print("Hot topic site is ${site.getName}");
//    }
//
//    Topic hotTopic = await getHotTopic(site: site);
//    return hotTopic;
//  }

  Future<List<Topic>> getFullHotTopic(List<Site> mainSites,
      {int topicLength}) async {
    if (topicLength == null) {
      topicLength = mainSites.length;
    }
    List<Topic> fullHotTopics = new List<Topic>();

    for (var i = 0; i < topicLength; i++) {
      Topic topic = await getHotTopic(site: mainSites[i]);
      if (topic != null) {
        fullHotTopics.add(topic);
      }
    }

    return fullHotTopics;
  }

  int getCurrentDayInsSec() {
    int now = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now;
  }

  Site getRandomSite() {
    List<Site> mainSites =
        allSites.where((site) => site.getSiteType == "main_site").toList();
    if (mainSites == null) {
      return null;
    }
    int length = mainSites?.length ?? 0;
    int randomPos = new Random().nextInt(length - 1);
    return mainSites[randomPos];
  }

  Future<OnLoaded> onRefresh(OnLoaded state) async {
    int randomPos = Random().nextInt(state.fullHotTopic.length);
    Topic newHotTopic = state.fullHotTopic[randomPos];
    Site site = getRandomSite();
    int effectiveTime = new Duration(days: 5).inSeconds;
    List<Topic> justNowTopic =
        (await getTopics(site, 1, getCurrentDayInsSec() - effectiveTime));
    if (justNowTopic.isEmpty || justNowTopic == null) {
      return state..hotTopic = newHotTopic;
    }
    List<List<Topic>> justNowTopicRows = new List<List<Topic>>();
    justNowTopicRows.add(justNowTopic);

    TopicRows justNowTopicRow = new TopicRows(
        justNowTopicRows, getCurrentDayInsSec(),
        label: "Just now");
    List<TopicRows> newTopicRows;
    bool hasJustNowRow = state.allTopicRows[0].label == "Just now";
    if (hasJustNowRow) {
      //insert just now
      state.allTopicRows[0].topicRows.insert(0, justNowTopic);
    } else {
      state.allTopicRows.insert(0, justNowTopicRow);
    }

    newTopicRows = state.allTopicRows;
    OnLoaded newState =
        new OnLoaded(newHotTopic, state.fullHotTopic, newTopicRows);
    return newState;
  }
}
