import 'package:flutter/material.dart';

class StackExchangeLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Hero(
              child: Container(
                transform: Matrix4.translationValues(15, 0, 0),
                child: Image.asset(
                  "launcher.png",
                  height: 25,
                  width: 25,
                  color: Colors.brown,
                ),
              ),
              tag: "launcher",
            ),
            RichText(
              text: TextSpan(
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0),
                  text: "Stack",
                  children: [
                    TextSpan(
                        text: "Exchange",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ]),
            ),
            Text(
              'expert answer to your questions',
              style: TextStyle(color: Colors.brown),
            )
          ],
        ));
  }
}
