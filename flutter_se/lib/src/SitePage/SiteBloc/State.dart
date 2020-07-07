import 'package:flutter_se/src/common/Topic.dart';
import 'package:flutter_se/src/common/User.dart';

import '../Tag.dart';
import 'Events.dart';

abstract class SiteState {
  List<TagType> tagTypes = [
    TagType.Active,
    TagType.Newest,
    TagType.Hot,
    TagType.Votes,
    // TagType.UnAnswerTags,
    TagType.UnAnswerNewest
  ];
  CategorySite categorySite = CategorySite.Questions;
}

class Initializing extends SiteState {}

class AllQuestionsLoaded extends SiteState {
  List<Topic> topics;

  bool hasReachedMax;
  AllQuestionsLoaded(this.topics, {this.hasReachedMax = false}) {
    categorySite = CategorySite.Questions;
    assert(hasReachedMax != null, "hasReachedMax property cant not be null");
    assert(topics != null, "List of topic cant not be null");
  }
  @override
  set categorySite(CategorySite _categorySite) {
    super.categorySite = _categorySite;
  }
}

class AllTagsLoaded extends SiteState {
  List<Tag> tags;
  bool hasReachedMax;
  // TagType tagType;
  AllTagsLoaded(this.tags, {this.hasReachedMax = false}) {
    categorySite = CategorySite.Tags;
    assert(hasReachedMax != null, "hasReachedMax property cant not be null");
    assert(tags != null, "List of tag  cant not be null");
  }
  @override
  set categorySite(CategorySite _categorySite) {
    super.categorySite = _categorySite;
  }
}

class SiteChanged extends SiteState {
  CategorySite categorySite;
  TagType tagType;

  List<TagType> _questionTypes = [
    TagType.Active,
    TagType.Newest,
    TagType.Hot,
    TagType.Votes,
    // TagType.UnAnswerTags,
    TagType.UnAnswerNewest
  ];
  List<TagType> _tagTypes = [TagType.Popular, TagType.Name];
  List<TagType> _userTypes = [
    TagType.Reputation,
    TagType.Name,
    TagType.Creation
  ];

  SiteChanged(this.categorySite, {this.tagType = TagType.Active}) {
    assert(categorySite != null, "Category site cant be null ");
    if (this.categorySite == CategorySite.Questions) {
      this.tagTypes = _questionTypes;
    } else if (this.categorySite == CategorySite.Tags) {
      this.tagTypes = _tagTypes;
    } else {
      this.tagTypes = _userTypes;
    }
    this.tagType ??= this.tagTypes.first;
  }
}

class Error extends SiteState {
  String error;

  Error(this.error);
}

class AllUsersLoaded extends SiteState {
  List<User> users;
  bool hasReachedMax;
  AllUsersLoaded(this.users, {this.hasReachedMax = false}) {
    categorySite = CategorySite.Users;
    assert(users != null, "List of user cant be null");
    assert(hasReachedMax != null, "hasReachedMax cant be null");
  }
  @override
  set categorySite(CategorySite _categorySite) {
    super.categorySite = _categorySite;
  }
}
