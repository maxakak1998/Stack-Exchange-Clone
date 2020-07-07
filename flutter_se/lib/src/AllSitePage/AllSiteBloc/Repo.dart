import 'dart:developer';

import 'package:flutter_se/src/common/Service.dart';
import 'package:flutter_se/src/common/Site.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;

class Repo {
  Future<List<Site>> getSites(int page, int pageSize) async {
    String api = Service.getAllSiteApi(page: page, pageSize: pageSize);

    try {
      final http.Response response = await http.get(api);
      final List<Site> sites =
          ((convert.jsonDecode(response.body)["items"]) as List<dynamic>)
              .map(
                (item) => new Site(
                    item["name"], item["high_resolution_icon_url"],
                    description: item['audience'],
                    siteType: item["site_type"],
                    paramAPI: item['api_site_parameter']),
              )
              .toList(growable: true);
      log("Sites is ${sites != null}");
      return sites;
    } catch (e) {
      log("Error: $e");
      return null;
    }
  }
}
