import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whisky_app/models/distillery.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:whisky_app/services/database_client.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:whisky_app/views/components/rating_bar_widget.dart';
import 'package:whisky_app/services/math.dart';
import 'package:whisky_app/views/new_whisky/components/image_picker_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewWhiskyPage extends StatefulWidget {
  @override
  _NewWhiskyPageState createState() => _NewWhiskyPageState();
}

class _NewWhiskyPageState extends State<NewWhiskyPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  AutoCompleteTextField distilleryTextField;
  GlobalKey<AutoCompleteTextFieldState<Whisky>> key = new GlobalKey();

  final DatabaseClient _client = DatabaseClient.instance;
  List<Whisky> _distilleries = new List();

  Whisky whisky = new Whisky();

  @override
  void initState() {
    super.initState();
    loadDistilleries();
  }

  Future loadDistilleries() async {
    var result = await http.get('http://10.0.2.2:3000/whisky');

    debugPrint('----------- ${result.statusCode}');

    var list = json.decode(result.body);

    var distilleries = new List<Whisky>();

    for (var item in list) {
      var distillery = Whisky.fromJson(item);
      distilleries.add(distillery);
    }

  

    setState(() {
     _distilleries.addAll(distilleries); 
    });
  }

  Widget row(Whisky distillery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(distillery.name),
        ),
        Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(distillery.image_url ?? '')
            )),
      ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {print('Whisky saved');},
          )
        ],
        title: Text(
          'New whisky entry',
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 32.0, right: 32.0, top: 8.0),
                child: TextField(
                    controller: nameController,
                    onChanged: (v) => nameController.value = nameController.value.copyWith(text: v),
                    decoration: InputDecoration(
                      labelText: "Name",
                      
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 32.0, right: 32.0, top: 8.0),
                child: TextField(
                    controller: ageController,
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    onChanged: (v) => ageController.value = ageController.value.copyWith(text: v),
                    decoration: InputDecoration(
                      labelText: "Age",
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 32.0, right: 32.0, top: 8.0),
                child: distilleryTextField = AutoCompleteTextField<Whisky>(
                  key: key,
                  suggestions: _distilleries,
                  clearOnSubmit: false,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  suggestionsAmount: 8,
                  decoration: InputDecoration(
                    labelText: 'Distillery',
                  ),
                  itemFilter: (item, query) {
                    return '${item.distillery.name.toLowerCase() ?? ''} ${item.name.toLowerCase() ?? ''}'.contains(query.toLowerCase());
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
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 32.0, right: 32.0, top: 8.0),
                child: TextField(
                    controller: notesController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (v) => notesController.value = notesController.value.copyWith(text: v),
                    decoration: InputDecoration(
                      labelText: "Notes",
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 0.0, right: 32.0, top: 32.0),
                child: RatingBar(
                  rating: whisky.nose,
                  text: 'Nose',
                  mainAxisAlignment: MainAxisAlignment.center,
                  size: 40,
                  onRatingChanged: (v) {
                    setState(() {
                      whisky.nose = Math.roundHalf(v); 
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 0.0, right: 32.0, top: 32.0),
                child: RatingBar(
                  rating: whisky.taste,
                  text: 'Taste',
                  mainAxisAlignment: MainAxisAlignment.center,
                  size: 40,
                  onRatingChanged: (v) {
                    setState(() {
                      whisky.taste = Math.roundHalf(v); 
                    });
                  },
                ),
              ),
              ImagePickerButton(),
            ],
          ),
        ),
      ),
    );
  }
}
