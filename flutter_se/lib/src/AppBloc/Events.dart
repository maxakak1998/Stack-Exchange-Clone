import 'package:flutter/cupertino.dart';

abstract class AppEvent {}

class PreLoadEvent extends AppEvent {}

class LogoutEvent extends AppEvent {}
