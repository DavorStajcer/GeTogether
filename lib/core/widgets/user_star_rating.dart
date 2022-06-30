import 'package:flutter/material.dart';

class UserStarRating extends StatelessWidget {
  final int rating;
  const UserStarRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _starColor = Theme.of(context).primaryColor;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        child: Row(
          children: _mapRatingToIcons(rating: rating, starColor: _starColor),
        ),
      ),
    );
  }
}

List<Widget> _mapRatingToIcons({
  required int rating,
  required Color starColor,
}) {
  if (rating == -1) return _buildZeroReviewsRating();

  const int max_rating = 10;
  final List<Widget> _listOfIcons = [];

  for (int i = 2; i < max_rating + 1; i = i + 2) {
    if (i < rating)
      _listOfIcons.add(
        Icon(
          Icons.star,
          color: starColor,
        ),
      );
    else if (i == rating + 1)
      _listOfIcons.add(
        Icon(
          Icons.star_half,
          color: starColor,
        ),
      );
    else
      _listOfIcons.add(
        Icon(Icons.star, color: Colors.grey),
      );
  }
  return _listOfIcons;
}

List<Widget> _buildZeroReviewsRating() => [
      Icon(
        Icons.star,
        color: Colors.grey,
      ),
      Icon(
        Icons.star,
        color: Colors.grey,
      ),
      Icon(
        Icons.star,
        color: Colors.grey,
      ),
      Icon(
        Icons.star,
        color: Colors.grey,
      ),
      Icon(
        Icons.star,
        color: Colors.grey,
      ),
    ];
