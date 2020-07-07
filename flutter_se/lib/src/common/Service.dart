import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_se/src/SitePage/SiteBloc/Events.dart';
import 'package:flutter_se/src/common/Topic.dart';

import 'Site.dart';

class Service {
  static List<String> allSiteNames;
  static String server = "https://api.stackexchange.com/2.2";
//  static String getUserIdFromFbApi(String access_token) {
//    assert(access_token != null, "Access token can't be null");
//    String api =
//        "https://graph.facebook.com/me?fields=id&access_token=$access_token";
//    return api;
//  }

  static String getAllSiteApi({int page, int pageSize}) {
    String _api = "/sites";
    String _connector = "?";
    String _param = "";
    if (page != null) {
      _param += "$_connector" + "page=$page";
      _connector = "&";
    }

    if (pageSize != null) {
      _param += "$_connector" + "pagesize=$pageSize";
      _connector = "&";
    }
    return "$server$_api$_param";
  }

  static String getHotTopicApiBySiteName({Site site}) {
    String api =
        "/questions?pagesize=1&order=desc&sort=hot&site=${site.getParamAPI}";
    return "$server$api";
  }

  static Map<String, String> getTopicsApiBySiteName(Site site,
      {int pageSize = 5, int currentDayInSec}) {
    String api = "";
    String type;
    if (site == null)
      site = new Site("Stack Overflow",
          "https://cdn.sstatic.net/Sites/stackoverflow/img/apple-touch-icon@2.png",
          paramAPI: "stackoverflow");

    String getCurrentDayParam(int param) =>
        param == null ? "" : "&fromdate=$param";

    bool randomChoice = new Random().nextBool();
    //if true, return unanswer api, otherwise return hot api
    if (randomChoice) {
      type = "UnAnswer";
      api =
          //no answer api
          api =
              "/questions/no-answers?pagesize=$pageSize${getCurrentDayParam(currentDayInSec)}&order=desc&sort=creation&site=${site.getParamAPI}";
    } else {
      type = "Hot";
      api =
          "/questions?pagesize=$pageSize${getCurrentDayParam(currentDayInSec)}&order=desc&sort=hot&site=${site.getParamAPI}";
    }
    Map<String, String> item = new Map<String, String>();
    item[type] = "$server$api";

    return item;
  }

  static String getTopicApiByParam(String paramAPI,
      {int pageSize = 20, int pageNumber, TagType tagType}) {
    String filterCode = "!9_bDDxJY5";

    String sortBy;
    String date = "";
    int currentTimeInSecs = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int yesterdayInSecs =
        DateTime.now().subtract(new Duration(days: 1)).millisecondsSinceEpoch ~/
            1000;

    String getNewestDate() =>
        "&fromdate=$yesterdayInSecs&todate=$currentTimeInSecs";
    pageSize ??= 20;
    pageNumber ??= 1;
    assert(pageNumber != null, "Page number is null at getTopicBySiteName");
    String getPageNumber(int pageSize) =>
        pageNumber != null ? "&page=$pageNumber" : "";

    if (tagType == TagType.Active) {
      sortBy = "activity";
    } else if (tagType == TagType.Newest) {
      sortBy = "activity";
      date = getNewestDate();
    } else if (tagType == TagType.Hot || tagType == TagType.Votes) {
      sortBy = describeEnum(tagType).toLowerCase();
    } else if (tagType == TagType.UnAnswerNewest) {
      sortBy = "activity";
      return "$server/questions/no-answers?order=desc&sort=$sortBy&site=$paramAPI&pagesize=$pageSize${getPageNumber(pageNumber)}${getNewestDate()}&filter=$filterCode";
    }
    return "$server/questions?order=desc&sort=$sortBy&site=$paramAPI&pagesize=$pageSize${getPageNumber(pageNumber)}$date&filter=$filterCode";
  }

  static String getAnswersApi(String id, String siteParam) {
    final filterCode = "!thDm6gCTW4FjbpCZ5Im-3cZ3UoBmyBm";
    return "$server/questions/$id?order=desc&sort=activity&site=$siteParam&filter=$filterCode";
  }

  static String getQuestionApi(String id, String siteParam) {
    final filterCode = "!9_bDDxJY5";

    String api =
        "$server/questions/$id?order=desc&sort=activity&site=$siteParam&filter=$filterCode";
    print("APi is $api");
    return api;
  }

  static String getTimeDiff(int creationDate) {
    String timeFormatting(int sec) {
      int duration = 0;
      if (sec < 60)
        //to sec
        return "$sec sec. ago"; //to min
      else if (sec >= 60 && sec < 3600) {
        //to min
        duration = new Duration(seconds: sec).inMinutes;
        return "$duration min. ago";
      } else if (sec >= 3600 && sec < 86400) {
        //to hour
        duration = new Duration(seconds: sec).inHours;
        return "$duration hr. ago";
      } else if (sec >= 86400 && sec < 86400 * 5) {
        //to day
        duration = new Duration(seconds: sec).inDays;
        return "- $duration ";
      } else {
        DateTime duration =
            DateTime.now().subtract(Duration(seconds: sec)).toUtc();

        return "${duration.day}-${duration.month}-${duration.year} ";
      }
    }

    int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    int differenceInSec = now - creationDate;

    return timeFormatting(differenceInSec);
  }

  static String getSearchApi(String paramApi, CategorySite categorySite,
      TagType tagType, int pageNumber, int pageSize, String searchingData) {
    String api;
    String sortBy;
    String date;
    int currentTimeInSecs = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int yesterdayInSecs =
        DateTime.now().subtract(new Duration(days: 1)).millisecondsSinceEpoch ~/
            1000;

    String getNewestDate() =>
        "&fromdate=$yesterdayInSecs&todate=$currentTimeInSecs";
    if (categorySite == CategorySite.Questions) {
      if (tagType == TagType.Active) {
        sortBy = "activity";
        api =
            "/search/advanced?order=desc&sort=$sortBy&site=$paramApi&page=$pageNumber&pagesize=$pageSize&title=$searchingData";
      } else if (tagType == TagType.Newest) {
        sortBy = "activity";
        date = getNewestDate();
        api =
            "/search/advanced?order=desc&sort=$sortBy$date&site=$paramApi&page=$pageNumber&pagesize=$pageSize&title=$searchingData";
      } else if (tagType == TagType.Hot || tagType == TagType.Votes) {
        sortBy = describeEnum(tagType).toLowerCase();
        api =
            "/search/advanced?order=desc&$sortBy=activity&site=$paramApi&title=$searchingData";
      } else if (tagType == TagType.UnAnswerNewest) {
        api =
            "/search/advanced?order=desc&sort=activity&site=$paramApi&title=$searchingData";
      }
    } else if (categorySite == CategorySite.Tags) {
      sortBy = describeEnum(tagType).toLowerCase();
      api =
          "/tags?order=desc&sort=$sortBy&inname=$searchingData&site=$paramApi";
    }
    return "$server$api";
  }

  static String getTagApi(TagType type, String siteParam,
      {int pageSize, int page}) {
    String _type = describeEnum(type);
    String api =
        "/tags?order=desc&sort=$_type&site=$siteParam&page=$page&pagesize=$pageSize";
    return "$server$api";
  }

  static String getUserApi(
      {String siteParam, TagType tagType, int page, int pageSize}) {
    assert(siteParam != null, "Site param cant be null");
    assert(tagType != null, "Tag type cant be null");

    String _type = describeEnum(tagType);
    String api =
        "/users?order=desc&sort=$_type&site=$siteParam&page=$page&pagesize=$pageSize";
    return "$server$api";
  }

  static String getUserApiById({String siteParam, String id}) {
    String filterCode = "!thDm6gCTW4FjbpCZ5Im-3cZ3UoBmyBm";
    assert(siteParam != null, "Site param cant be null");
    assert(id != null, "Tag type cant be null");
    String api =
        "/users/$id?order=desc&sort=reputation&site=$siteParam&filter=$filterCode";
    return "$server$api";
  }

  static String getUserInfoApiSE(String client_secret, String access_token) {
    assert(client_secret != null, "Client secret cant be null");
    assert(access_token != null, "Access token cant be null");
    String api =
        "/me?order=desc&sort=name&site=stackoverflow&key=$client_secret&access_token=${access_token}";
    return "$server$api";
  }

  static String getUserInfoApiFb(String accessToken) {
    String api = "https://graph.facebook.com/v7.0/me?access_token=$accessToken";
    return api;
  }

  static String getInvalidateSETokenAPi(String token) {
    String api =
        "https://api.stackexchange.com/2.2/access-tokens/$token/invalidate";
    return api;
  }

  static String getInvalidateFBTokenAPi(String token) {
    String api =
        "https://graph.facebook.com/v7.0/me/permissions?access_token=$token";
    return api;
  }
}
