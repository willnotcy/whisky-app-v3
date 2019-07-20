import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:whisky_app/services/math.dart';
import 'package:whisky_app/views/components/whisky_card_widget.dart';

class NewWhiskyEntryPage extends StatefulWidget {
  @override
  _NewWhiskyEntryPageState createState() => _NewWhiskyEntryPageState();
}

class _NewWhiskyEntryPageState extends State<NewWhiskyEntryPage> {
  final TextEditingController _filter = new TextEditingController();
  final _url = 'https://invincible-overcoat.glitch.me/whisky';
  bool _isBusy = false;

  List<Whisky> _whiskies = new List();
  List<Whisky> _filteredWhiskies = new List();

  void filterSearchResults(String filter) async {
    if (_isBusy || filter.length < 4) {
      return;
    }

    _isBusy = true;

    if (_whiskies.isEmpty || filter.length == 4) {
      _whiskies.clear();
      var response = await http.get('$_url?filter=$filter');
      print('$_url?filter=$filter');
      var items = json.decode(response.body);

      for (var whisky in items) {
        _whiskies.add(Whisky.fromJson(whisky));
      }

      debugPrint('added ${_whiskies.length} elements');
      _filteredWhiskies.addAll(_whiskies);
    } else {
      List<Whisky> temp = List();
      _filteredWhiskies.clear();
      if (filter.isEmpty) {
        setState(() {
          _filteredWhiskies.addAll(_whiskies);
        });
        return;
      }
      _whiskies.forEach((item) {
        if ('${(item.distillery.name ?? '').toLowerCase()} ${(item.name ?? '').toLowerCase()}'.contains(filter.toLowerCase())) {
          temp.add(item);
          debugPrint('Item: ${item.name}');
        }
      });
      setState(() {
        _filteredWhiskies.addAll(temp);
      });
    }

    _isBusy = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              print('Whisky saved');
            },
          )
        ],
        title: Text(
          'New whisky entry',
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              cursorColor: Theme.of(context).accentColor,
              controller: _filter,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: 'Search for whisky',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              key: new Key(Math.randomString(10)),
              shrinkWrap: true,
              itemCount: _filteredWhiskies.length,
              itemBuilder: (context, index) {
                return WhiskyCard(_filteredWhiskies[index], basic: true,);
              },
            ),
          )
        ]),
      ),
    );
  }
}
