import 'dart:developer';

import 'package:flutter_se/src/AllSitePage/AllSiteBloc/Repo.dart';
import 'package:flutter_se/src/common/Site.dart';
import 'package:rxdart/rxdart.dart';

import 'Events.dart';
import 'State.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllSiteBloc extends Bloc<AllSiteEvent, AllSiteState> {
  Repo repo = new Repo();
  List<Site> sites;
  @override
  Stream<Transition<AllSiteEvent, AllSiteState>> transformEvents(
      Stream<AllSiteEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(new Duration(milliseconds: 500)), transitionFn);
  }

  @override
  AllSiteState get initialState => Loading();
  void onFetchAllSite() {
    add(GetSitesEvent());
  }

  void onLoadMore() {
    add(LoadMoreEvent());
  }

  void onChangeSiteType(SiteType type) {
    add(ChangeSiteTypeEvent(type));
  }

  @override
  Stream<AllSiteState> mapEventToState(AllSiteEvent event) async* {
    if (event is GetSitesEvent) {
      log("Fetch");
      sites = await repo.getSites(null, 50);
      yield ReadyToDisplaySite(sites);
    }

    if (event is LoadMoreEvent &&
        state is ReadyToDisplaySite &&
        !(state as ReadyToDisplaySite).hasReachMax) {
      log("Loading event");
      int oldLengthSites = (state as ReadyToDisplaySite).sites.length;
      int newLengthSites = oldLengthSites + 50;
      List<Site> newSites = (await repo.getSites(null, newLengthSites))
          .getRange(oldLengthSites, newLengthSites)
          .toList();

      sites.insertAll(oldLengthSites, newSites);

      yield ReadyToDisplaySite(sites, siteType: SiteType.AllSites);
    }

    if (event is ChangeSiteTypeEvent && state is ReadyToDisplaySite) {
      yield Loading();

      String siteType = getSiteType(event.type);
      if (siteType == null) {
        yield ReadyToDisplaySite(sites, siteType: event.type);
        return;
      }
      // if (event.type == SiteType.MainSites) {
      //   siteType = "main_site";
      // } else if (event.type == SiteType.MetaSites) {
      //   siteType = "meta_site";
      // } else {
      //   log("Fetch all site");
      //   yield ReadyToDisplaySite(sites, siteType: event.type);
      //   return;
      // }
      log("continue");
      List<Site> filterList =
          sites.where((site) => site.getSiteType == siteType).toList();

      yield ReadyToDisplaySite(filterList, siteType: event.type);
    }
    if (event is SearchSiteEvent) {
      final currentState = state as ReadyToDisplaySite;
      final siteType = getSiteType(currentState.siteType);
      log("currentState.siteType ${siteType}");

      final filteredList = sites
          .where((site) =>
              site.getName.toString().toLowerCase().contains(event.siteName) &&
              (siteType != null ? site.getSiteType == siteType : true))
          .toList();
      yield ReadyToDisplaySite(filteredList,
          siteType: currentState.siteType, hasReachMax: true);
    }
  }

  String getSiteType(SiteType type) {
    String siteType;
    if (type == SiteType.MainSites) {
      siteType = "main_site";
    } else if (type == SiteType.MetaSites) {
      siteType = "meta_site";
    }
    return siteType;
  }

  void onSearchSite(String value) {
    add(SearchSiteEvent(value));
  }
}
