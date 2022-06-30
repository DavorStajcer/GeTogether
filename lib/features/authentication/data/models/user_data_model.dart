import '../../domain/entities/user_data.dart';

abstract class UserDataModel {
  Map<String, dynamic> toJsonMap();
}

class UserModelPublic extends UserDataPublic implements UserDataModel {
  UserModelPublic({
    required String userId,
    required String username,
    required String imageUrl,
    String? city,
    String? country,
    String? description,
    int? friendsCount,
    int? numberOfVotes,
    int? rating,
  }) : super(
          userId: userId,
          username: username,
          imageUrl: imageUrl,
          city: city ?? "SomeCity",
          country: country ?? "SomeCity",
          description: description ??
              "New to GeTogether app. Lets get together i guess.. :)",
          friendsCount: friendsCount ?? 0,
          numberOfVotes: numberOfVotes ?? 0,
          rating: rating ?? -1,
        );

  factory UserModelPublic.fromJsonMap(Map<String, dynamic> jsonMap) =>
      UserModelPublic(
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

class UserModelPrivate extends UserDataPrivate implements UserDataModel {
  UserModelPrivate({
    required String email,
    required String password,
  }) : super(
          email: email,
          password: password,
        );

  factory UserModelPrivate.fromJsonMap(Map<String, dynamic> jsonMap) =>
      UserModelPrivate(
        email: jsonMap["email"],
        password: jsonMap["password"],
      );

  Map<String, dynamic> toJsonMap() => {
        "email": this.email,
        "password": this.password,
      };

  /*   UserModelPublic copyWith({
    String? userId,
    String? username,
    String? imageUrl,
    String? city,
    String? country,
    String? description,
    int? friendsCount,
    int? numberOfVotes,
    int? rating,
  }) =>
      UserModelPublic(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        imageUrl: imageUrl ?? this.imageUrl,
        city: city ?? this.city,
        country: country ?? this.country,
        description: description ?? this.description,
        friendsCount: friendsCount ?? this.friendsCount,
        numberOfVotes: numberOfVotes ?? this.numberOfVotes,
        rating: rating ?? this.rating,
      ); */
}
