import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/common/Service.dart';
import 'package:flutter_se/src/common/Site.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:flutter_se/src/AppBloc/Bloc.dart";
import 'package:webview_flutter/webview_flutter.dart';

class Repo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AppBloc _appBloc;
  Repo(this._appBloc);
  Future<List<Site>> getSites(int page, int pageSize) async {
    String api = Service.getAllSiteApi(page: page, pageSize: pageSize);
    try {
      final http.Response response = await http.get(api);
      final List<Site> sites =
          ((convert.jsonDecode(response.body)["items"]) as List<dynamic>)
              .map((item) => new Site(
                  item["name"], item["high_resolution_icon_url"],
                  paramAPI: item['api_site_parameter'],
                  description: item['audience'],
                  siteType: item["site_type"]))
              .toList();
      return sites;
    } catch (e) {
      log("Error: $e");
      return null;
    }
  }

  Future<String> getUserIdFromFb() async {
    final fb = FacebookLogin();
    bool isLoggedIn = await fb.isLoggedIn;

    if (isLoggedIn) {
      //get access token
      FacebookAccessToken accessToken = await fb.currentAccessToken;
      String userId = accessToken.userId;
      return userId;
    }
    return null;
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;
    final result = await facebookLogin.logIn(['email']);
    _appBloc.access_token = result.accessToken.token.toString();

    final credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token,
    );

    FirebaseUser user =
        (await firebaseAuth.signInWithCredential(credential)).user;

    return user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount _googleSignInAccount;
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    GoogleSignIn _googleSignIn = new GoogleSignIn(
      scopes: [
        'email',
        'openid',
        'profile',
      ],
    );

    _appBloc.googleSignIn = _googleSignIn;
    _googleSignInAccount = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await _googleSignInAccount.authentication;

    log("${googleSignInAuthentication.accessToken}");
    log("${googleSignInAuthentication.idToken}");

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser user = await _firebaseAuth.currentUser();

    return user;
  }

  Future<Map<String, String>> signInWithStackExchange(
      BuildContext context) async {
    final redirectUri =
        new Uri.https("stackexchange.com", "oauth/login_success").toString();
    log("Client id is _${_appBloc.client_id}");
    final promptUrl = new Uri.https("stackoverflow.com", "oauth/dialog", {
      "client_id": _appBloc.client_id,
      "redirect_uri": redirectUri
    }).toString();

    Map<String, String> token = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                leading: CloseButton(),
              ),
              body: WebView(
                initialUrl: promptUrl,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest req) {
                  if (req.url.contains(redirectUri)) {
                    // log(req.url.toString());

                    Uri uri = Uri.parse(req.url);
                    Map<String, String> queryParams = uri.queryParameters;
                    String error;
                    queryParams.containsKey("error")
                        ? error = queryParams['error_description']
                        : error = '';

                    if (error.isNotEmpty) {
                      log("Error: $error");
                      return NavigationDecision.prevent;
                    }
                    Map<String, String> key = _getServerData(req.url);
                    Navigator.of(context).pop(key);
                    return NavigationDecision.prevent;
                  }

                  return NavigationDecision.navigate;
                },
              )),
        ));
    return token;
  }

  Map<String, String> _getServerData(String url) {
    Uri uri = Uri.parse(url);
    log(url.toString());

    String fragments = uri.fragment;
    log("Fragments are ${fragments}");

    //split & char - > We got the key and the expiration
    List<String> params = fragments.split("&");

    //split = char on the key => We got the key name and the key value
    List<String> keys = params[0].toString().split("=");
    List<String> expires = params[1].toString().split("=");

    Map<String, String> key = new Map<String, String>();

    //then we set key in the correct form, EX: "access_token": 123

    key[AppBloc.ACCESS_TOKEN] = keys[1];
    key[AppBloc.ACCESS_TOKEN_EXPIRATION] = expires[1];
    return key;
  }

  Future<String> fetchUserInfoSE() async {
    String api =
        Service.getUserInfoApiSE(_appBloc.client_key, _appBloc.access_token);

    final response = await http.get(api, headers: {
      HttpHeaders.contentTypeHeader:
          "application/x-www-form-urlencoded;charset=UTF-8",
      HttpHeaders.cacheControlHeader: "no-store",
      HttpHeaders.pragmaHeader: "no-cache",
      HttpHeaders.authorizationHeader: "Bearer",
    });

    if (response.statusCode == 200) {
      final bodyJS = convert.jsonDecode(response.body);
//      print("Body js : ${bodyJS["items"][0]["display_name"]}");

      final String name = bodyJS["items"][0]["display_name"].toString();
      return name;
    } else {
      return null;
    }
  }

  Future<String> getUserIdFromGoogle() async {
    bool isLoggedIn = await _appBloc.googleSignIn.isSignedIn();
    if (isLoggedIn) {
      //get access token
      String userId = _appBloc.googleSignIn.currentUser.id;
      print("Google user id is $userId");
      return userId;
    }
    return null;
  }

  Future<String> getUserIdFromSE() async {
    String api =
        Service.getUserInfoApiSE(_appBloc.client_key, _appBloc.access_token);

    final response = await http.get(api, headers: {
      HttpHeaders.contentTypeHeader:
          "application/x-www-form-urlencoded;charset=UTF-8",
      HttpHeaders.cacheControlHeader: "no-store",
      HttpHeaders.pragmaHeader: "no-cache",
      HttpHeaders.authorizationHeader: "Bearer",
    });

    if (response.statusCode == 200) {
      final bodyJS = convert.jsonDecode(response.body);
      final String id = bodyJS["items"][0]["user_id"].toString();
      print("User SE id is $id");
      return id;
    } else {
      return null;
    }
  }
}
