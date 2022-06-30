import 'package:equatable/equatable.dart';

class UserProfileData extends Equatable {
  final String userId;
  final String username;
  final String imageUrl;
  final String city;
  final String country;
  final String description;
  final int friendsCount;
  final int rating;
  final int numberOfVotes;

  UserProfileData({
    required this.userId,
    required this.username,
    required this.imageUrl,
    required this.city,
    required this.country,
    required this.description,
    required this.friendsCount,
    required this.rating,
    required this.numberOfVotes,
  });

  @override
  List<Object?> get props => [
        username,
        city,
        country,
        description,
        friendsCount,
        rating,
        numberOfVotes,
      ];
}
