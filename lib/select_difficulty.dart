import 'package:flutter/material.dart';

class DifficultyWidget extends StatefulWidget {
  DifficultyWidget({Key key}) : super(key: key);

  @override
  _SettingsWidgetState createState() => new _SettingsWidgetState();
}

class _SettingsWidgetState extends State<DifficultyWidget> {
  List _difficulties = ["Minimax"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentDifficulty;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentDifficulty = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _difficulties) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: new Center(
          child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Please choose the difficulty"),
          new Container(
            padding: new EdgeInsets.all(16.0),
          ),
          new DropdownButton(
            value: _currentDifficulty,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          )
        ],
      )),
    );
  }

  void changedDropDownItem(String selectedDifficulty) {
    setState(() {
      _currentDifficulty = selectedDifficulty;
    });
  }
}
