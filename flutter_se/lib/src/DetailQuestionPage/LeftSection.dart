import 'package:flutter/material.dart';
import 'package:flutter_se/src/common/Topic.dart';

class LeftSection extends StatelessWidget {
  final Topic question;
  const LeftSection({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0, top: 16.0),
      margin: EdgeInsets.only(right: 8.0),
      decoration: new BoxDecoration(
          border:
              Border(right: BorderSide(color: Colors.black.withOpacity(0.1)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 25,
            width: 25,
            decoration: new BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_drop_up,
              color: Colors.white,
              size: 25,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            question.topicScore.toString(),
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600]),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            height: 25,
            width: 25,
            decoration: new BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_drop_down,
              size: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
