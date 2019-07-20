import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:whisky_app/views/home/components/bottom_nav_bar_widget.dart';
import 'package:whisky_app/views/new_whisky/new_entry_widget.dart';
import 'package:whisky_app/views/new_whisky/new_whisky_widget.dart';
import 'package:whisky_app/views/placeholder_widget.dart';
import 'package:whisky_app/views/whiskies/whiskies_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    Whiskies(),
    PlaceholderWidget(Colors.blueGrey),
  ];

  onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future _showNewWhiskyPage() async {
    Whisky whisky = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return NewWhiskyEntryPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Whisky App'),
      ),
      body: _children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () {
                _showNewWhiskyPage();
              },
              backgroundColor: theme.accentColor,
              tooltip: 'Add Whisky',
              child: Icon(Icons.add),
              elevation: 2.0,
            )
          : null,
      bottomNavigationBar: BottomNavBar(onTabTapped),
    );
  }
}
