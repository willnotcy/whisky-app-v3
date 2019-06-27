import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar(this._callback);

  final Function(int) _callback;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BottomAppBar(
      color: theme.primaryColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              _callback(0);
            },
          ),
          IconButton(
            icon: Icon(Icons.landscape),
            color: Colors.white,
            onPressed: () {
              _callback(1);
            },
          )
        ],
      ),
      shape: CircularNotchedRectangle(),
    );
  }
}
