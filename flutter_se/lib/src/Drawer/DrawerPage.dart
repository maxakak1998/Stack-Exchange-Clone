import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_se/src/AboutPage/AboutPage.dart';
import 'package:flutter_se/src/AllSitePage/AllSitePage.dart';
import 'package:flutter_se/src/AppBloc/Bloc.dart';
import 'package:flutter_se/src/Feed/FeedPage.dart';
import 'package:flutter_se/src/GoogleMapPage/GoogleMapPage.dart';
import 'package:flutter_se/src/SitePage/SitePage.dart';
import 'package:flutter_se/src/SplashPage.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/LoadingLogin.dart';
import 'package:flutter_se/src/common/Site.dart';
import "package:flutter_bloc/flutter_bloc.dart";

class DrawerPage extends StatefulWidget {
  final double textSize = 18.0;
  final double subTextSize = 16.0;

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  int focusNode;
  AppBloc _appbloc;
  List<Site> sites;

  void popToSitePage(Site site) async {
    await Future.delayed(new Duration(milliseconds: 150), () {
      Navigator.of(context)
          .popAndPushNamed(SitePage.routeName, arguments: site);
    });
  }

  Future<void> popToAllSitePage() async {
    await Future.delayed(new Duration(milliseconds: 150), () {
      Navigator.of(context).popAndPushNamed(AllSitePage.routeName);
    });
  }

  Future<void> popToLogin() async {
    await Future.delayed(new Duration(milliseconds: 150), () {
      Navigator.of(context).popAndPushNamed(SplashPage.routeName);
    });
  }

  renderSites() {
    return sites
        ?.map((item) => InkWell(
            onTap: () {
              int itemIndex = sites.indexOf(item);
              if (focusNode == itemIndex + 2) return;
              setState(() {
                focusNode = itemIndex + 2;
              });
              popToSitePage(item);
            },
            child: ListTile(
              selected: focusNode == sites.indexOf(item) + 2,
              leading: item.getIcon,
              title: Text(
                item.getName,
                style: TextStyle(fontSize: widget.textSize),
              ),
            )))
        ?.toList();
  }

  @override
  void initState() {
    super.initState();
    focusNode = -1;
    _appbloc = context.bloc<AppBloc>();
    sites = _appbloc.allSites.take(7).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sitesLength = sites?.length ?? 0;
    final width = dimensionHelper(context).width;
    final firstTile = _appbloc.userName == null
        ? "Sign up or log in"
        : "Welcome ${_appbloc.userName}";
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: width * 0.85,
        height: sitesLength == 0 ? dimensionHelper(context).height : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              selected: focusNode == 0,
              onTap: _appbloc.userName == null
                  ? () {
                      setState(() {
                        focusNode = 0;
                      });
                      popToLogin();
                    }
                  : () {},
              title: Text(
                firstTile,
                style: TextStyle(fontSize: widget.textSize),
              ),
              leading: _appbloc.userName == null
                  ? Image.asset(
                      "launcher.png",
                      width: 30.0,
                      height: 30.0,
                    )
                  : null,
              trailing: _appbloc.userName != null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            LoadingLogin.routeName,
                            (Route<dynamic> route) => false);
                        _appbloc.onLogout();
                      },
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                      ),
                    )
                  : null,
            ),
            ListTile(
              selected: focusNode == 1,
              onTap: () async {
                if (focusNode == 1) return;
                setState(() {
                  focusNode = 1;
                });
                await Future.delayed(new Duration(milliseconds: 150), () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(FeedPage.routeName));
                });
              },
              title: Text("Feed", style: TextStyle(fontSize: widget.textSize)),
              leading: Image.asset(
                "nav_feed.png",
                width: 30.0,
                height: 30.0,
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.0),
              color: Colors.grey.withOpacity(0.4),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Your sites",
                        style: TextStyle(fontSize: widget.subTextSize)),
//                    Text("Edit", style: TextStyle(fontSize: widget.subTextSize))
                  ]),
            ),
            ...?renderSites(),
            ListTile(
              selected: focusNode == sitesLength + 2,
              onTap: () {
                if (focusNode == 2) return;
                setState(() {
                  focusNode = sitesLength + 2;
                });
                popToAllSitePage();
              },
              title: Text("All sites",
                  style: TextStyle(fontSize: widget.textSize)),
              leading: Image.asset("ic_more.png", height: 30.0, width: 30.0),
            ),
            Container(
                padding: EdgeInsets.all(4.0),
                color: Colors.grey.withOpacity(0.4),
                child: Row(
                  children: <Widget>[
                    Text("Other",
                        style: TextStyle(fontSize: widget.subTextSize))
                  ],
                )),
            ListTile(
              selected: focusNode == sitesLength + 3,
              title: Text("About", style: TextStyle(fontSize: widget.textSize)),
              onTap: () async {
                if (focusNode == sitesLength + 3) return;
                setState(() {
                  focusNode = sitesLength + 3;
                });
                await Future.delayed(new Duration(milliseconds: 150), () {
                  Navigator.of(context).popAndPushNamed(AboutPage.routeName);
                });
              },
              leading: Image.asset(
                "nav_help.png",
                height: 30.0,
                width: 30.0,
              ),
            ),
            ListTile(
              selected: focusNode == sitesLength + 4,
              onTap: () {
                setState(() {
                  if (focusNode == sitesLength + 4) return;
                  focusNode = sitesLength + 4;
                });
              },
              title:
                  Text("Settings", style: TextStyle(fontSize: widget.textSize)),
              leading: Image.asset(
                "nav_settings.png",
                height: 30.0,
                width: 30.0,
              ),
            ),
            ListTile(
              selected: focusNode == sitesLength + 5,
              onTap: () async {
                setState(() {
                  if (focusNode == sitesLength + 5) return;
                  focusNode = sitesLength + 5;
                });
                await Future.delayed(new Duration(milliseconds: 150), () {
//                  Navigator.of(context).pushNamedAndRemoveUntil(
//                      GoogleMapPage.routeName,
//                      ModalRoute.withName(FeedPage.routeName));

                  Navigator.of(context)
                      .popAndPushNamed(GoogleMapPage.routeName);
                });
              },
              title:
                  Text("Location", style: TextStyle(fontSize: widget.textSize)),
              leading: Icon(
                Icons.location_on,
                size: 30,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
