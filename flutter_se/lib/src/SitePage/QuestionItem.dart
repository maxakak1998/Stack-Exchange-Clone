import 'package:flutter/material.dart';
import 'package:flutter_se/src/DetailQuestionPage/DetailQuestionPage.dart';
import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/Service.dart';
import 'package:flutter_se/src/common/Topic.dart';

class SiteQuestionItem extends StatefulWidget {
  final Topic topic;
  SiteQuestionItem(this.topic);

  @override
  _SiteQuestionItemState createState() => _SiteQuestionItemState();
}

class _SiteQuestionItemState extends State<SiteQuestionItem> {
  final textSize = 16.0;
  int scoreLength;
  double scoreSize;
  Color commentColor;

  int commentLength;
  double commentSize;

  @override
  void initState() {
    super.initState();
    scoreLength = widget.topic.topicScore.toString().length;
    scoreSize = scoreLength > 3 ? 10.0 : 14.0;

    commentLength = widget.topic.answerCount.toString().length;
    commentSize = scoreLength > 3 ? 10.0 : 14.0;

    commentColor = widget.topic.answerCount > 0 ? Colors.green : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final height = dimensionHelper(context).height;
    final width = dimensionHelper(context).width;
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border:
              Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
      // color: Colors.blue,

      child: Row(
        children: <Widget>[
          Container(
            width: width * 0.15,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.topic.topicScore.toString(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: scoreSize),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Image.asset(
                      "feed_rep.png",
                      height: 15,
                      width: 13,
                      fit: BoxFit.fill,
                      color: Colors.grey,
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.topic.answerCount.toString(),
                        style: TextStyle(
                            color: commentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: commentSize)),
                    SizedBox(
                      width: 6,
                    ),
                    Image.asset("answers.png",
                        color: commentColor,
                        height: 22,
                        width: 15,
                        fit: BoxFit.fill)
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  print("A");
                  Navigator.of(context).pushNamed(DetailQuestionPage.routeName,
                      arguments: widget.topic);
                },
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.topic.topicTitle,
                          style: TextStyle(
                              fontSize: textSize, color: AppColor.linkColor),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: width * 0.6,
                                child: Wrap(
                                  children: widget.topic.tags
                                      .map<Widget>((tag) =>
                                          tag == widget.topic.tags.last
                                              ? Text(
                                                  tag,
                                                  style: TextStyle(
                                                      fontSize: textSize - 3,
                                                      color: Colors.grey),
                                                )
                                              : Text(tag + ", ",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: textSize - 3)))
                                      .toList(),
                                ),
                              ),
                              Text(
                                  Service.getTimeDiff(
                                      widget.topic.creationDate),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: textSize - 3))
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
