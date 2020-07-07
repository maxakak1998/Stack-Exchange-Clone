import 'dart:developer';

import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_se/src/AllSitePage/AllSiteBloc/Bloc.dart';
import 'package:flutter_se/src/AllSitePage/AllSiteBloc/Events.dart';
import 'package:flutter_se/src/Drawer/DrawerPage.dart';
import 'package:flutter_se/src/SitePage/SitePage.dart';
import 'package:flutter_se/src/Splash_Page/SplashBloc/Bloc.dart';
import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/LoadingPage.dart';

import 'AllSiteBloc/State.dart';

class AllSitePage extends StatefulWidget {
  static String routeName = "/AllSitePage";
  static WidgetBuilder routeBuilder = (BuildContext context) {
    return AllSitePage();
  };

  @override
  _AllSitePageState createState() => _AllSitePageState();
}

class _AllSitePageState extends State<AllSitePage> {
  SplashBloc _splashBloc;
  AllSiteBloc _allSiteBloc;
  ScrollController _scrollController;

  bool isLoading;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _splashBloc = context.bloc<SplashBloc>();
    _allSiteBloc = context.bloc<AllSiteBloc>();
    isLoading = false;
    _scrollController = new ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !isLoading) {
          log("Dispatch onLoadMore");
          _allSiteBloc.onLoadMore();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    log("Rebuilt at All Site Page");
    return Scaffold(
        drawer: DrawerPage(),
        appBar: AppBar(
          title: Text("Stack Exchange Sites"),
          backgroundColor: AppColor.appBarColor,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BlocConsumer<AllSiteBloc, AllSiteState>(
              buildWhen: (prevState, state) {
                if (prevState.siteType != state.siteType) {
                  return true;
                }
                return false;
              },
              builder: (BuildContext context, AllSiteState state) {
                return Container(
                  color: Colors.grey.withOpacity(0.2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 0.1)),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                          child: Form(
                              child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                                hintText: 'Search sites ...',
                                prefixIcon: Icon(
                                  Icons.search,
                                )),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                _allSiteBloc.onChangeSiteType(state.siteType);
                                return;
                              }
                              _allSiteBloc.onSearchSite(value);
                            },
                          )),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                        margin: EdgeInsets.only(right: 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.1),
                        ),
                        child: DropdownButton(
                          elevation: 0,
                          underline: SizedBox(),
                          icon: SizedBox(
                            width: 20,
                            child: Icon(
                              Icons.arrow_downward,
                              size: 20,
                            ),
                          ),
                          value: state.siteType,
                          items: <DropdownMenuItem>[
                            DropdownMenuItem(
                              value: SiteType.MainSites,
                              child: Text("Main sites"),
                            ),
                            DropdownMenuItem(
                              value: SiteType.MetaSites,
                              child: Text("Meta sites"),
                            ),
                            DropdownMenuItem(
                              value: SiteType.AllSites,
                              child: Text("All sites"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == state.siteType) {
                              return;
                            }
                            _allSiteBloc.onChangeSiteType(value);
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
              listener: (BuildContext context, AllSiteState state) {
                if (state is ReadyToDisplaySite) {
                  isLoading = false;
                }
              },
            ),
            BlocBuilder<AllSiteBloc, AllSiteState>(
              builder: (context, AllSiteState state) {
                if (state is Loading) {
                  return LoadingPage();
                }
                return Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: (state as ReadyToDisplaySite).sites.length,
                    itemBuilder: (BuildContext context, int index) {
                      // log("index is $index , length site is ${(state as ReadyToDisplaySite).sites.length} ");
                      return index ==
                                  (state as ReadyToDisplaySite).sites.length -
                                      1 &&
                              !(state as ReadyToDisplaySite).hasReachMax
                          ? LoadingPage()
                          : ListTile(
                              dense: true,
                              onTap: () {
                                Navigator.of(context).popAndPushNamed(
                                    SitePage.routeName,
                                    arguments: (state as ReadyToDisplaySite)
                                        .sites[index]);
                              },
                              leading: (state as ReadyToDisplaySite)
                                  .sites[index]
                                  .getIcon,
                              title: Text((state as ReadyToDisplaySite)
                                  .sites[index]
                                  .getName),
                              subtitle: Text((state as ReadyToDisplaySite)
                                  .sites[index]
                                  .getDescription));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
