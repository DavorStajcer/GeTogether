/* import 'package:get_together_app/features/profile_overview/domain/entities/user_profile_data.dart';

abstract class UserProfileModel {
  Map<String, dynamic> toJsonMap();
}

class UserProfileDataModel extends UserProfileData implements UserProfileModel {
  UserProfileDataModel({
    required String userId,
    required String username,
    required String imageUrl,
    required String city,
    required String country,
    required String description,
    required int friendsCount,
    required int rating,
    required int numberOfVotes,
  }) : super(
          userId: userId,
          username: username,
          imageUrl: imageUrl,
          city: city,
          country: country,
          description: description,
          friendsCount: friendsCount,
          rating: rating,
          numberOfVotes: numberOfVotes,
        );

       

  factory UserProfileDataModel.fromJsonMap(Map<String, dynamic> jsonMap) =>
      UserProfileDataModel(
        userId: jsonMap["userId"],
        username: jsonMap["username"],
        imageUrl: jsonMap["imageUrl"],
        city: jsonMap["city"],
        country: jsonMap["country"],
        description: jsonMap["description"],
        friendsCount: jsonMap["friendsCount"],
        rating: jsonMap["rating"],
        numberOfVotes: jsonMap["numberOfVotes"],
      );

  Map<String, dynamic> toJsonMap() => {
        "userId": userId,
        "imageUrl": imageUrl,
        "username": username,
        "city": city,
        "country": country,
        "description": description,
        "friendsCount": friendsCount,
        "rating": rating,
        "numberOfVotes": numberOfVotes,
      };
}
 */