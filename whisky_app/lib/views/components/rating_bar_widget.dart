import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class RatingBar extends StatelessWidget {
  final double rating;
  final String text;
  final double size;
  final double fontSize;
  final MainAxisAlignment mainAxisAlignment;
  final RatingChangeCallback onRatingChanged;

  RatingBar(
      {this.rating = 0.0,
      this.text,
      this.fontSize,
      this.size = 25.0,
      this.mainAxisAlignment,
      this.onRatingChanged}) {
    assert(this.rating != null);
  }

  Widget _buildRatingBar(context, index) {
    var theme = Theme.of(context);
    Icon star;

    if (index >= rating) {
      star = Icon(Icons.star, color: Colors.black12, size: this.size,);
    } else if (index == (rating - 0.5) && index < rating) {
      star = Icon(Icons.star_half, color: theme.accentColor, size: this.size,);
    } else {
      star = Icon(Icons.star, color: theme.accentColor, size: this.size,);
    }

    if(onRatingChanged == null) {
      return star;
    }

    return new GestureDetector(
      onTap: () {
        if (this.onRatingChanged != null) {
          onRatingChanged(index + 1.0);
        }
      },
      onHorizontalDragUpdate: (dragDetails) {
        RenderBox box = context.findRenderObject();
        var _pos = box.globalToLocal(dragDetails.globalPosition);
        var i = (_pos.dx - (size * 2)) / size;
        var newRating = i;
        if(newRating > 6) {
          newRating = 6.0;
        } else if (newRating < 0) {
          newRating = 0.0;
        }
        if(this.onRatingChanged != null) {
          onRatingChanged(newRating);
        }
      },
      child: star,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var renderText = text != null;

    var starRating = Column(
      children: <Widget>[
        Row(
          children: List.generate(6, (index) => _buildRatingBar(context, index)),
        ),
        renderText
            ? Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  text ?? '',
                ),
              )
            : Container(
                height: 0,
                width: 0,
              )
      ],
    );

    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: <Widget>[
        Text(
          rating.toString(),
          style: textTheme.title.copyWith(fontSize: fontSize),
        ),
        SizedBox(
          width: 8.0,
        ),
        starRating,
      ],
    );
  }
}
