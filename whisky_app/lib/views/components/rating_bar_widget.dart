import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final String text;
  final double fontSize;
  final MainAxisAlignment mainAxisAlignment;

  RatingBar(this.rating, {this.text, this.fontSize, this.mainAxisAlignment});

  Widget _buildRatingBar(ThemeData theme) {
    var stars = <Widget>[];

    for (var i = 1; i <= 6; i++) {
      var star;

      if (i <= rating) {
        star = Icon(Icons.star, color: theme.accentColor);
        stars.add(star);
      } else if (rating % 1 == 0){
        star = Icon(Icons.star, color: Colors.black12);
        stars.add(star);
      } else {
        star = Icon(Icons.star_half, color: theme.accentColor);
        stars.add(star);

        i++;
        while(i <= 6) {
          star = Icon(Icons.star, color: Colors.black12);
          stars.add(star);
          i++;
        }

        break;
      }
    }

    return Row(
      children: stars,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var renderText = text != null;

    var starRating = Column(
      children: <Widget>[
        _buildRatingBar(theme),
        renderText ? 
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              text ?? '',
            ),
          ) : Container(height: 0, width: 0,)
      ],
    );

    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: <Widget>[
        Text(
          rating.toString(),
          style: textTheme.title
              .copyWith(fontSize: fontSize),
        ),
        SizedBox(
          width: 8.0,
        ),
        starRating,
      ],
    );
  }
}
