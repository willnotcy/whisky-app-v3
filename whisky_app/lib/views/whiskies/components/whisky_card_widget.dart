import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:whisky_app/views/placeholder_widget.dart';
import 'package:whisky_app/views/whiskies/components/whisky_description_widget.dart';
import 'package:whisky_app/views/whiskies/components/whisky_image_widget.dart';
import 'package:whisky_app/views/whisky_detail/whisky_detail_widget.dart';

class WhiskyCard extends StatefulWidget {
  WhiskyCard(this.whisky);

  final Whisky whisky;

  @override
  _WhiskyCardState createState() => _WhiskyCardState(whisky);
}

class _WhiskyCardState extends State<WhiskyCard> {
  _WhiskyCardState(this.whisky);

  Whisky whisky;

  showWhiskyDetailPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return WhiskyDetailPage(whisky);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showWhiskyDetailPage,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          height: 130.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 50.0,
                child: WhiskyDescription(whisky),
              ),
              Positioned(
                top: 15.5,
                child: WhiskyImage(whisky),
              )
            ],
          ),
        ),
      ),
    );
  }
}