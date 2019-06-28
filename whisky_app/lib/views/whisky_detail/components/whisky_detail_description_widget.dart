import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:whisky_app/views/components/rating_bar_widget.dart';

class WhiskyDetailDescription extends StatelessWidget {
  WhiskyDetailDescription(this.whisky);

  final Whisky whisky;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes:', style: textTheme.subhead.copyWith(fontSize: 18.0)),
        Padding(
          padding: const EdgeInsets.only(top: 14.0, bottom: 26.0),
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
            style: textTheme.body1.copyWith(
              color: Colors.black45,
              fontSize: 16.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RatingBar(
                rating: whisky.nose,
                text: 'Nose',
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RatingBar(
              rating: whisky.taste,
              text: 'Taste',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'more',
              style: textTheme.body1.copyWith(
                fontSize: 16.0,
                color: theme.accentColor,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.0,
              color: theme.accentColor,
            )
          ],
        )
      ],
    );
  }
}