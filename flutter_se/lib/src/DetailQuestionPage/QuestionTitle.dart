import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/DetailQuestionPage/LeftSection.dart';
import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/Topic.dart';

class QuestionTitle extends StatelessWidget {
  final Topic question;
  QuestionTitle({this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimensionHelper(context).width,
      decoration: new BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black.withOpacity(0.1)))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Left section
          LeftSection(
            question: question,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Title
                Text(
                  question.topicTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColor.linkColor,
                      fontSize: 18.0),
                ),
                SizedBox(
                  height: 8.0,
                ),
                //Tags = > tags.map
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 4.0,
                  children: _buildTags(question.tags),
                ),
                SizedBox(
                  height: 4.0,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildTags(List<String> tags) {
    return tags
        .map<Widget>((tag) => Container(
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(
                      color: Colors.black.withOpacity(0.3), width: 1)),
              padding: EdgeInsets.all(3.0),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 10.0,
                ),
              ),
            ))
        .toList();
  }
}
