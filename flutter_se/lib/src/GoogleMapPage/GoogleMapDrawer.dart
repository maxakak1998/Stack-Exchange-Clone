import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/GoogleMapPage/FirebasDatabaseHolder.dart';
import 'package:flutter_se/src/SplashPage.dart';
import 'package:flutter_se/src/Splash_Page/AppManager.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/LoadingPage.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";

import 'package:flutter_se/src/GoogleMapPage/GoogleMapBloc/Bloc.dart';

class GoogleMapDrawer extends StatefulWidget {
  final FirebaseDatabaseHolder firebaseDatabaseHolderData;
  final GoogleMapBloc _googleMapBloc;
  final int activeIndex;
  final Function saveCurrentIndexDrawer;
  GoogleMapDrawer(this._googleMapBloc, this.activeIndex,
      this.saveCurrentIndexDrawer, this.firebaseDatabaseHolderData);

  @override
  _GoogleMapDrawerState createState() => _GoogleMapDrawerState();
}

class _GoogleMapDrawerState extends State<GoogleMapDrawer> {
  List<LatLng> latLngList;
  AppManager appManager;
  int activeIndex;
  @override
  void initState() {
    super.initState();
    print("Active index is ${widget.activeIndex}");
    activeIndex = widget.activeIndex;
    appManager = new AppManager();
    latLngList = new List<LatLng>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        width: dimensionHelper(context).width * 0.8,
        child: appManager.userId == null
            ? Center(
                child: OutlineButton(
                  textColor: Colors.blue,
                  child: Text("Log in now"),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SplashPage.routeName);
                  },
                ),
              )
            : ListView(
                children:
                    _buildTransitionsHistory(widget.firebaseDatabaseHolderData),
              ),
      ),
    );
  }

  List<Widget> _buildTransitionsHistory(FirebaseDatabaseHolder state) {
    return state.transitionsHistory.map((location) {
//      print(location.timeStamp);
      int currentIndex = state.transitionsHistory.indexOf(location);
      String dateTime =
          new DateTime.fromMillisecondsSinceEpoch(location.timeStamp)
              .toIso8601String()
              .replaceAll("T", "-")
              .substring(0, 16);

      return Container(
        child: ListTile(
            selected: activeIndex == currentIndex,
            onTap: () {
              widget.saveCurrentIndexDrawer(currentIndex);
              setState(() {
                activeIndex = currentIndex;
              });
              widget._googleMapBloc.onShowHistory(location.latLngList);
              Navigator.of(context).pop();
            },
            leading: Icon(Icons.history),
            title: Text(
              dateTime,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            )),
      );
    }).toList();
  }
}
