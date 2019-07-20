import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:whisky_app/views/components/rating_bar_widget.dart';

class WhiskyDescription extends StatelessWidget {
  WhiskyDescription(this.whisky, {this.basic});

  final Whisky whisky;
  final bool basic;

  Widget _buildBasicDescription(BuildContext context) {
    var description =
        '${whisky.distillery.name} ${whisky.age != 0 ? '${whisky.age}Y' : ''} ${whisky.name} - ${whisky.abv} ${whisky.volume} ${whisky.distilled}/${whisky.bottled}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          description,
          style: Theme.of(context).textTheme.title
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          whisky.name,
          style: Theme.of(context).textTheme.title,
        ),
        Text(
          'Distillery: ${whisky.distillery.name}',
          style: Theme.of(context).textTheme.subhead,
        ),
        Text(whisky.age != 0 ? 'Age: ${whisky.age}' : ''),
        whisky.rating != 0 ? RatingBar(rating: whisky.rating) : Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315.0,
      height: 140.0,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 64.0),
          child: basic == false ? _buildDescription(context) : _buildBasicDescription(context)
        ),
      ),
    );
  }
}
