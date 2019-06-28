import 'package:flutter/material.dart';
import 'package:whisky_app/models/distillery.dart';
import 'package:whisky_app/services/database_client.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class NewWhiskyPage extends StatefulWidget {
  @override
  _NewWhiskyPageState createState() => _NewWhiskyPageState();
}

class _NewWhiskyPageState extends State<NewWhiskyPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  AutoCompleteTextField distilleryTextField;
  GlobalKey<AutoCompleteTextFieldState<Distillery>> key = new GlobalKey();

  final DatabaseClient _client = DatabaseClient.instance;
  List<Distillery> _distilleries = new List();

  @override
  void initState() {
    loadDistilleries();
    super.initState();
  }

  Future loadDistilleries() async {
    var result = await _client.getDistilleries();
    setState(() {
     _distilleries.addAll(result); 
    });
  }

  Widget row(Distillery distillery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(distillery.name),
        ),
        Text(distillery.region)
      ],
    );
  }

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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                    controller: nameController,
                    onChanged: (v) => nameController.text = v,
                    decoration: InputDecoration(
                      labelText: "Name",
                    )),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                    controller: ageController,
                    onChanged: (v) => nameController.text = v,
                    decoration: InputDecoration(
                      labelText: "Age",
                    )),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: distilleryTextField = AutoCompleteTextField<Distillery>(
                  key: key,
                  suggestions: _distilleries,
                  clearOnSubmit: false,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  suggestionsAmount: 8,
                  decoration: InputDecoration(
                    labelText: 'Distillery',
                  ),
                  itemFilter: (item, query) {
                    return item.name.toLowerCase().startsWith(query.toLowerCase());
                  },
                  itemSorter: (a, b) {
                    return a.name.compareTo(b.name);
                  },
                  itemSubmitted: (item) {
                      setState(() {
                        distilleryTextField.textField.controller.text = item.name;
                      });
                  },
                  itemBuilder: (context, item) {
                    return row(item);
                  },
                )
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
