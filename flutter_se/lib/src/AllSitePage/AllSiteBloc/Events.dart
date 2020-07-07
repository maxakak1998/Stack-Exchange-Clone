import 'package:flutter_se/src/AllSitePage/AllSiteBloc/State.dart';

abstract class AllSiteEvent {}

class GetSitesEvent extends AllSiteEvent {
  GetSitesEvent({SiteType type});
}

class LoadMoreEvent extends AllSiteEvent {}

class ChangeSiteTypeEvent extends AllSiteEvent {
  SiteType type;
  ChangeSiteTypeEvent(this.type);
}

class SearchSiteEvent extends AllSiteEvent {
  String siteName;
  SearchSiteEvent(String siteName) {
    this.siteName = siteName.trim().toLowerCase();
  }
}
