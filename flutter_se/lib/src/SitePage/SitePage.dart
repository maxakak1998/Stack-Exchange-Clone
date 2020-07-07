import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_se/src/Drawer/DrawerPage.dart';
import 'package:flutter_se/src/Feed/FeedPage.dart';
import 'package:flutter_se/src/SitePage/SiteBloc/Bloc.dart';
import 'package:flutter_se/src/Splash_Page/SplashBloc/Bloc.dart';
import 'package:flutter_se/src/common/Colors.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_se/src/common/LoadingPage.dart';
import 'package:flutter_se/src/common/Site.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'QuestionItem.dart';
import 'SearchBar.dart';
import 'SiteBloc/Events.dart';
import 'SiteBloc/State.dart';
import 'TagItem.dart';
import 'UserItem.dart';

class SitePage extends StatefulWidget {
  static String routeName = "/SitePage";
  Site site;

  SitePage(this.site);
  static Function routeBuilder = (BuildContext context, Site site) {
    return SitePage(site);
  };

  @override
  _SitePageState createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  SplashBloc _splashBloc;
  SiteBloc _siteBloc;
  GlobalKey _dropdownButtonKey = new GlobalKey();
  bool isLoading;
  ScrollController _scrollerController;
  TagType tagType;
  String searchingData;
  void onChangeSearchBar(String value) {
    searchingData = value;
  }

  @override
  void initState() {
    super.initState();
    _splashBloc = context.bloc<SplashBloc>();
    isLoading = false;
    tagType = TagType.Active;
    _siteBloc = context.bloc<SiteBloc>();
    _scrollerController = new ScrollController()
      ..addListener(() {
        if (_scrollerController.position.pixels ==
            _scrollerController.position.maxScrollExtent) {
          log("Load more");
          isLoading = true;
          _siteBloc.onLoadMore(widget.site, tagType, searchingData);
        }
      });
  }

  void openDropdown() {
    _dropdownButtonKey.currentContext.visitChildElements((element) {
      if (element.widget != null && element.widget is Semantics) {
        element.visitChildElements((element) {
          if (element.widget != null && element.widget is Actions) {
            element.visitChildElements((element) {
              Actions.invoke(element, Intent(ActivateAction.key));
              return false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _siteBloc.close();
    _dropdownButtonKey = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = dimensionHelper(context).width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil(ModalRoute.withName(FeedPage.routeName));
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollerController,
            slivers: <Widget>[
              SliverAppBar(
                actions: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          "answers.png",
                          height: 30,
                          width: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
                title: Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: openDropdown,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                widget.site.getName,
                                style: TextStyle(shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 5.0),
                                    blurRadius: 3.0,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: AppColor.appBarColor,
                            ),
                            child: BlocConsumer<SiteBloc, SiteState>(
                              builder: (BuildContext context, SiteState state) {
                                return DropdownButton(
                                  key: _dropdownButtonKey,
                                  icon: SizedBox(),
                                  underline: SizedBox(),
                                  onChanged: (value) {
                                    _siteBloc.onSiteChanging(
                                        categorySite: value, site: widget.site);
                                  },
                                  isDense: true,
                                  value: state is SiteChanged
                                      ? state.categorySite
                                      : CategorySite.Questions,
                                  elevation: 0,
                                  items: <DropdownMenuItem<CategorySite>>[
                                    const DropdownMenuItem(
                                      value: CategorySite.Questions,
                                      child: Text(
                                        "Questions",
                                        style: TextStyle(
                                            color: const Color.fromRGBO(
                                                194, 194, 163, 1),
                                            fontSize: 14),
                                      ),
                                    ),
                                    const DropdownMenuItem(
                                      value: CategorySite.Tags,
                                      child: Text("Tags",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: const Color.fromRGBO(
                                                  194, 194, 163, 1))),
                                    ),
                                    DropdownMenuItem(
                                      value: CategorySite.Users,
                                      child: Text("Users",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: const Color.fromRGBO(
                                                  194, 194, 163, 1))),
                                    )
                                  ],
                                );
                              },
                              buildWhen: (prevState, state) {
                                if (state is SiteChanged) {
                                  return true;
                                }
                                return false;
                              },
                              listenWhen: (prevState, state) {
                                if (state is SiteChanged) {
                                  return true;
                                }
                                return false;
                              },
                              listener: (BuildContext context, state) {
                                if (state is SiteChanged) {
                                  tagType = state.tagType;
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: openDropdown,
                        child: Container(
                            child: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromRGBO(194, 194, 163, 1),
                          size: 30,
                        )),
                      )
                    ],
                  ),
                ),
                backgroundColor: AppColor.appBarColor,
                expandedHeight: 80,
                titleSpacing: 17.0,
                floating: true,
                flexibleSpace: Container(
                  margin: EdgeInsets.all(4.0),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    widget.site.getDescription,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 0, 1),
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              SliverSingleBoxAdapter(
                child: SearchBar(
                  site: widget.site,
                  onChangeSearchBar: onChangeSearchBar,
                ),
              ),
              BlocConsumer<SiteBloc, SiteState>(
                buildWhen: (prevState, state) {
                  if (state is SiteChanged) {
                    return false;
                  }
                  return true;
                },
                listener: (context, state) {
                  if (state is AllQuestionsLoaded ||
                      state is AllTagsLoaded ||
                      state is AllUsersLoaded) {
                    isLoading = false;
                  }
                },
                builder: (context, SiteState state) {
                  if (state is Error) {
                    return SliverSingleBoxAdapter(
                      child: Center(
                        child: Text(state.error),
                      ),
                    );
                  }
                  if (state is Initializing) {
                    return SliverSingleBoxAdapter(
                      child: LoadingPage(),
                    );
                  }
                  //list of users
                  if (state is AllUsersLoaded) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == state.users.length - 1 &&
                              !state.hasReachedMax) {
                            return LoadingPage();
                          }
                          return UserItem(state.users[index]);
                        },
                        childCount: state.users.length,
                      ),
                    );
                  }

                  //list of tags
                  if (state is AllTagsLoaded) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == state.tags.length - 1 &&
                              !state.hasReachedMax) {
                            return LoadingPage();
                          }
                          return TagItem(
                              state.tags[index].name, state.tags[index].count);
                        },
                        childCount: state.tags.length,
                      ),
                    );
                  }
                  //list of questions
                  if (state is AllQuestionsLoaded) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == state.topics.length - 1 &&
                              !state.hasReachedMax) {
                            return LoadingPage();
                          }
                          return SiteQuestionItem(state.topics[index]);
                        },
                        childCount: state.topics.length,
                      ),
                    );
                  }
                  return SliverSingleBoxAdapter(
                    child: Text("Loading"),
                  );
                },
              )
            ],
          ),
        ),
        drawer: DrawerPage(),
      ),
    );
  }
}

class SliverSingleBoxAdapter extends SingleChildRenderObjectWidget {
  SliverSingleBoxAdapter({Key key, Widget child})
      : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderLoading();
  }
}

class RenderLoading extends RenderSliverSingleBoxAdapter {
  RenderLoading({RenderBox child}) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }
    assert(childExtent != null);
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child, constraints, geometry);
  }
}
