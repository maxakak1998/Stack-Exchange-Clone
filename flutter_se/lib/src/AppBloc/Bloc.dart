import 'dart:developer';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_se/src/Splash_Page/AppManager.dart';
import "package:google_sign_in/google_sign_in.dart";
import 'package:flutter_se/src/common/Site.dart';
import 'Events.dart';
import 'Repo.dart';
import 'State.dart';
import "package:flutter_se/src/Splash_Page/SplashBloc/Repo.dart" as SplashRepo;
import "package:firebase_auth/firebase_auth.dart";

class AppBloc extends Bloc<AppEvent, AppState> {
  static String CLIENT_KEY = "key";
  static final String CLIENT_ID = "client_id";
  static final String ACCESS_TOKEN = "access_token";
  static final String ACCESS_TOKEN_EXPIRATION = "expire";
  GoogleSignIn googleSignIn;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  List<Site> allSites;

  Repo repo = new Repo();
  Map<String, String> token;
  String client_id;
  String client_key;
  String access_token;
  String userName;
  @override
  get initialState => Initializing();

  @override
  Stream<AppState> mapEventToState(event) async* {
    if (event is PreLoadEvent) {
      await repo.firebaseDatabaseConfig();
      print("Pred loading event");
      //loading all sites for drawer
      allSites = await repo.onLoadingAllSites(new SplashRepo.Repo(this));

      //load all keys for SE feature
      await repo.preLoad(CLIENT_ID, CLIENT_KEY);

      client_id = await repo.getClientIDKey(CLIENT_ID);
      client_key = await repo.getClientKey(CLIENT_KEY);
      String type = await repo.getLoginType();
      print("Type is $type");

      //check the previous login type
      if (type == null) {
        print("UnAuthenticated");
        //no print yet
        yield UnAuthenticated();
      }
      //had the previous login type
      else {
        //Auto sign in with SE account
        print("Authenticated");

        if (type == "se") {
          token =
              await repo.getAccessToken(ACCESS_TOKEN, ACCESS_TOKEN_EXPIRATION);
          bool isValid = isValidToken(token[ACCESS_TOKEN_EXPIRATION]);
          if (token[ACCESS_TOKEN] != null && isValid) {
            //allow to skip the printin page
            print("Auto log in SE with name is  $userName ");
            userName = await repo.getUserName();
            access_token = token[ACCESS_TOKEN];
            AppManager().userId = await SplashRepo.Repo(this).getUserIdFromSE();
            yield Authenticated();
          } else {
            yield UnAuthenticated();
            //keep user at the login page
          }
        }
        //Auto sign in with other type accounts
        else if (auth.currentUser() != null) {
          //Auto sign in with Facebook account
          if (type == "fb") {
            print("Auto log in Facebook ");
            //for facebook
            final facebookLogin = FacebookLogin();
            final bool isLoggedIn = await facebookLogin.isLoggedIn;
            if (isLoggedIn) {
              FacebookAccessToken facebookAccessToken =
                  await facebookLogin.currentAccessToken;
              access_token = facebookAccessToken.token;

              AppManager().userId = facebookAccessToken.userId;
              print("Facebook user id is ${AppManager().userId}");

              userName = await repo.getUserName();

              yield Authenticated();
            }
            //Maybe expire
            else {
              yield UnAuthenticated();
            }

            //Auto sign in with Google account
          } else if (type == "google") {
            googleSignIn ??= GoogleSignIn();
            //for google
            print("Auto log in Google ");
            GoogleSignInAccount googleSignInAccount =
                await googleSignIn.signInSilently();
            final bool isLoggedIn = await googleSignIn.isSignedIn();
            if (isLoggedIn) {
              access_token = (await googleSignInAccount.authentication)
                  .accessToken
                  .toString();
              userName = await googleSignInAccount.displayName;

              AppManager().userId = googleSignInAccount.id;
              print("Google user id is ${AppManager().userId}");

              yield Authenticated();
            }
            //Maybe expire
            else {
              yield UnAuthenticated();
            }
          }
        }
        //Never sign in before
        else {
          yield UnAuthenticated();
        }
      }
    }
    //Log out event
    if (event is LogoutEvent) {
      await auth?.signOut();
      //Just sign out if auth is not null

      //Get the previous login type
      String type = await repo.getLoginType();

      bool hasDestroyed = false;

      //Log out with SE, we just need to inactive the access token
      if (type == "se") {
        //inactive token
        hasDestroyed = await repo.invalidateSEToken(access_token);
      }
      //Log out with Fb
      else if (type == "fb") {
        await facebookLogin.logOut();

        hasDestroyed = await repo.invalidateFbToken(access_token);
      }
      //Log out with google
      else if (type == "google") {
        try {
          GoogleSignInAccount user = await googleSignIn.currentUser;
          print("Keep going ${user}");
          await user.clearAuthCache();
          await googleSignIn.disconnect();
          hasDestroyed = true;
        } catch (e) {
          hasDestroyed = false;
          log("Error when loging out, ${e.toString()}");
        }
      }
      print("hasDestroyed  is $hasDestroyed");

      if (hasDestroyed) {
        print("Clear storage");
        //navigate to the Login page
        await repo.clearStorage();
        clearBlocData();
        yield UnAuthenticated();
        return;
      }
      log("Error when loging out");
      yield UnAuthenticated();
    }
  }

  void onPreLoading() {
    add(PreLoadEvent());
  }

  void onLogout() {
    add(LogoutEvent());
  }

  bool isValidToken(String token) {
    if (token == null) {
      return false;
    }
    int _token = int.parse(token);
    int now = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (now >= _token) {
      //expire
      return false;
    } else {
      //no expire
      return true;
    }
  }

  void clearBlocData() {
    token?.clear();
    access_token = null;
    userName = null;
    new AppManager().clear();
  }
}
