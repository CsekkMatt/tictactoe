import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DifficultyWidget extends StatefulWidget {
  DifficultyWidget({this.onSelectParameter});
  Function(String) onSelectParameter;

  @override
  _SettingsWidgetState createState() => new _SettingsWidgetState();
}

class _SettingsWidgetState extends State<DifficultyWidget> {
  List _difficulties = ["Normal", "Minimax"];
  String _currentDifficulty;
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentDifficulty = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
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
      print(selectedDifficulty);
      _currentDifficulty = selectedDifficulty;
      widget.onSelectParameter(selectedDifficulty);
    });
  }
}
