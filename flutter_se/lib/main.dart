import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_se/src/AboutPage/AboutPage.dart';
import 'package:flutter_se/src/AllSitePage/AllSiteBloc/Bloc.dart';
import 'package:flutter_se/src/AllSitePage/AllSitePage.dart';
import 'package:flutter_se/src/AppBloc/Bloc.dart';
import 'package:flutter_se/src/AppBloc/State.dart';
import 'package:flutter_se/src/DetailQuestionPage/DetailQuestionBloc/Bloc.dart';
import 'package:flutter_se/src/DetailQuestionPage/DetailQuestionPage.dart';
import 'package:flutter_se/src/EditSitePage/EditSitePage.dart';
import 'package:flutter_se/src/Feed/FeedBloc/Bloc.dart';
import 'package:flutter_se/src/Feed/FeedPage.dart';
import 'package:flutter_se/src/GoogleMapPage/GoogleMapBloc/Bloc.dart';
import 'package:flutter_se/src/GoogleMapPage/GoogleMapPage.dart';
import 'package:flutter_se/src/SettingPage/SettingPage.dart';
import 'package:flutter_se/src/SitePage/SiteBloc/Events.dart';
import 'package:flutter_se/src/SitePage/SiteBloc/Repo.dart';
import 'package:flutter_se/src/SitePage/SitePage.dart';
import 'package:flutter_se/src/SplashPage.dart';
import 'package:flutter_se/src/Splash_Page/AppManager.dart';
import 'package:flutter_se/src/Splash_Page/Login_Page/Login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_se/src/Splash_Page/Sign_up_page/SignUp.dart';
import 'package:flutter_se/src/Splash_Page/SplashBloc/Bloc.dart';
import 'package:flutter_se/src/common/Site.dart';
import 'package:flutter_se/src/common/Topic.dart';

import 'src/Feed/AllHotQuestionPage/AllHotQuestionPage.dart';
import 'src/SitePage/SiteBloc/Bloc.dart';
import 'src/common/LoadingLogin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SplashBloc splashBloc;
  AppBloc appBloc;
  @override
  void initState() {
    super.initState();

    appBloc = new AppBloc();
    splashBloc = new SplashBloc(appBloc);
  }

  @override
  void dispose() {
    splashBloc.close();
    appBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: appBloc,
        child: MaterialApp(
          onGenerateRoute: (settings) {
            log("Navigate to ");
            log("Navigate to ${settings.name}");

            if (settings.name == FeedPage.routeName) {
              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => BlocProvider(
                        create: (context) =>
                            // FeedBloc(appBloc)..onFetchDataForFeedPage(),
                            FeedBloc(appBloc),
                        child: FeedPage.routeBuilder(context),
                      ));
            } else if (settings.name == AllHotQuestionPage.routeName) {
              final List<Topic> hotQuestions =
                  settings.arguments as List<Topic>;
              return MaterialPageRoute(
                  settings: settings,
                  builder: ((context) =>
                      AllHotQuestionPage.routeBuilder(context, hotQuestions)));
            } else if (settings.name == SitePage.routeName) {
              final Site site = settings.arguments as Site;
              log("Site is ${site.getParamAPI}");
              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => MultiBlocProvider(providers: [
                        BlocProvider.value(
                          value: splashBloc,
                        ),
                        BlocProvider<SiteBloc>(
                            create: (context) => SiteBloc(new SiteRepo())
                              ..onFetchData(
                                  site: site,
                                  categorySite: CategorySite.Questions))
                      ], child: SitePage.routeBuilder(context, site)));
            } else if (settings.name == DetailQuestionPage.routeName) {
              Topic topic = settings.arguments as Topic;
              return MaterialPageRoute(
                  settings: settings,
                  builder: ((context) => BlocProvider<DetailQuestionBloc>(
                        create: (BuildContext context) => DetailQuestionBloc()
                          ..onFetchUserDetail(
                              topic.owner.userId.toString(),
                              topic.questionId.toString(),
                              topic.site.getParamAPI),
                        child: DetailQuestionPage.routeBuilder(context, topic),
                      )));
            }
            return null;
          },
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: LoadingLogin.routeName,
          routes: {
            LoadingLogin.routeName: LoadingLogin.routeBuilder,
            SplashPage.routeName: (context) {
              return BlocProvider.value(
                value: splashBloc,
                child: SplashPage.routeBuilder(context),
              );
            },
            Login.routeName: (context) => BlocProvider.value(
                value: splashBloc, child: Login.routeBuilder(context)),
            AllSitePage.routeName: (context) {
              return MultiBlocProvider(
                child: AllSitePage.routeBuilder(context),
                providers: [
                  BlocProvider<AllSiteBloc>(
                      create: (context) => AllSiteBloc()..onFetchAllSite()),
                  BlocProvider.value(value: splashBloc)
                ],
              );
            },
            EditSitePage.routeName: EditSitePage.routeBuilder,
            AboutPage.routeName: AboutPage.routeBuilder,
            SettingPage.routeName: SettingPage.routeBuilder,
            SignUp.routeName: SignUp.routeBuilder,
            GoogleMapPage.routeName: (context) => BlocProvider<GoogleMapBloc>(
                create: (context) => GoogleMapBloc()..onRequiringPermission(),
                child: GoogleMapPage.routeBuilder(context))
          },
        ));
  }
}
