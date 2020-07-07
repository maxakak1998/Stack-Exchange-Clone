import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/common/Colors.dart';

class StickyHeaderItem extends StatelessWidget {
  String label;
  StickyHeaderItem(this.label);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(6.0),
      alignment: Alignment.centerLeft,
      height: 30,
      width: double.infinity,
      color: AppColor.stickyHeaderColor,
      child: Text(
        label,
        style: TextStyle(
            color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
      ),
    );
  }
}
