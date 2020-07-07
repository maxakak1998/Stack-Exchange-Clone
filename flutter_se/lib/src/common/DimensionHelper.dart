import 'package:flutter/material.dart';

Size dimensionHelper(BuildContext context) {
  var padding = MediaQuery.of(context).padding;
  double newHeight =
      MediaQuery.of(context).size.height - padding.top - padding.bottom;
  double width = MediaQuery.of(context).size.width;
  Size newSize = new Size(width, newHeight);
  return newSize;
}

double displayHeight(BuildContext context) {
  return dimensionHelper(context).height;
}

double displayWidth(BuildContext context) {
  return dimensionHelper(context).width;
}
