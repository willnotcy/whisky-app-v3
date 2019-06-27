import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';

class WhiskyImage extends StatelessWidget {
  WhiskyImage(this.whisky);

  final Whisky whisky;

  @override
  Widget build(BuildContext context) {
    var usePlaceholder = whisky.image_url == '';

    return Hero(
      tag: whisky,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: !usePlaceholder
                  ? NetworkImage(whisky.image_url ?? '')
                  : AssetImage('assets/glencairn_glass.png'),
            )),
      ),
    );
  }
}