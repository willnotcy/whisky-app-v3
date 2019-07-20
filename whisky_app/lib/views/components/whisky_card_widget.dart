import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:whisky_app/views/placeholder_widget.dart';
import 'package:whisky_app/views/components/whisky_description_widget.dart';
import 'package:whisky_app/views/components/whisky_image_widget.dart';
import 'package:whisky_app/views/whisky_detail/whisky_detail_widget.dart';

class WhiskyCard extends StatefulWidget {
  WhiskyCard(this.whisky, {this.basic = false});

  final Whisky whisky;
  final bool basic;

  @override
  _WhiskyCardState createState() => _WhiskyCardState(whisky, basic: basic);
}

class _WhiskyCardState extends State<WhiskyCard> {
  _WhiskyCardState(this.whisky, {this.basic});

  Whisky whisky;
  bool basic;

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
                child: WhiskyDescription(whisky, basic: basic,),
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