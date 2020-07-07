import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/DetailQuestionPage/LeftSection.dart';
import 'package:flutter_se/src/SitePage/UserItem.dart';
import 'package:flutter_se/src/common/Topic.dart';
import 'package:flutter_se/src/common/User.dart';

import 'DetailQuestionOptionsBar.dart';
import 'QuestionTitle.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';

class DetailQuestionItem extends StatelessWidget {
  final Topic question;
  final User user;
  final isComment;
  DetailQuestionItem({this.question, this.user, this.isComment});
  @override
  Widget build(BuildContext context) {
    return isComment ? buildComments() : buildQuestion();
  }

  buildQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Question title
        QuestionTitle(question: question),
        //Question body
        Html(data: question.body, customRender: {
          "code": (RenderContext context, child, attributes, e) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(color: Colors.grey[200], child: child),
            );
          },
        }),
        DetailQuestionOptionsBar(),
        UserItem(user),
        //            DetailQuestionComments()
      ],
    );
  }

  buildComments() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border.symmetric(
                  vertical: BorderSide(color: Colors.grey.withOpacity(0.3)))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LeftSection(
                question: question,
              ),
              Flexible(
                child: Html(data: question.body, customRender: {
                  "code": (RenderContext context, child, attributes, e) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(color: Colors.grey[200], child: child),
                    );
                  },
                }),
              ),
            ],
          ),
        ),
        UserItem(user),
        SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}
