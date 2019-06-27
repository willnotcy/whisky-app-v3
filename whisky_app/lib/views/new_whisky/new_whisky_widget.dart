import 'package:flutter/material.dart';

class NewWhiskyPage extends StatefulWidget {
  @override
  _NewWhiskyPageState createState() => _NewWhiskyPageState();
}

class _NewWhiskyPageState extends State<NewWhiskyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New whisky entry',
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                    decoration: InputDecoration(
                  labelText: "Name",
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                    decoration: InputDecoration(
                  labelText: "Age",
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                    decoration: InputDecoration(
                  labelText: "Distillery",
                )),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    return RaisedButton(
                      onPressed: () => print('PRESSED'),
                      child: Text('Add whisky'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}