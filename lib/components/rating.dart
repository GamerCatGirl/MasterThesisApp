import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rating extends StatefulWidget {
  final String question;
  final void Function(double) onChangeRating;

  const Rating(
      {super.key, required this.question, required this.onChangeRating});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    final ratingWidget = RatingBar.builder(
        itemCount: 5,
        itemSize: 30,
        itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
        onRatingUpdate: (rating) {
          widget.onChangeRating(rating);
        });

    return Row(
      children: [
        Spacer(),
        SizedBox(
          width: 600,
          child: Text(widget.question),
        ),
        Spacer(),
        ratingWidget,
        Spacer(),
      ],
    );
  }
}
