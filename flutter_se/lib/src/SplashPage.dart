import 'dart:async';
import 'dart:developer';

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_se/src/AllSitePage/AllSitePage.dart';
import 'package:flutter_se/src/Splash_Page/AppManager.dart';
import 'package:flutter_se/src/Splash_Page/SplashBloc/Bloc.dart';
import 'package:flutter_se/src/common/LoadingPage.dart';
import 'AppBloc/Bloc.dart';
import 'Feed/FeedPage.dart';
import 'SettingPage/SettingPage.dart';
import 'Splash_Page/Login_Page/Login.dart';
import 'Splash_Page/Sign_up_page/SignUp.dart';
import 'Splash_Page/SplashBloc/Events.dart';
import 'Splash_Page/SplashBloc/State.dart';

class SplashPage extends StatefulWidget {
  static String routeName = "/SplashPage";
  static WidgetBuilder routeBuilder = (BuildContext context) {
    return SplashPage();
  };

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  bool hasInit = false;
  int translateDuration = 500;
  int opacityDuration = 1200;
  double opacity = 0.0;
  SplashBloc _splashBloc;
  AppBloc _appBloc;

  runAnimated() {
    new Future.delayed(new Duration(seconds: 1), () {
      setState(() {
        hasInit = true;
        opacity = 1.0;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _splashBloc = context.bloc<SplashBloc>();
    _appBloc = context.bloc<AppBloc>();
    if (mounted) {
      runAnimated();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget customButton(String title, VoidCallback onClicked) {
    return Container(
      height: 50.0,
      width: 150.0,
      child: RaisedButton(
        onPressed: onClicked,
        color: Colors.blue,
        child: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 5.0,
        textColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
//            floatingActionButton: FloatingActionButton(
//              onPressed: () async {
//                AppManager appManager = new AppManager();
//                final a = await appManager.firebaseApp.child("Students");
//                Map<String, dynamic> bc = Map()
//                  ..["id"] = 1
//                  ..["name"] = "Kiet";
//
//                final a = await appManager.firebaseApp
//                    .reference()
//                    .child("Students")
//                    .orderByChild("name")
//                    .startAt("Kiet")
//                    .endAt("Kiet 9")
//                    .once()
//                    .then((value) => print("${value.value}"));
//
//                for (var i = 0; i < 10; i++) {
//                  bc..["id"] = i + 1;
//                  await appManager.firebaseApp
//                      .reference()
//                      .child("Students")
//                      .child("Student ${i + 1}")
//                      .set(bc);
//                }
//              },
//            ),
            backgroundColor: Colors.amber,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                    child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Hero(
                      tag: "launcher",
                      child: Image.asset(
                        "assets/launcher.png",
                        width: 100,
                        height: 100,
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: translateDuration),
                      top: hasInit ? height / 3.7 : 0,
                      right: hasInit ? width / 3.5 : -50,
                      child: AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(milliseconds: opacityDuration),
                        child: Image.asset(
                          "assets/15.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                        duration: Duration(milliseconds: translateDuration),
                        top: hasInit ? height / 3.1 : 100,
                        right: hasInit ? width / 3.5 : -50,
                        child: AnimatedOpacity(
                          opacity: opacity,
                          duration: Duration(milliseconds: opacityDuration),
                          child: Image.asset(
                            "assets/16.png",
                            width: 40,
                            height: 40,
                          ),
                        )),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: translateDuration),
                      top: hasInit ? height / 2.6 : height / 2.6 - 80,
                      right: hasInit ? width / 3.6 : -50,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: opacityDuration),
                        opacity: opacity,
                        child: Image.asset(
                          "assets/21.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: translateDuration),
                      top: height / 2.2,
                      right: hasInit ? width / 3 : -50,
                      child: AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(milliseconds: opacityDuration),
                        child: Image.asset(
                          "assets/28.png",
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: translateDuration),
                      top: hasInit ? height / 2.12 : height / 1.8,
                      right: width / 2.2,
                      child: AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(milliseconds: opacityDuration),
                        child: Image.asset(
                          "assets/3.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: translateDuration),
                      top: hasInit ? height / 2.12 : height / 1.8,
                      right: hasInit ? width / 1.7 : width / 1.4,
                      child: AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(milliseconds: opacityDuration),
                        child: Image.asset(
                          "assets/33.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: translateDuration),
                      top: hasInit ? height / 2.4 : height / 2.6,
                      right: hasInit ? width / 1.57 : width,
                      child: AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(milliseconds: opacityDuration),
                        child: Image.asset(
                          "assets/36.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: translateDuration),
                      top: hasInit ? height / 2.9 : 100,
                      right: hasInit ? width / 1.53 : width,
                      child: AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(milliseconds: opacityDuration),
                        child: Image.asset(
                          "assets/46.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: translateDuration),
                      top: hasInit ? height / 3.5 : 0,
                      right: hasInit ? width / 1.58 : width,
                      child: AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(milliseconds: opacityDuration),
                        child: Image.asset(
                          "assets/3.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: translateDuration),
                      top: hasInit ? height / 4.1 : height / 5.8,
                      right: width / 2.5,
                      child: AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(milliseconds: opacityDuration),
                        child: Image.asset(
                          "assets/15.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: translateDuration),
                      top: hasInit ? height / 4.1 : height / 5.8,
                      right: width / 1.9,
                      child: AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(milliseconds: opacityDuration),
                        child: Image.asset(
                          "assets/45.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ), //
                  ],
                )),
                BlocBuilder<SplashBloc, SplashState>(
                  condition: (prevState, state) {
                    if (state is LoggedSuccess) {
                      print("Ready navigate to FeedPage from Login");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          FeedPage.routeName, (Route<dynamic> route) => false);
                      return false;
                    }
                    return true;
                  },
                  builder: (context, SplashState state) {
                    if (state is Loading) {
                      return Container(
                        height: height * 0.18,
                        child: LoadingPage(),
                      );
                    }
                    return Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                customButton(
                                  "Sign up",
                                  () {
                                    Navigator.pushNamed(
                                      context,
                                      SignUp.routeName,
                                    );
                                  },
                                ),
                                customButton("Log in", () {
                                  Navigator.pushNamed(context, Login.routeName);
                                })
                              ],
                            )),
                        Center(
                          child: GestureDetector(
                            onTap: () {
//                              _splashBloc.onLoadingForGuest(
//                                  page: 1, pageSize: 7);
                              Navigator.pushReplacementNamed(
                                  context, FeedPage.routeName,
                                  arguments:
                                      _appBloc.allSites.take(7).toList());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Start using without an account ",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.pink),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                  color: Colors.pink,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  },
                ),
              ],
            )));
  }
}
