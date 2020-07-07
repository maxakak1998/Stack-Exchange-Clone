import 'dart:async';
import 'dart:developer';

import 'package:flutter_se/src/AllSitePage/AllSiteBloc/State.dart';
import 'package:flutter_se/src/SitePage/SiteBloc/Events.dart';
import 'package:flutter_se/src/common/Badge.dart';
import 'package:flutter_se/src/common/User.dart';
import 'package:flutter_se/src/common/Service.dart';
import 'package:flutter_se/src/common/Site.dart';
import 'package:flutter_se/src/common/Topic.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;

import '../Tag.dart';

class SiteRepo {
  Future<List<Topic>> getTopicsBySite(Site site,
      {int pageSize, int pageNumber, TagType tagType}) async {
    String api = Service.getTopicApiByParam(site.getParamAPI,
        pageNumber: pageNumber, pageSize: pageSize, tagType: tagType);
    log("API is $api");
    final response = await http.get(api);
    if (response.statusCode == 200) {
      List<dynamic> body = convert.jsonDecode(response.body)['items'];
      List<Topic> topics = body
          .map<Topic>((item) => Topic(
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
              site,
              body: item["body"]))
          .toList();

      return topics;
    }
    log("Response is null");
    return null;
  }

  Future<List<Tag>> fetchTags(TagType type, String siteParam,
      {int pageSize = 50, int page = 1}) async {
    assert(type != null, "Type cant be null");
    assert(siteParam != null, "Site param cant be null");
    assert(pageSize != null, "Page size cant be null");
    assert(page != null, "Page number cant be null");

    String api = Service.getTagApi(type, siteParam,
        page: page ?? 1, pageSize: pageSize ?? 50);
    final response = await http.get(api);

    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      List<dynamic> body = json['items'];

      final List<Tag> tags = body.map((tag) => Tag.fromJson(tag)).toList();

      return tags;
    } else {
      log("Response is null, status code is ${response.statusCode}");
      return null;
    }
  }

  Future<List<User>> fetchUsers(
      {String siteParam,
      TagType tagType,
      int page = 1,
      int pageSize = 50}) async {
    assert(siteParam != null, "Site param cant be null");
    assert(tagType != null, "Tag type cant be null");

    try {
      String api = Service.getUserApi(
          siteParam: siteParam,
          tagType: tagType,
          page: page,
          pageSize: pageSize);
      final response = await http.get(api).timeout(new Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> body = convert.jsonDecode(response.body)['items'];
        final List<User> users =
            body.map<User>((userJson) => new User.fromJson(userJson)).toList();
        return users;
      } else {
        return null;
      }
    } on TimeoutException catch (e) {
      log("Time out : ${e.toString()} ");
      return null;
    }
  }

  Future<List<Tag>> getSearchingDataByTag({
    Site site,
    CategorySite categorySite,
    TagType tagType,
    int pageNumber = 1,
    int pageSize = 50,
    String searchingData,
  }) async {
    assert(site != null, "Site param cant be null");
    assert(tagType != null, "Tag type cant be null");
    String api = Service.getSearchApi(site.getParamAPI, categorySite, tagType,
        pageNumber, pageSize, searchingData);

    final response = await http.get(api);

    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      List<dynamic> body = json['items'];

      final List<Tag> tags = body.map((tag) => Tag.fromJson(tag)).toList();

      return tags;
    } else {
      log("Response is null, status code is ${response.statusCode}");
      return null;
    }
  }

  Future<List<Topic>> getSearchingDataByQuestion({
    Site site,
    CategorySite categorySite,
    TagType tagType,
    int pageNumber = 1,
    int pageSize = 50,
    String searchingData,
  }) async {
    assert(site != null, "Site param cant be null");
    assert(tagType != null, "Tag type cant be null");

    String api = Service.getSearchApi(site.getParamAPI, categorySite, tagType,
        pageNumber, pageSize, searchingData);
    print("Search api is $api");
    final response = await http.get(api);
    if (response.statusCode == 200) {
      List<dynamic> body = convert.jsonDecode(response.body)['items'];
      List<Topic> topics = body
          .map<Topic>((item) => Topic(
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
          .toList();

      return topics;
    } else {
      log("Response is null");

      return null;
    }
  }
}
