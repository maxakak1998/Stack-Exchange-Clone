import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_se/src/common/User.dart';

class UserItem extends StatelessWidget {
  final User user;
  UserItem(this.user);
  @override
  Widget build(BuildContext context) {
    final userAvatar = Image.network(
      user.profileImageUrl,
      height: 30,
      fit: BoxFit.fill,
      width: 30,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;

        return Center(
          child: CircularProgressIndicator(
              value: loadingProgress != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null),
        );
      },
    );
    final userName = Text(
      user.userName,
      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    );
    final reputation = Text(user.reputation.toString());
    final goldCount = Text(user.badge.gold.toString());
    final bronzeCount = Text(user.badge.bronze.toString());
    final silverCount = Text(user.badge.sliver.toString());
    final badgeIcon = (String iconName, {Color backgroundColor}) => Image.asset(
          iconName,
          height: 10,
          width: 10,
          fit: BoxFit.fill,
          color: backgroundColor,
        );
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
      padding: EdgeInsets.all(6.0),
      child: Row(
        children: <Widget>[
          userAvatar,
          SizedBox(
            width: 6.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              userName,
              Row(
                children: <Widget>[
                  reputation,
                  SizedBox(
                    width: 6.0,
                  ),
                  badgeIcon("badge_gold.png"),
                  SizedBox(
                    width: 2.0,
                  ),
                  goldCount,
                  SizedBox(
                    width: 6.0,
                  ),
                  badgeIcon("badge_bronze.png"),
                  SizedBox(
                    width: 2.0,
                  ),
                  bronzeCount,
                  SizedBox(
                    width: 6.0,
                  ),
                  badgeIcon("badge_silver.png", backgroundColor: Colors.red),
                  SizedBox(
                    width: 2.0,
                  ),
                  silverCount
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
