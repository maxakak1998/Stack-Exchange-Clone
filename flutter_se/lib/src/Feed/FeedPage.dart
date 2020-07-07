import 'dart:developer';
import 'dart:math' as Math;
import "package:flutter/material.dart";
import 'package:flutter_se/src/AppBloc/Bloc.dart';
import 'package:flutter_se/src/Drawer/DrawerPage.dart';
import 'package:flutter_se/src/Feed/FeedBloc/Bloc.dart';
import 'package:flutter_se/src/Feed/FeedBloc/FeedTopicItem.dart';
import 'package:flutter_se/src/Feed/FeedBloc/Repo.dart';
import 'package:flutter_se/src/Feed/FeedBloc/State.dart';
import 'package:flutter_se/src/Feed/HotTopicItem.dart';
import 'package:flutter_se/src/Feed/StickyHeaderItem.dart';

import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/LoadingPage.dart';
import 'package:flutter_se/src/common/Site.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_se/src/common/Topic.dart';
import 'package:sticky_headers/sticky_headers.dart';

class FeedPage extends StatefulWidget {
  static String routeName = "/FeedPage";

  static WidgetBuilder routeBuilder = (BuildContext context) {
    return FeedPage();
  };

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  ScrollController _controller;
  FeedBloc _feedBloc;
  bool isLoading;
  bool hasStarted;
  AppBloc _appBloc;

  AnimationController _animationController;
  Animation<double> _animationOpacity;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _animationOpacity =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _appBloc = context.bloc<AppBloc>();
    isLoading = false;
    _feedBloc = context.bloc<FeedBloc>();
    hasStarted = false;
    _controller = new ScrollController()
      ..addListener(() {
        if (_controller.offset == _controller.position.maxScrollExtent &&
            !isLoading) {
          isLoading = true;
          _feedBloc.onLoadMore();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _feedBloc.close();
    print("Feed disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appBarColor,
        title: Text("Feed"),
      ),
      body: hasStarted
          ? BlocConsumer<FeedBloc, FeedState>(
              listener: (context, FeedState state) {
                if (state is OnLoaded) {
                  log("Aniamtion status is ${_animationOpacity.status}");
                  _animationController?.reset();
                  _animationController.forward();
                  log("Aniamtion status is ${_animationOpacity.status}");

                  Color color = Colors.primaries[
                      Math.Random().nextInt(Colors.primaries.length)];
                  state.topicHotColor = color;
                  isLoading = false;
                }
              },
              builder: (context, FeedState state) {
                if (state is OnInitialize) {
                  return Center(
                    child: LoadingPage(),
                  );
                }
                if (state is OnError) {
                  return Text(state.error);
                }
                if (state is OnError) {
                  return Text("Failed to load");
                }
                final currentState = state as OnLoaded;
//                print("${currentState.allTopicRows[1].topicRows}");

                return RefreshIndicator(
                  onRefresh: () async {
                    OnLoaded newState =
                        await new Repo(allSites: _appBloc.allSites)
                            .onRefresh(currentState);
                    if (newState != null) {
                      _feedBloc.onRefresh(newState);
                    }

                    return Future.delayed(new Duration(milliseconds: 0));
                  },
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      itemCount: currentState.allTopicRows.length,
                      itemBuilder: (context, allTopicRowsIndex) {
                        return Column(
                          children: <Widget>[
                            FadeTransition(
                              opacity: _animationOpacity,
                              child: Visibility(
                                child: HotTopicItem(
                                    currentState.hotTopic.site,
                                    currentState.hotTopic,
                                    currentState.fullHotTopic,
                                    hotTopicBackgroundColor:
                                        currentState.topicHotColor),
                                visible: allTopicRowsIndex == 0,
                              ),
                            ),
                            StickyHeader(
                              header: StickyHeaderItem(currentState
                                  .allTopicRows[allTopicRowsIndex].label),
                              content: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: currentState
                                      .allTopicRows[allTopicRowsIndex]
                                      .topicRows
                                      .length,
                                  itemBuilder: (context, index) =>
                                      _builderHorizontalList(
                                          currentState
                                              .allTopicRows[allTopicRowsIndex]
                                              .topicRows[index],
                                          context)),
                            ),
//
                            allTopicRowsIndex ==
                                        currentState.allTopicRows.length - 1 &&
                                    !currentState.hasReachedMax
                                ? LoadingPage()
                                : SizedBox()
                          ],
                        );
                      }),
                );
              },
            )
          : Center(
              child: Text("Press the button below"),
            ),
      drawer: DrawerPage(),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "Fetch",
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          if (!hasStarted) {
            setState(() {
              hasStarted = true;
            });
          }

          context.bloc<FeedBloc>().onFetchDataForFeedPage();
        },
      ),
    ));
  }
}

Widget _builderHorizontalList(List<Topic> topicInRow, BuildContext context) {
  if (topicInRow == null) {
    log("Topic in row $topicInRow");
    return SizedBox();
  }
  return Container(
    alignment: Alignment.center,
    height: dimensionHelper(context).height * 0.22,
    child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 8.0, left: 4.0, bottom: 4.0),
            alignment: Alignment.center,
            width: dimensionHelper(context).width * 0.8,
            child: FeedTopicItem(topicInRow[index], index, topicInRow.length),
          );
        },
        separatorBuilder: (context, index) => LimitedBox(
              maxHeight: 5,
              child: VerticalDivider(
                color: Colors.grey.withOpacity(0.4),
                thickness: 1,
              ),
            ),
        itemCount: topicInRow.length),
  );
}
