import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:math";

class AboutButton extends StatefulWidget {
  final String title;
  final TextStyle textStyle;
  AboutButton({this.title = "", this.textStyle = const TextStyle()})
      : assert(title != null, "Title can't be null"),
        assert(textStyle != null, "Text style cant be null");

  @override
  _AboutButtonState createState() => _AboutButtonState();
}

class _AboutButtonState extends State<AboutButton> {
  bool isFocus = false;
  Color color;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    color = Colors.grey[200];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onLongPress: _onLongPress,
      onLongPressEnd: _onLongPressCancel,
      child: AnimatedContainer(
        decoration: BoxDecoration(
            color: color, border: Border.all(color: Colors.grey[300])),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        alignment: Alignment.center,
        onEnd: _onAnimationEnded,
        duration: new Duration(milliseconds: 300),
        child: Text(
          widget.title,
          style: widget.textStyle,
        ),
      ),
    );
  }

  void _onTapCancel() {
    print("Tap cancel");

    setState(() {
      isFocus = false;
      color = Colors.grey[350];
    });
  }

  void _onTap() async {
    print("Tap");
    setState(() {
      isFocus = true;
      color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    });
    isFocus = false;
    await Future.delayed(new Duration(milliseconds: 301), () {
      print("Turn off");
      setState(() {
        color = Colors.grey[350];
      });
    });
  }

  void _onLongPress() {
    setState(() {
      isFocus = true;
      color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    });
  }

  void _onLongPressCancel(_) {
    setState(() {
      isFocus = false;
    });
  }

  void _onAnimationEnded() {
    print("Animated end");
    if (isFocus) {
      setState(() {
        color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      });
      return;
    } else {
      setState(() {
        color = Colors.grey[50];
      });
    }
  }
}
