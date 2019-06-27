import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:whisky_app/views/whisky_detail/components/whisky_detail_description_widget.dart';
import 'package:whisky_app/views/whisky_detail/components/whisky_detail_header_widget.dart';

class WhiskyDetailPage extends StatefulWidget {
  WhiskyDetailPage(this.whisky);

  final Whisky whisky;

  @override
  _WhiskyDetailPageState createState() => _WhiskyDetailPageState(whisky);
}

class _WhiskyDetailPageState extends State<WhiskyDetailPage> {
  _WhiskyDetailPageState(this.whisky);

  final Whisky whisky;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('${whisky.name}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            WhiskyDetailHeader(whisky),
            Container(
              margin: EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).accentColor, width: 2.5))),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: WhiskyDetailDescription(whisky),
            )
          ],
        ),
      ),
    );
  }
}
