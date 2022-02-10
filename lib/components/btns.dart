import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectButton extends StatefulWidget {
  bool isOn;
  Color offColor = Colors.grey.shade200;
  Color onColor = Colors.blueAccent.shade100;
  IconData icon;
  void Function() onTap;
  SelectButton({
    Key key,
    this.isOn = false,
    this.offColor,
    this.onColor,
    @required this.icon,
    @required this.onTap,
  }) : super(key: key);
  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: widget.isOn ? widget.onColor : widget.offColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: GestureDetector(
          child: Icon(
            widget.icon,
            size: 18,
          ),
          onTap: widget.onTap,
        ));
  }
}
