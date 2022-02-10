import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imagereader/utils/translate.dart';

class EditTextScreen extends StatefulWidget {
  EditTextScreen({Key key, this.text}) : super(key: key);
  String text;
  @override
  _EditTextScreenState createState() => _EditTextScreenState();
}

class _EditTextScreenState extends State<EditTextScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              Navigator.pop(context, editingController.text);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, top: 10, right: 10),
              child: TextField(
                autofocus: true,
                controller: editingController,
                maxLines: 20,
//                toolbarOptions: ,
              ),
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    await translateAndSet();
                  },
                  child: const Text(
                    'Translate To Hindi',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    await translateAndSet(to: 'en');
                  },
                  child: const Text(
                    'Translate To English',
                    style: TextStyle(fontSize: 14),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
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
