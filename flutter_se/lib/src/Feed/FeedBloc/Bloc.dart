import 'dart:math';

import 'package:flutter_se/src/AllSitePage/AllSiteBloc/State.dart';
import 'package:flutter_se/src/AppBloc/Bloc.dart';
import 'package:flutter_se/src/Feed/FeedBloc/Events.dart';
import 'package:flutter_se/src/Feed/FeedBloc/State.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_se/src/common/Site.dart';
import 'package:flutter_se/src/common/Topic.dart';
import '../TopicRows.dart';
import 'Repo.dart';
import "dart:developer" as console;

class FeedBloc extends Bloc<FeedEvents, FeedState> {
  FeedBloc(this.appBloc);
  final AppBloc appBloc;
  Repo repo;

  Map<String, Map<String, List<Topic>>> mapTopicByTime;

  @override
  FeedState get initialState => OnInitialize();

  void onFetchDataForFeedPage() {
    add(GetTopicsDataEvent());
  }

  void onLoadMore() {
    final currentState = state as OnLoaded;
    final postLabel = currentState.allTopicRows.last.label;
    bool hasReachedMax = false;
    int subtractedDay = 0;
    if (postLabel == "Earlier today") {
      subtractedDay = 1;
    } else if (postLabel == "Yesterday") {
      subtractedDay = 7;
    } else if (postLabel == "Earlier this week") {
      subtractedDay = 30;
    } else {
      subtractedDay = 365;
      hasReachedMax = true;
    }
    DateTime nextTime =
        DateTime.now().subtract(new Duration(days: subtractedDay));

    add(LoadMoreEvent(time: nextTime, hasReachedMax: hasReachedMax));
  }

  @override
  Stream<FeedState> mapEventToState(FeedEvents event) async* {
    console.log("Event is $event");
    repo = new Repo(allSites: appBloc.allSites);
    if (event is ErrorEvent) {
      yield OnError(event.error);
    }
    if (event is GetTopicsDataEvent) {
      yield OnInitialize();
      // if (state is OnInitialize) {
      //fetch for the first time
      Topic hotTopic = await repo.getHotTopic();
      if (hotTopic == null) {
        print("Hot topic is null");
        yield OnError("Hot topic is null");
        return;
      }
      print("Keep going");

      List<Topic> fullHotTopics = await repo.getFullHotTopic(
          appBloc.allSites
              .where((site) => site.getSiteType == "main_site")
              .take(20)
              .toList(),
          topicLength: 10);

      int timeToGet = convertUtcToSec(event.time);

      final List<List<Topic>> rows =
          await repo.getRowsOfTopics(5, time: timeToGet); //20 rows

      TopicRows topicRows = new TopicRows(rows, timeToGet);
      List<TopicRows> allTopicRows = new List<TopicRows>();
      allTopicRows.add(topicRows);

      yield OnLoaded(hotTopic, fullHotTopics, allTopicRows);
    }

    if (event is LoadMoreEvent && state is OnLoaded) {
      if ((state as OnLoaded).hasReachedMax) {
        return;
      }

      final currentState = state as OnLoaded;

//      Topic hotTopic = await repo.getHotTopic();
//      if (hotTopic == null) {
//        yield OnError("Hot Topic is null");
//        return;
//      }
      final int timeToGet = convertUtcToSec(event.time);

      final List<List<Topic>> rows =
          await repo.getRowsOfTopics(5, time: timeToGet); //20 rows

      final TopicRows allRows = new TopicRows(rows, timeToGet);

      List<TopicRows> newTopicRows = currentState.allTopicRows..add(allRows);

      yield OnLoaded(
          currentState.hotTopic, currentState.fullHotTopic, newTopicRows,
          hasReachedMax: event.hasReachedMax ?? false);
    }

    if (event is RefreshEvent && state is OnLoaded) {
      yield event.newState;
    }
  }

  int convertUtcToSec(DateTime dateTime) {
    if (dateTime == null) return null;
    int timeInSec = dateTime.millisecondsSinceEpoch ~/ 1000;
    return timeInSec;
  }

  void onRefresh(OnLoaded newState) {
    add(RefreshEvent(newState));
  }
}
