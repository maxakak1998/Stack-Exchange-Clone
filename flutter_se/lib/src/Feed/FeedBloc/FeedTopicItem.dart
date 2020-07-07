import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/Topic.dart';

class FeedTopicItem extends StatelessWidget {
  Topic topic;
  int index;
  int length;
  FeedTopicItem(this.topic, this.index, this.length);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(topic.site.getIconUrl),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topLeft)),
                ),
                topic.isHot && index == 0
                    ? Positioned(
                        top: -5,
                        child: Image.asset(
                          "feed_hot.png",
                          height: 40,
                          width: 30,
                          fit: BoxFit.fill,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                renderTag(index, topic.isHot, length),
                SizedBox(
                  height: 4,
                ),
                Flexible(
                  child: Text(
                    topic.topicTitle,
                    style:
                        TextStyle(color: Colors.primaries[4], fontSize: 18.0),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                    width: dimensionHelper(context).width * 0.8,
                    child: Wrap(
                        children: topic.tags
                            .map<Widget>((item) => item != topic.tags.last
                                ? Text(
                                    item + ", ",
                                    style: (TextStyle(fontSize: 12.0)),
                                  )
                                : Text(
                                    item + ".",
                                    style: (TextStyle(fontSize: 12.0)),
                                  ))
                            .toList()))
              ],
            ),
          )
        ]);
  }
}

Widget renderTag(int index, bool isHot, int length) {
  if (index == 0) {
    if (isHot) {
      return Text(
        "$length hot",
        style: TextStyle(color: Colors.grey, fontSize: 16),
      );
    } else {
      return Text(
        "$length unanswered",
        style: TextStyle(color: Colors.grey, fontSize: 16),
      );
    }
  }
  return SizedBox();
}
