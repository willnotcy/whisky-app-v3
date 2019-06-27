import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:whisky_app/services/database_client.dart';
import 'package:whisky_app/views/whiskies/components/whisky_card_widget.dart';

class Whiskies extends StatefulWidget {
  @override
  _WhiskiesState createState() => _WhiskiesState();
}

class _WhiskiesState extends State<Whiskies> {
  final TextEditingController _filter = new TextEditingController();
  final DatabaseClient _client = DatabaseClient.instance;

  List<Whisky> whiskies = new List();
  List<Whisky> _filteredWhiskies = new List();

  @override
  void initState() {
    loadWhiskies();
    super.initState();
    
  }

  void loadWhiskies() async {
    var result = await _client.getWhiskies();
    whiskies.addAll(result);
    setState(() {
      _filteredWhiskies.addAll(whiskies);
    });
  }

  String randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return new String.fromCharCodes(codeUnits);
  }

  void filterSearchResults(String filter) {
    List<Whisky> temp = List();
    _filteredWhiskies.clear();
    if (filter.isEmpty) {
      setState(() {
        _filteredWhiskies.addAll(whiskies);
      });
      return;
    }
    whiskies.forEach((item) {
      if (item.name.toLowerCase().contains(filter) ||
          item.distillery.name.toLowerCase().contains(filter) ||
          item.distillery.region.toLowerCase().contains(filter)) {
        temp.add(item);
        debugPrint('Item: ${item.name}');
      }
    });
    setState(() {
      _filteredWhiskies.addAll(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Column(
          children: <Widget>[
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
                  hintText: 'Search for whisky, distillery or region',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                key: new Key(randomString(10)),
                shrinkWrap: true,
                itemCount: _filteredWhiskies.length,
                itemBuilder: (context, index) {
                  return WhiskyCard(_filteredWhiskies[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
