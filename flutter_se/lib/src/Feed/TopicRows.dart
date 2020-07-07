import 'package:flutter_se/src/common/Topic.dart';

class TopicRows {
  TopicRows(this.topicRows, this.time, {this.label}) {
    if (label == null) {
      if (time == null) {
        //if null, take the current time
        time = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
      }
      label = getTheLabelByTime(time);
    }
  }
  int time;
  List<List<Topic>> topicRows;
  String label;

  String getTheLabelByTime(int postTime) {
    int nowInSecs = new DateTime.now().millisecondsSinceEpoch ~/ 1000;

    int difInSecs = nowInSecs - postTime;

    int difInHours = difInSecs ~/ 3600;

    if (difInHours >= 0) if (difInHours <= 12) {
      return "Earlier today";
    } else if (difInHours > 12 && difInHours <= 24) {
      return "Yesterday";
    } else if (difInHours > 24 && difInHours <= 24 * 7) {
      return "Earlier this week";
    } else if (difInHours > 24 * 7 && difInHours <= 24 * 7 * 30) {
      return "Earlier this month";
    } else {
      return "Earlier this year";
    }
    return "None";
  }
}
