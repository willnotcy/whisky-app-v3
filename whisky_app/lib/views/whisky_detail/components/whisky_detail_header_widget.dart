import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky.dart';
import 'package:whisky_app/views/components/rating_bar_widget.dart';

class WhiskyDetailHeader extends StatelessWidget {
  WhiskyDetailHeader(this.whisky);

  final Whisky whisky;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 140.0,
            ),
            child: Image.asset(
              whisky.distillery.image_url ??
                  'assets/glencairn_glass.png',
              height: 200,
              width: 500,
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Hero(
                    tag: whisky,
                    child: Material(
                      borderRadius: BorderRadius.circular(4.0),
                      elevation: 2.0,
                      child: Image.network(
                        whisky.image_url,
                        fit: BoxFit.cover,
                        height: 180.0,
                        width: 100.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(whisky.name,
                            style: textTheme.title),
                      ),
                      Text(
                        'Distilled at ${whisky.distillery.name} distillery in ${whisky.distillery.region}.' +
                            (whisky.age != 0
                                ? ' Matured for ${whisky.age} years.'
                                : ''),
                        style: textTheme.subhead,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                        child: RatingBar(
                          whisky.rating,
                          text: 'Overall rating',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
