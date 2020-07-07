import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/DetailQuestionPage/DetailQuestionBloc/State.dart';
import 'package:flutter_se/src/DetailQuestionPage/DetailQuestionItem.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/LoadingPage.dart';
import 'package:flutter_se/src/common/Topic.dart';
import 'package:webview_flutter/webview_flutter.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'DetailQuestionBloc/Bloc.dart';
import 'DetailQuestionOptionsBar.dart';
import 'QuestionTitle.dart';

const String html =
    "<p>This might be an easy one, but as a beginner I'm currently stuck. I tried the <strong>tempArray[i] = inputTemp;</strong> but it didn't seem to store the value properly when printing the list. Any ideas?</p>\n\n<pre><code>        foreach (int i in tempArray)\n        {\n            Console.WriteLine(\"Enter a value\");\n            double inputTemp = Convert.ToDouble(Console.ReadLine());\n            tempArray[i] = inputTemp;\n        }\n        // Print out the array\n        foreach (double i in tempArray)\n        {\n            Console.WriteLine(i);\n        }\n</code></pre>\n";

class DetailQuestionPage extends StatefulWidget {
  static String routeName = "/DetailQuestionPage";
  final Topic topic;

  DetailQuestionPage({this.topic});

  static Function routeBuilder = (BuildContext context, Topic topic) {
    return DetailQuestionPage(topic: topic);
  };

  @override
  _DetailQuestionPageState createState() => _DetailQuestionPageState();
}

class _DetailQuestionPageState extends State<DetailQuestionPage> {
  DetailQuestionBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = context.bloc<DetailQuestionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Stack overflow"),
        ),
        body: BlocConsumer<DetailQuestionBloc, DetailQuestionState>(
          listener: (BuildContext context, state) {
            if (state is Loaded) {
              widget.topic.owner = state.user;
              widget.topic.answers = state.answers;
            }
          },
          builder: (BuildContext context, state) {
            if (state is Initializing) {
              return LoadingPage();
            }
            if (state is Loaded) {
              return SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DetailQuestionItem(
                    user: state.user,
                    question: state.question,
                    isComment: false,
                  ),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    width: dimensionHelper(context).width,
                    child: Text(
                      state.answers.length.toString() + " answer(s)",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ...state.answers
                      .map((answer) => DetailQuestionItem(
                            question: answer,
                            user: answer.owner,
                            isComment: true,
                          ))
                      .toList()
                ],
              ));
            }
            return LoadingPage();
          },
        ));
  }
}
