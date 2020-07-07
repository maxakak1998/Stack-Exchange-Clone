import 'package:flutter/material.dart';
import 'package:flutter_se/src/AppBloc/Bloc.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_se/src/AppBloc/State.dart';
import 'package:flutter_se/src/Feed/FeedPage.dart';
import 'package:flutter_se/src/SplashPage.dart';
import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/LoadingPage.dart';
import 'package:flutter_se/src/common/StackExchangeLogo.dart';

class LoadingLogin extends StatefulWidget {
  static String routeName = "/";
  static WidgetBuilder routeBuilder = (BuildContext context) {
    return LoadingLogin();
  };

  @override
  _LoadingLoginState createState() => _LoadingLoginState();
}

class _LoadingLoginState extends State<LoadingLogin> {
  AppBloc _appbloc;

  @override
  void initState() {
    super.initState();
    _appbloc = context.bloc<AppBloc>();
    print("ready to re-loading, access token is ${_appbloc.access_token}");

    if (_appbloc.access_token == null) {
      //just preloading when it is the first time
      print("pre loading");
      _appbloc.onPreLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed(FeedPage.routeName);
        } else if (state is UnAuthenticated) {
          Navigator.of(context).pushReplacementNamed(SplashPage.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.splashPageBackgroundColor,
          body: Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StackExchangeLogo(),
                SizedBox(
                  height: 24.0,
                ),
                LoadingPage(),
              ],
            ),
          ),
        );
      },
    );
  }
}
