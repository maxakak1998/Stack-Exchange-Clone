import 'dart:developer';

import 'package:flutter_se/src/SitePage/SiteBloc/Events.dart';
import 'package:flutter_se/src/SitePage/SiteBloc/Repo.dart';
import 'package:flutter_se/src/SitePage/SiteBloc/State.dart';
import "package:bloc/bloc.dart";
import 'package:flutter_se/src/common/Site.dart';
import 'package:flutter_se/src/common/Topic.dart';
import 'package:flutter_se/src/common/User.dart';
import "package:rxdart/rxdart.dart";
import '../Tag.dart';

class SiteBloc extends Bloc<SiteEvent, SiteState> {
  SiteRepo repo;
  SiteBloc(this.repo);
  bool hasSearched = false;
  SiteState _oldState;
  @override
  SiteState get initialState => Initializing();
  @override
  Stream<Transition<SiteEvent, SiteState>> transformEvents(
      Stream<SiteEvent> events, transitionFn) {
    final loadMoreEvents = events
        .where((value) => value is LoadMoreEvent)
        .debounceTime(new Duration(milliseconds: 500))
        .distinct()
        .switchMap(transitionFn);

    final searchedEvents = events
        .where((value) => value is SearchingEvent)
        .debounceTime(new Duration(milliseconds: 500))
        .distinct((prev, current) =>
            (prev as SearchingEvent).searchingData.trim() ==
            (current as SearchingEvent).searchingData.trim())
        .switchMap(transitionFn);

    final normalEvents = events
        .where((value) => value is! SearchingEvent && value is! LoadMoreEvent)
        .asyncExpand(transitionFn);
    return searchedEvents.mergeWith([normalEvents, loadMoreEvents]);
  }

  @override
  Stream<SiteState> mapEventToState(SiteEvent event) async* {
    try {
      //fetch questions
      if (event is FetchAllQuestionsEvent) {
        List<Topic> topics =
            await repo.getTopicsBySite(event.site, tagType: event.tagType);

        assert(topics != null, "Can't get the list, list is null");
        yield AllQuestionsLoaded(topics);
      }

      //fetch tags
      if (event is FetchAllTagEvents) {
        List<Tag> tags = await repo.fetchTags(event.tagType, event.siteParam);
        yield AllTagsLoaded(
          tags,
        );
      }

      //fetch users
      if (event is FetchAllUsersEvent) {
        List<User> users = await repo.fetchUsers(
            siteParam: event.siteParam, tagType: event.tagType);
        if (users.isEmpty) {
          log("List of user is empty, maybe it has reached max");
          return;
        }
        yield AllUsersLoaded(
          users,
        );
      }
      //search
      if (event is SearchingEvent) {
        log("Searching Event emits, tag type is ${event.tagType}, data is ${event.searchingData}");

        hasSearched = true;

        if (state is! Initializing) {
          _oldState = state;
        }
        yield Initializing();

        print("oldState is $_oldState");

        if (event.searchingData.isEmpty) {
          onFetchData(
              site: event.site,
              categorySite: _oldState.categorySite,
              tagType: event.tagType);
          return;
        }

        if (_oldState is AllQuestionsLoaded) {
          print("Searching ");
          List<Topic> topics = await repo.getSearchingDataByQuestion(
              site: event.site,
              categorySite: _oldState.categorySite,
              tagType: event.tagType,
              searchingData: event.searchingData);
          if (topics.length < 50) {
            yield AllQuestionsLoaded(topics, hasReachedMax: true);
            print("Has reached max");
          } else {
            yield AllQuestionsLoaded(topics);
          }
        } else if (_oldState is AllTagsLoaded) {
          List<Tag> tags = await repo.getSearchingDataByTag(
              site: event.site,
              categorySite: _oldState.categorySite,
              tagType: event.tagType,
              searchingData: event.searchingData);

          if (tags.length < 50) {
            yield AllTagsLoaded(tags, hasReachedMax: true);
          } else {
            yield AllTagsLoaded(tags);
          }
        }
      }

      //load more
      if (event is LoadMoreEvent) {
        if (state is AllQuestionsLoaded) {
          final oldState = state as AllQuestionsLoaded;
          if (oldState.hasReachedMax) {
            print("Has reached max");
            return;
          }
          //adjust param
          int oldLengthList =
              oldState.topics.length; //it is also the total of page size
          int newLengthList = oldLengthList + 20;

          int oldPageNumber = oldLengthList ~/ 100;
          int newPageNumber = oldPageNumber + 1; //increase 1 page

          int newPageSize =
              newLengthList % 100 != 0 ? newLengthList.remainder(100) : 100;

          //get the extended list
          List<Topic> extendedList;
          if (event.hasSearched) {
            newLengthList = oldLengthList + 50;
            oldPageNumber = oldLengthList ~/ 100;

            newPageNumber = oldPageNumber + 1;
            newPageSize =
                newLengthList % 100 != 0 ? newLengthList.remainder(100) : 100;

            extendedList = (await repo.getSearchingDataByQuestion(
                    site: event.site,
                    categorySite: state.categorySite,
                    pageSize: newPageSize,
                    pageNumber: newPageNumber,
                    tagType: event.tagType,
                    searchingData: event.searchingData))
                .getRange(oldLengthList % 100, newPageSize)
                .toList();
          } else {
            extendedList = (await repo.getTopicsBySite(event.site,
                    pageSize: newPageSize,
                    pageNumber: newPageNumber,
                    tagType: event.tagType))
                .getRange(oldLengthList % 100, newPageSize)
                .toList();
          }

          assert(extendedList != null, "Can't load more, list is null");

          // if there are no items
          if (extendedList.isEmpty) {
            oldState.hasReachedMax = true;
            yield oldState;
            return;
          }
          //did success
          final List<Topic> fullList = oldState.topics
            ..insertAll(oldLengthList, extendedList);

          yield AllQuestionsLoaded(fullList);
        } else if (state is AllTagsLoaded) {
          List<Tag> extendedList;
          final oldState = state as AllTagsLoaded;
          if (oldState.hasReachedMax) {
            return;
          }
          //adjust param
          int oldLengthList =
              oldState.tags.length; //it is also the total of page size
          int newLengthList = oldLengthList + 50;

          int oldPageNumber = oldLengthList ~/ 100;
          int newPageNumber = oldPageNumber + 1; //increase 1 page

          int newPageSize =
              newLengthList % 100 != 0 ? newLengthList.remainder(100) : 100;
          if (event.hasSearched) {
            extendedList = (await repo.getSearchingDataByTag(
                    site: event.site,
                    categorySite: state.categorySite,
                    pageSize: newPageSize,
                    pageNumber: newPageNumber,
                    tagType: event.tagType,
                    searchingData: event.searchingData))
                .getRange(oldLengthList % 100, newPageSize)
                .toList();
          } else {
            extendedList = (await repo.fetchTags(
                    event.tagType, event.site.getParamAPI,
                    pageSize: newPageSize, page: newPageNumber))
                .getRange(oldLengthList % 100, newPageSize)
                .toList();
          }
          //get the extended list

          assert(extendedList != null, "Can't load more, list is null");

          // if there are no items
          if (extendedList.isEmpty) {
            oldState.hasReachedMax = true;
            yield oldState;
            return;
          }
          //did success
          final List<Tag> fullList = oldState.tags
            ..insertAll(oldLengthList, extendedList);

          yield AllTagsLoaded(fullList);
        } else if (state is AllUsersLoaded) {
          final oldState = state as AllUsersLoaded;
          //adjust param
          int oldLengthList =
              oldState.users.length; //it is also the total of page size
          int newLengthList = oldLengthList + 50;

          int oldPageNumber = oldLengthList ~/ 100;
          int newPageNumber = oldPageNumber + 1; //increase 1 page

          int newPageSize =
              newLengthList % 100 != 0 ? newLengthList.remainder(100) : 100;

          List<User> extendedList = (await repo.fetchUsers(
                  tagType: event.tagType,
                  siteParam: event.site.getParamAPI,
                  pageSize: newPageSize,
                  page: newPageNumber))
              .getRange(oldLengthList % 100, newPageSize)
              .toList();

          assert(extendedList != null, "Can't load more, list is null");

          // if there are no items
          if (extendedList.isEmpty) {
            oldState.hasReachedMax = true;
            yield oldState;
            return;
          }
          //did success
          final List<User> fullList = oldState.users
            ..insertAll(oldLengthList, extendedList);

          yield AllUsersLoaded(fullList);
        }
      }

      if (event is SiteChanging) {
        yield Initializing();
        yield SiteChanged(event.categorySite, tagType: event.tagType);

        onFetchData(
            site: event.site,
            tagType: event.tagType,
            categorySite: event.categorySite);
      }
    } catch (e) {
      yield Error("Error is ${e.toString()}");
    }
  }

  void onFetchData({Site site, TagType tagType, CategorySite categorySite}) {
    String siteParam = site.getParamAPI;
    if (categorySite == CategorySite.Questions) {
      add(FetchAllQuestionsEvent(
          site: site, tagType: tagType ?? TagType.Active));
    } else if (categorySite == CategorySite.Tags) {
      add(FetchAllTagEvents(
          tagType: tagType ?? TagType.Popular, siteParam: siteParam));
    } else if (categorySite == CategorySite.Users) {
      add(FetchAllUsersEvent(
          siteParam: siteParam, tagType: tagType ?? TagType.Reputation));
    }
  }

  void onLoadMore(Site site, TagType tagType, String searchingData) {
    add(LoadMoreEvent(site,
        tagType: tagType,
        hasSearched: hasSearched,
        searchingData: searchingData));
  }

  void onSiteChanging({TagType tagType, CategorySite categorySite, Site site}) {
    hasSearched = false;
    add(SiteChanging(categorySite: categorySite, tagType: tagType, site: site));
  }

  void onTagTypeChange(TagType tagType, Site site, CategorySite categorySite) {
    // onSiteCategoryChange(
    //     categorySite: categorySite, site: site, tagType: tagType);
  }

  void onSearchSearching(TagType tagType, String searchingData, Site site) {
    add(SearchingEvent(
        tagType: tagType, searchingData: searchingData, site: site));
  }
}
