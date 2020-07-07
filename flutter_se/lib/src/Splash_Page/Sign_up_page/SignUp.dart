import 'package:flutter/material.dart';
import 'package:flutter_se/src/Feed/FeedPage.dart';
import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/StackExchangeLogo.dart';

class SignUp extends StatefulWidget {
  final String title = "Sign up";
  final FACEBOOK_TYPE = 0;
  final STACK_EXCHANGE_TYPE = 1;
  final GOOGLE_TYPE = 2;

  static String routeName = "/SignUp";
  static WidgetBuilder routeBuilder = (BuildContext context) {
    return SignUp();
  };
  @override
  _SignUpState createState() => _SignUpState();
}

Widget createLogInRaisedButton(BuildContext context,
    {VoidCallback onPressed,
    double height,
    double width,
    label = "",
    double textSize = 18.0,
    @required int typeIcon,
    Color backgroundButton = Colors.white,
    Color labelColor = Colors.white}) {
  return Container(
    padding: EdgeInsets.all(2.0),
    height: height,
    width: width,
    child: RaisedButton.icon(
        color: backgroundButton,
        onPressed: () {
          onPressed();
        },
        icon: getIcon(typeIcon),
        label: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(fontSize: textSize, color: labelColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )),
  );
}

Function getIcon = (int type) {
  switch (type) {
    case 0:
      return Image.asset('facebook_icon.png',
          fit: BoxFit.fill, width: 30.0, height: 30.0);
      break;
    case 1:
      return Image.asset(
        'launcher.png',
        fit: BoxFit.fill,
        width: 30.0,
        height: 30.0,
      );
      break;
    case 2:
      return Image.asset(
        "common_google_signin_btn_icon_light_normal.9.png",
        fit: BoxFit.fill,
        width: 30.0,
        height: 30.0,
      );
      break;
  }
  return null;
};

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.splashPageBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.appBarColor,
        title: Text(
          widget.title,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          Center(
            child: StackExchangeLogo(),
          ),
          SizedBox(
            height: dimensionHelper(context).height * 0.07,
          ),
          Center(
            child: createLogInRaisedButton(context,
                typeIcon: widget.GOOGLE_TYPE,
                label: "Sign in with google",
                labelColor: Colors.black,
                width: 190,
                textSize: 14.0),
          ),
          SizedBox(
            height: 18.0,
          ),
          createLogInRaisedButton(context,
              typeIcon: widget.FACEBOOK_TYPE,
              label: "Sign up using Facebook",
              backgroundButton: Colors.indigo,
              labelColor: Colors.white,
              height: 50,
              width: dimensionHelper(context).width * 0.85,
              textSize: 16.0),
          SizedBox(
            height: 18.0,
          ),
          createLogInRaisedButton(context, onPressed: () {
            // Navigator.pushNamed(context, FeedPage.routeName);
          },
              backgroundButton: Colors.blue,
              typeIcon: widget.STACK_EXCHANGE_TYPE,
              label: "Sign up using Stack Exchange",
              labelColor: Colors.white,
              textSize: 16.0,
              height: 50,
              width: dimensionHelper(context).width * 0.85),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    text: "By signing up, you agree to the ",
                    children: [
                      TextSpan(
                          text: "privacy \n policy ",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.deepOrange)),
                      TextSpan(text: "and "),
                      TextSpan(
                          text: "terms of service",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.deepOrange)),
                      TextSpan(text: ".")
                    ]),
              )
            ],
          ))
        ]),
      ),
    );
  }
}
