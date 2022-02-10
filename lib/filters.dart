import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imagereader/utils/translate.dart';

class FilterScreen extends StatefulWidget {
  FilterScreen({Key key, this.text}) : super(key: key);
  String text;
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  TextEditingController editingController;

  String selectedText() =>
      editingController.selection.textInside(editingController.text);
  @override
  void initState() {
    // TODO: implement initState
    editingController = TextEditingController(text: widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future translateAndSet({to = 'hi'}) async {
    String str = await translate(editingController.text, to: to);
    print(str);
    if (str != null) {
      editingController.text = str;
      setState(() {});
    }
  }
}
