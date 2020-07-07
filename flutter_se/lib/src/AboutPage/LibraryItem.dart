import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/common/Colors.dart';

import 'Library.dart';

class LibraryItem extends StatelessWidget {
  final Library library;

  LibraryItem(this.library);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(
            library.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          subtitle: Container(
            margin: EdgeInsets.only(left: 16.0, top: 6.0),
            child: RichText(
              text: TextSpan(
                  style: TextStyle(
                      color: Colors.black, height: 1.2, fontSize: 15.0),
                  text: "Publisher: ${library.publisher} \n",
                  children: [
                    TextSpan(text: "Website:\t"),
                    TextSpan(
                        text: library.website,
                        style: TextStyle(color: AppColor.linkColor))
                  ]),
            ),
          ),
        )
      ],
    );
  }
}
