import 'dart:developer';
import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/Service.dart';
import 'package:flutter_se/src/common/Site.dart';
import 'package:flutter_se/src/common/Topic.dart';

import 'AllHotQuestionPage/AllHotQuestionPage.dart';

class HotTopicItem extends StatelessWidget {
  Site site;
  Topic topic;
  Color hotTopicBackgroundColor;
  List<Topic> allHotQuestions;
  HotTopicItem(this.site, this.topic, this.allHotQuestions,
      {this.hotTopicBackgroundColor = Colors.cyanAccent});

  final textSize = 16.0;

  @override
  Widget build(BuildContext context) {
    bool isTooDark =
        hotTopicBackgroundColor.computeLuminance() < 0.5 ? true : false;
    final textColor = isTooDark ? Colors.white : Colors.black;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 8.0),
          color: hotTopicBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: site.getIcon,
                    transform: Matrix4.translationValues(-5, 0, 0),
                  ),
                  Flexible(
                    child: Text(
                      site.getName,
                      style: TextStyle(fontSize: textSize, color: textColor),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12.0),
              Wrap(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: topic.topicTitle + "\n",
                        style: TextStyle(color: textColor, fontSize: textSize),
                        children: [
                          TextSpan(
                              text: "- Asked by ",
                              style: TextStyle(
                                  color: textColor, fontSize: textSize)),
                          TextSpan(
                            text: topic.owner.userName + " ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: textSize),
                          ),
                          TextSpan(
                              text: Service.getTimeDiff(topic.creationDate),
                              style: TextStyle(
                                  color: textColor, fontSize: textSize)),
                        ]),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: dimensionHelper(context).width * 0.6,
                      child: Wrap(
                        runSpacing: 8.0,
                        spacing: 8.0,
                        children: topic.tags
                            .map<Widget>((item) => Container(
                                padding: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.2,
                                        color: textColor.withOpacity(0.6))),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      color: textColor.withOpacity(0.5)),
                                )))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                "feed_hot.png",
                                fit: BoxFit.fill,
                                height: 33,
                                width: 32,
                                color: Colors.red,
                              ),
                              Text(
                                "hot",
                                style: TextStyle(
                                    color: textColor, fontSize: textSize - 4),
                              )
                            ],
                          ),
                          SizedBox(width: 12.0),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                "answers.png",
                                fit: BoxFit.fill,
                                height: 25,
                                width: 18,
                                color: textColor,
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Text(topic.answerCount.toString(),
                                  style: TextStyle(
                                      color: textColor, fontSize: textSize - 4))
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(AllHotQuestionPage.routeName,
                arguments: allHotQuestions);
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 8.0),
            alignment: Alignment.centerLeft,
            height: 60,
            constraints:
                BoxConstraints(minWidth: 500, maxWidth: 600, maxHeight: 60),
            decoration: BoxDecoration(
                color: hotTopicBackgroundColor,
                border: Border(
                    top: BorderSide(
                        width: 1.0, color: textColor.withOpacity(0.6)))),
            child: Text(
              "View more hot questions",
              style: TextStyle(color: textColor),
            ),
          ),
        )
      ],
    );
  }
}
