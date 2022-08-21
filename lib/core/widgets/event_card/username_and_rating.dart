import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get_together_app/core/widgets/user_star_rating.dart';

class UsernameAndRating extends StatelessWidget {
  final int rating;
  //final int numberOfPeople;
  final String adminUsername;
  final String eventName;

  const UsernameAndRating({
    Key? key,
    required this.rating,
    required this.adminUsername,
    //required this.numberOfPeople,
    required this.eventName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 16,
          child: const SizedBox(),
          /*     child: AutoSizeText(
            "$numberOfPeople people",
            style: TextStyle(color: Colors.grey),
          ) */
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          height: 30,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              eventName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          height: 20,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              children: [
                Text(
                  "admin:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
                Text(
                  adminUsername,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),

        //UserStarRating(rating: 5),
      ],
    );
  }
}
