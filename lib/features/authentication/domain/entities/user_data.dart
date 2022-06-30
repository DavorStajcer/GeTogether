import 'package:equatable/equatable.dart';

class UserDataPublic extends Equatable {
  final String userId;
  final String username;
  final String imageUrl;
  final String city;
  final String country;
  final String description;
  final int friendsCount;
  final int numberOfVotes;
  final int rating;
  //final Map<String, dynamic> userEvents;

  UserDataPublic({
    required this.userId,
    required this.imageUrl,
    required this.username,
    this.city = "Unknown",
    this.country = "Unknown",
    this.description = "New to GeTogether app. Lets get together i guess.. :)",
    this.friendsCount = 0,
    this.numberOfVotes = 0,
    this.rating = -1,
    // this.userEvents = const {},
  });

  @override
  List<Object> get props => [
        userId,
        username,
        imageUrl,
        city,
        country,
        description,
        friendsCount,
        numberOfVotes,
        rating
      ];
}

class UserDataPrivate extends Equatable {
  final String email;
  final String password;

  UserDataPrivate({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
