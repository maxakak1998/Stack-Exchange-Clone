import 'package:flutter/material.dart';
import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/Topic.dart';

class AllHotQuestionPage extends StatelessWidget {
  static String routeName = "/AllHotQuestionPage";
  final List<Topic> hotQuestions;
  final double textTitleSize = 18.0;

  final double padding = 8.0;
  AllHotQuestionPage(this.hotQuestions);
  static Function routeBuilder =
      (BuildContext context, List<Topic> hotQuestions) {
    return AllHotQuestionPage(hotQuestions);
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hot Questions"),
        backgroundColor: AppColor.appBarColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: ListView.separated(
            itemBuilder: _buildHotQuestionWidget,
            separatorBuilder: (context, i) => const Divider(),
            itemCount: hotQuestions.length),
      ),
    );
  }

  Widget _buildHotQuestionWidget(BuildContext context, int index) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              hotQuestions[index].site.getIcon,
              SizedBox(
                width: 8.0,
              ),
              Flexible(
                child: Text(
                  hotQuestions[index].topicTitle,
                  style: TextStyle(color: Colors.blue, fontSize: textTitleSize),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              renderTags(hotQuestions[index].tags, context),
              Image.asset(
                "answers.png",
                fit: BoxFit.fill,
                height: 25,
                width: 18,
                color: Colors.black,
              ),
              SizedBox(
                width: 6.0,
              ),
              Text(
                hotQuestions[index].answerCount.toString(),
                style: TextStyle(fontSize: textTitleSize - 2),
              )
            ],
          )
        ],
      ),
    );
  }

  renderTags(List<String> tags, BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(5),
      width: dimensionHelper(context).width * 0.88 - padding * 2,
      child: Wrap(
        runSpacing: 8.0,
        spacing: 8.0,
        children: tags
            .map<Widget>((item) => Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.2, color: Colors.black.withOpacity(0.6))),
                child: Text(
                  item,
                  style: TextStyle(color: Colors.black.withOpacity(0.5)),
                )))
            .toList(),
      ),
    );
  }
}
