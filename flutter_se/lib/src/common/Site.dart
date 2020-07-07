import 'package:flutter/cupertino.dart';

class Site {
  String _name;
  String _high_resolution_icon_url;
  String _description;
  Image _image;
  String _paramAPI;
  String _siteType;
  Site(String name, String imageUrl,
      {String description = "", String paramAPI, String siteType}) {
    this._paramAPI = paramAPI;
    this._name = name;
    this._high_resolution_icon_url = imageUrl;
    this._description = description;
    _image = _high_resolution_icon_url == null
        ? null
        : Image.network(
            this._high_resolution_icon_url,
            height: 30.0,
            width: 30.0,
          );
    this._siteType = siteType;
  }
  get getName => this._name;

  get getIcon => this._image;

  get getIconUrl => this._high_resolution_icon_url;

  get getDescription => this._description;

  get getParamAPI => this._paramAPI;

  get getSiteType => this._siteType;
}
