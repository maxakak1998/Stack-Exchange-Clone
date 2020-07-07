import 'package:flutter/material.dart';
import 'package:flutter_se/src/Feed/TopicRows.dart';
import 'package:flutter_se/src/common/Topic.dart';

abstract class FeedState {
  Color topicHotColor;
}

class OnInitialize extends FeedState {}

class OnLoading extends FeedState {}

class OnLoaded extends FeedState {
  bool hasReachedMax;

  Topic hotTopic;
  List<TopicRows> allTopicRows;
  List<Topic> fullHotTopic;
  OnLoaded(this.hotTopic, this.fullHotTopic, this.allTopicRows,
      {this.hasReachedMax = false});
}

class OnError extends FeedState {
  String error;

  OnError(this.error);
}

class SignInOut extends FeedState {}
