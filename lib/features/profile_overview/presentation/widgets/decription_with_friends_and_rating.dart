import "package:flutter/material.dart";
import 'package:get_together_app/features/profile_overview/presentation/widgets/friends_and_rating.dart';

class DescriptionWithFriendsAndRating extends StatelessWidget {
  final int friendsNum;
  final int rating;
  final String description;
  const DescriptionWithFriendsAndRating({
    Key? key,
    required this.description,
    required this.friendsNum,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: SingleChildScrollView(
              child: Text(description),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: FriendsAndRating(
            rating: rating,
            friendsNum: friendsNum,
          ),
        ),
      ],
    );
  }
}
