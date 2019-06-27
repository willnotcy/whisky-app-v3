import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:whisky_app/views/components/rating_bar_widget.dart';

class WhiskyDescription extends StatelessWidget {
  WhiskyDescription(this.whisky);

  final Whisky whisky;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315.0,
      height: 140.0,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 64.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                whisky.name,
                style: Theme.of(context).textTheme.headline,
              ),
              Text(
                'Distillery: ${whisky.distillery.name}',
                style: Theme.of(context).textTheme.subhead,
              ),
              Text(whisky.age != 0 ? 'Age: ${whisky.age}' : ''),
              RatingBar(whisky.rating)
            ],
          ),
        ),
      ),
    );
  }
}