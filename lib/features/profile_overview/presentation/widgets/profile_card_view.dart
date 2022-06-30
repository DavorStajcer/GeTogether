import 'package:flutter/material.dart';
import 'package:get_together_app/features/authentication/domain/entities/user_data.dart';
import 'package:get_together_app/features/profile_overview/presentation/widgets/decription_with_friends_and_rating.dart';
import 'package:get_together_app/features/profile_overview/presentation/widgets/edit_and_settings.dart';
import 'package:get_together_app/features/profile_overview/presentation/widgets/friends_and_rating.dart';
import 'package:get_together_app/features/profile_overview/presentation/util/profile_card_clipper.dart';
import 'package:get_together_app/features/profile_overview/presentation/widgets/profile_picture_view.dart';

class ProfileCardView extends StatelessWidget {
  final double picHeight;
  final UserDataPublic currentUserData;
  const ProfileCardView({
    Key? key,
    required this.picHeight,
    required this.currentUserData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ClipPath(
          clipper: ProfileCardClipper(picHeight: picHeight),
          child: Card(
            child: Column(
              children: [
                EditAndSettings(
                  picHeight: picHeight,
                  currentUserData: currentUserData,
                ),
                Container(
                  width: double.infinity,
                  height: 20,
                  alignment: Alignment.center,
                  child: Text(
                    currentUserData.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 15,
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      currentUserData.city + ", " + currentUserData.country,
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    child: SingleChildScrollView(
                      child: Text(
                        currentUserData.description,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ), /* DescriptionWithFriendsAndRating(
                    description: currentUserData.description,
                    friendsNum: currentUserData.friendsCount,
                    rating: currentUserData.rating,
                  ), */
                ),
              ],
            ),
          ),
        ),
        ProfilePictureView(
          picHeight: picHeight,
          imageUrl: currentUserData.imageUrl,
        ),
      ],
    );
  }
}
