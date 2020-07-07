import 'package:flutter_se/src/common/Site.dart';

enum SiteType {
  AllSites, //0
  MetaSites, //1
  MainSites //2
}

abstract class AllSiteState {
  SiteType siteType = SiteType.AllSites;
  List<Site> sites;
}

class Initializing extends AllSiteState {}

class Loading extends AllSiteState {}

class ReadyToDisplaySite extends AllSiteState {
  bool hasReachMax;
  ReadyToDisplaySite(List<Site> sites,
      {SiteType siteType, this.hasReachMax = false}) {
    this.sites = sites;
    if (siteType != null) {
      this.siteType = siteType;
    }
  }
}
