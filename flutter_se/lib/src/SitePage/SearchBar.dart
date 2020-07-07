import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/SitePage/SiteBloc/Events.dart';
import 'package:flutter_se/src/common/DimensionHelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_se/src/common/Site.dart';

import 'SiteBloc/Bloc.dart';
import 'SiteBloc/State.dart';

class SearchBar extends StatefulWidget {
  final Site site;
  final Function onChangeSearchBar;
  SearchBar({this.site, this.onChangeSearchBar});
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  GlobalKey _dropDownButtonKey;
  SiteBloc _siteBloc;

  TextEditingController _textController;
  void openDropdown() {
    _dropDownButtonKey.currentContext.visitChildElements((element) {
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
  void initState() {
    super.initState();
    _textController = new TextEditingController();
    _siteBloc = context.bloc<SiteBloc>();
    _dropDownButtonKey = new GlobalKey();
  }

  @override
  void dispose() {
    _dropDownButtonKey = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = dimensionHelper(context).height;
    return Container(
      margin: EdgeInsets.all(6.0),
      height: height * 0.05,
      color: Colors.grey.withOpacity(0.2),
      child: BlocConsumer<SiteBloc, SiteState>(
        listenWhen: (prevState, state) {
          if (state is SiteChanged) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, SiteState state) {},
        buildWhen: (previous, current) {
          if (current is SiteChanged) {
            return true;
          }
          return false;
        },
        builder: (context, SiteState state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(width: 0.1)),
                  child: Form(
                      child: TextFormField(
                    controller: _textController,
                    enabled:
                        state.categorySite == CategorySite.Users ? false : true,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(11.0),
                        hintStyle: TextStyle(fontSize: 16),
                        hintText: 'Search sites ...',
                        prefixIcon: Icon(
                          Icons.search,
                        )),
                    onChanged: (value) {
                      _siteBloc.onSearchSearching(
                          state is SiteChanged
                              ? state.tagType
                              : state.tagTypes.first,
                          value,
                          widget.site);
                      widget.onChangeSearchBar(value);
                    },
                  )),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: state.categorySite == CategorySite.Users
                            ? () {}
                            : openDropdown,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: state.categorySite == CategorySite.Users
                                ? Colors.grey
                                : Colors.grey.withOpacity(0.3),
                            border: Border.all(width: 0.1),
                          ),
                          child: Text(
                            describeEnum(
                                      state is SiteChanged
                                          ? state.tagType
                                          : state.tagTypes.first,
                                    ) ==
                                    "UnAnswerNewest"
                                ? "No answers"
                                : describeEnum(
                                    state is SiteChanged
                                        ? state.tagType
                                        : state.tagTypes.first,
                                  ),
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                      ),
                    ),
                    Offstage(
                      child: DropdownButton(
                        value: state is SiteChanged
                            ? state.tagType
                            : state.tagTypes.first,
                        key: _dropDownButtonKey,
                        elevation: 0,
                        underline: SizedBox(),
                        icon: Icon(
                          Icons.arrow_downward,
                          size: 20,
                        ),
                        items: state.tagTypes
                            .map<DropdownMenuItem>(
                                (item) => DropdownMenuItem<TagType>(
                                      child: Text(
                                          describeEnum(item) == "UnAnswerNewest"
                                              ? "No answers"
                                              : describeEnum(item)),
                                      value: item,
                                    ))
                            .toList(),
                        onChanged: (value) {
                          _textController.clear();
                          _siteBloc.onSiteChanging(
                              tagType: value,
                              categorySite: state.categorySite,
                              site: widget.site);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
