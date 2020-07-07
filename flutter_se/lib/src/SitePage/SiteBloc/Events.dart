import 'package:flutter_se/src/common/Site.dart';

abstract class SiteEvent {}

enum TagType {
  Popular,
  Name,
//Users
  Reputation,
  Creation,
  //Name -> It is duplicated with Tags
  Active,
  Newest,
  Hot,
  Votes,
  UnAnswerTags,
  UnAnswerNewest
}
enum CategorySite { Questions, Tags, Users }

class FetchAllQuestionsEvent extends SiteEvent {
  // Site site;
  TagType tagType;
  Site site;

  CategorySite categorySite;
  FetchAllQuestionsEvent({this.tagType = TagType.Active, this.site})
      : categorySite = CategorySite.Tags,
        assert(tagType != null, "Tag type cant be null"),
        assert(site != null, "Site name cant be null");
}

class LoadMoreEvent extends SiteEvent {
  Site site;
  TagType tagType;
  bool hasSearched;
  String searchingData;
  LoadMoreEvent(this.site,
      {this.tagType, this.hasSearched = false, this.searchingData})
      : assert(site != null, "Site can not be null");
}

class FetchAllTagEvents extends SiteEvent {
  TagType tagType;
  String siteParam;
  CategorySite categorySite;
  FetchAllTagEvents(
      {this.tagType = TagType.Popular, this.siteParam = "stackoverflow"})
      : categorySite = CategorySite.Tags,
        assert(tagType != null, "Tag type cant be null"),
        assert(siteParam != null, "Site name cant be null");
}

class SiteChanging extends SiteEvent {
  Site site;
  CategorySite categorySite;
  TagType tagType;

  SiteChanging({this.categorySite, this.tagType, this.site}) {
    assert(categorySite != null, "Category site cant be null ");
  }
}

class FetchAllUsersEvent extends SiteEvent {
  TagType tagType;
  String siteParam;
  CategorySite categorySite;
  FetchAllUsersEvent({this.tagType = TagType.Reputation, this.siteParam})
      : categorySite = CategorySite.Users;
}

class SearchingEvent extends SiteEvent {
  TagType tagType;
  String searchingData;
  Site site;
  SearchingEvent({this.tagType, this.searchingData, this.site})
      : assert(tagType != null, "Tag type cant be null"),
        assert(searchingData != null, "Searching data cant be null");
}
