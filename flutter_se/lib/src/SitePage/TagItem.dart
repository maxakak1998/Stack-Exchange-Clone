import 'package:flutter/material.dart';
import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';

class TagItem extends StatelessWidget {
  String tag;
  int tagCount;
  String formattedTagCount;

  TagItem(this.tag, this.tagCount) {
    calculateTagCount(tagCount);
  }
  void calculateTagCount(int tagCount) {
    int thousand = 999999;
    int million = 9999999;
    if (tagCount < thousand) {
      tagCount = tagCount ~/ 1000;
      formattedTagCount = tagCount.toString() + "k";
    } else if (tagCount > thousand && tagCount <= million) {
      formattedTagCount = (tagCount / 1000000).toStringAsFixed(1) + "m";
    } else {
      formattedTagCount = tagCount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle =
        TextStyle(color: Color.fromRGBO(0, 51, 153, 0.8), fontSize: 12.0);
    return Container(
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 0.5, color: Colors.black.withOpacity(0.3)),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(230, 255, 255, 0.4),
                border: Border.all(
                  width: 0.2,
                  color: Colors.black.withOpacity(0.3),
                )),
            child: Text(tag ?? "Default", style: textStyle),
          ),
          Text(
            formattedTagCount,
            style: textStyle,
          )
        ],
      ),
    );
  }
}
