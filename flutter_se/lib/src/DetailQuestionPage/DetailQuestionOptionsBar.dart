import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';

class DetailQuestionOptionsBar extends StatelessWidget {
  final List<String> strings = ["Favorite", "Suggest edit", "Share", "More"];
  final FavouriteIcon = Icon(Icons.star, size: 18, color: Colors.grey);
  final SuggestEditIcon = Icon(Icons.edit, size: 18, color: Colors.grey);
  final ShareIcon = Icon(Icons.share, size: 18, color: Colors.grey);
  final MoreIcon = Icon(Icons.more_horiz, size: 18, color: Colors.grey);
  @override
  Widget build(BuildContext context) {
    final width = dimensionHelper(context).width;
    return Container(
      decoration: BoxDecoration(
          border:
              Border.symmetric(vertical: BorderSide(color: Colors.grey[300]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: strings.map((label) {
          Icon icon;
          switch (label) {
            case "Favorite":
              icon = FavouriteIcon;
              break;
            case "Suggest edit":
              icon = SuggestEditIcon;
              break;
            case "Share":
              icon = ShareIcon;
              break;
            case "More":
              icon = MoreIcon;
              break;
          }
          return DetailQuestionOptionsBarItem(
            height: 40,
            labelText: label,
            icon: icon,
          );
        }).toList(),
      ),
    );
  }
}

class DetailQuestionOptionsBarItem extends StatelessWidget {
  final String labelText;
  final Function onPress;
  final Icon icon;
  final double height;
  DetailQuestionOptionsBarItem(
      {this.labelText, this.icon, this.onPress, this.height});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPress ?? () {},
        child: Container(
          margin: EdgeInsets.all(6.0),
          alignment: Alignment.center,
          height: height,
          child: Row(
            children: <Widget>[
              icon,
              SizedBox(
                width: 8,
              ),
              Text(
                labelText,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ));
  }
}
