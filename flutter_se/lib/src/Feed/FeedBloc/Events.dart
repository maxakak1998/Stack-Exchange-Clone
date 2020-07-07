import 'package:flutter_se/src/Feed/FeedBloc/State.dart';

abstract class FeedEvents {}

class GetTopicsDataEvent extends FeedEvents {
  DateTime time;
  GetTopicsDataEvent({this.time});
}

class ErrorEvent extends FeedEvents {
  String error;

  ErrorEvent(this.error);
}

class LoadMoreEvent extends FeedEvents {
  DateTime time;
  bool hasReachedMax;
  LoadMoreEvent({this.time, this.hasReachedMax = false});
}

class RefreshEvent extends FeedEvents {
  OnLoaded newState;

  RefreshEvent(this.newState);
}
