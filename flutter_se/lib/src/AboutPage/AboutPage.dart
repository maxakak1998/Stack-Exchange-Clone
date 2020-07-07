import 'package:flutter/material.dart';
import 'package:flutter_se/src/AboutPage/AboutButton.dart';
import 'package:flutter_se/src/AboutPage/Library.dart';
import 'package:flutter_se/src/AboutPage/LibraryItem.dart';
import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/rendering.dart';

class AboutPage extends StatelessWidget {
  final List<Library> list = [
    Library(
        "cupertino_icons", "flutter.dev", "pub.dev/packages/cupertino_icons"),
    Library("http", "dart.dev", "github.com/dart-lang/http"),
    Library("flutter_bloc", "bloclibrary.dev",
        "github.com/felangel/bloc/tree/master/packages/flutter_bloc"),
    Library("rxdart", "fluttercommunity.dev", "github.com/ReactiveX/rxdart"),
    Library("sticky_headers", "bloclibrary.dev",
        "github.com/fluttercommunity/flutter_sticky_headers"),
    Library("flutter_facebook_login", "roughike",
        "github.com/roughike/flutter_facebook_login"),
    Library("webview_flutter", "flutter.dev",
        "github.com/flutter/plugins/tree/master/packages/webview_flutter"),
    Library("flutter_secure_storage", "saprykin.h@gmail.com",
        "github.com/mogol/flutter_secure_storage"),
    Library("google_sign_in", "flutter.dev",
        "github.com/flutter/plugins/tree/master/packages/google_sign_in/google_sign_in"),
    Library("firebase_auth", "firebase.google.com",
        "github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_auth/firebase_auth"),
    Library("drop_cap_text", "tiziano.munegato",
        "github.com/mtiziano/drop_cap_text"),
    Library("google_maps_flutter", "flutter.dev",
        "github.com/flutter/plugins/tree/master/packages/google_maps_flutter/google_maps_flutter"),
    Library("firebase_database", "firebase.google.com",
        "pub.dev/packages/firebase_database"),
    Library("permission_handler", "baseflow.com",
        "github.com/Baseflow/flutter-permission-handler"),
    Library("location", "bernos.dev", "github.com/Lyokone/flutterlocation"),
    Library("flutter_html", "sub6resources.com",
        "github.com/Sub6Resources/flutter_html"),
  ];
  final headerSize = 24.0;
  final String desciption =
      "Stack Exchange Android App Version 1.0.95 \n \nThis is the official Stack Exchange Android app. It is still evolving and we are committed to making it a little better each day. \n \nCrash reports are automatically reported back to us. Bugs or feature requests should be reported on Meta Stack Exchange and tagged **android-app**.";

  static String routeName = "/AboutPage";
  static WidgetBuilder routeBuilder = (BuildContext context) {
    return AboutPage();
  };
  List<Widget> buildLibs() {
    return list.map((item) => LibraryItem(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appBarColor,
        title: Text(
          "About",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropCapText(
                  desciption,
                  style: TextStyle(fontSize: 17, height: 1.3),
                  markdownColor: Colors.red,
                  dropCapPosition: DropCapPosition.end,
                  textAlign: TextAlign.left,
                  parseInlineMarkdown: true,
                  dropCap: DropCap(
                      height: 70,
                      width: 60,
                      child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/6/66/Android_robot.png",
                        fit: BoxFit.fill,
                      )),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              AboutButton(
                title: "Existing bug report and feature requests",
                textStyle: TextStyle(color: AppColor.linkColor),
              ),
              AboutButton(
                  title: "Submit a bug report",
                  textStyle: TextStyle(color: AppColor.linkColor)),
              AboutButton(
                  title: "Submit a feature request",
                  textStyle: TextStyle(color: AppColor.linkColor)),
              SizedBox(
                height: 18,
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "About",
                    style: TextStyle(
                        fontSize: headerSize, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Text(
                  'Coppyright 2014-2015, Stack Exchange Inc.',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                  title: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "TOS & Privacy Policy",
                      style: TextStyle(
                          fontSize: headerSize, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      text: 'See Stack Exchange\'s ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "terms of service ",
                          style: TextStyle(color: AppColor.linkColor),
                        ),
                        TextSpan(text: "and "),
                        TextSpan(
                            text: "privacy policy. ",
                            style: TextStyle(color: AppColor.linkColor))
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Open Source",
                    style: TextStyle(
                        fontSize: headerSize, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Text(
                  'This app includes the following open source libraries:',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ...buildLibs(),
              RaisedButton(
                child: Text("More information"),
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationVersion: "2.0.1",
                      applicationIcon: Image.asset("launcher.png"),
                      applicationLegalese: "Hello",
                      children: [Text("A")]);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
