import 'package:flutter/material.dart';
import 'package:get_together_app/core/widgets/user_star_rating.dart';

class FriendsAndRating extends StatelessWidget {
  final int rating;
  final int friendsNum;
  const FriendsAndRating(
      {Key? key, required this.rating, required this.friendsNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(friendsNum.toString()),
              Text("Friends"),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: VerticalDivider(),
          ),
          UserStarRating(
            rating: rating,
          ),
        ],
      ),
    );
  }
}
