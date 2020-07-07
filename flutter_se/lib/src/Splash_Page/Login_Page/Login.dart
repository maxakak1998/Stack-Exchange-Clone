import 'dart:developer';
import 'package:flutter_se/src/Splash_Page/SplashBloc/Bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/StackExchangeLogo.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import "package:flutter_bloc/flutter_bloc.dart";

class Login extends StatefulWidget {
  final String title = "Login";
  final FACEBOOK_TYPE = 0;
  final STACK_EXCHANGE_TYPE = 1;
  final GOOGLE_TYPE = 2;
  final OPENID_TYPE = 3;
  static String routeName = "/Login";
  static WidgetBuilder routeBuilder = (BuildContext context) {
    return Login();
  };
  @override
  _LoginState createState() => _LoginState();
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
    case 3:
      return Image.asset(
        "openid.png",
        fit: BoxFit.fill,
        width: 30.0,
        height: 30.0,
      );
      break;
  }
  return null;
};

class _LoginState extends State<Login> {
  SplashBloc _splashBloc;
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

  void _onLoginWithGoogle() async {
    _splashBloc.onSingInWithGoogle();
  }

  void _onLoginWithFb() async {
    final facebookLogin = FacebookLogin();

    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _splashBloc.onSingInWithFacebook();
        break;
      case FacebookLoginStatus.cancelledByUser:
        log("Cancel");
        break;
      case FacebookLoginStatus.error:
        log(result.errorMessage.toString());
        break;
    }
  }

  void _onLoginWithStackExchange() async {
    _splashBloc.onSingInWithStackExchange(context);
  }

  @override
  void initState() {
    super.initState();
    _splashBloc = context.bloc<SplashBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.splashPageBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.appBarColor,
        title: Text(widget.title),
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
                onPressed: _onLoginWithGoogle,
                typeIcon: widget.GOOGLE_TYPE,
                label: "Sign in with google",
                labelColor: Colors.black,
                width: 190,
                textSize: 14.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Divider(
                  color: Colors.purple,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "or",
                  style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink),
                ),
              ),
              Expanded(
                  child: Divider(
                color: Colors.purple,
              )),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          createLogInRaisedButton(context,
              onPressed: _onLoginWithFb,
              typeIcon: widget.FACEBOOK_TYPE,
              label: "Log in using Facebook",
              backgroundButton: Colors.indigoAccent,
              labelColor: Colors.white,
              height: 50,
              width: dimensionHelper(context).width * 0.85,
              textSize: 16.0),
          SizedBox(
            height: 13.0,
          ),
          createLogInRaisedButton(context,
              onPressed: _onLoginWithStackExchange,
              backgroundButton: Colors.blue,
              typeIcon: widget.STACK_EXCHANGE_TYPE,
              label: "Log in using Stack Exchange",
              labelColor: Colors.white,
              textSize: 16.0,
              height: 50,
              width: dimensionHelper(context).width * 0.85),
          SizedBox(
            height: 13.0,
          ),
          createLogInRaisedButton(context,
              backgroundButton: Colors.orangeAccent,
              typeIcon: widget.OPENID_TYPE,
              label: "Log in using another OpenID",
              labelColor: Colors.white,
              textSize: 16.0,
              height: 50,
              width: dimensionHelper(context).width * 0.85)
        ]),
      ),
    );
  }
}
