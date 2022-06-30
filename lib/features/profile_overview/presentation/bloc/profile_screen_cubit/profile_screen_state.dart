part of 'profile_screen_cubit.dart';

abstract class ProfileScreenState extends Equatable {
  const ProfileScreenState();

  @override
  List<Object> get props => [];
}

class ProfileScreenLoading extends ProfileScreenState {}

class ProfileScreenView extends ProfileScreenState {
  final UserDataPublic userProfileData;
  ProfileScreenView({required this.userProfileData});

  @override
  List<Object> get props => [userProfileData];
}

class ProfileScreenEdit extends ProfileScreenState {
  final UserDataPublic lastUserData;
  ProfileScreenEdit({
    required this.lastUserData,
  });

  ProfileScreenEdit copyWith({
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
      ProfileScreenEdit(
          lastUserData: UserModelPublic(
        userId: userId ?? this.lastUserData.userId,
        username: username ?? this.lastUserData.username,
        imageUrl: imageUrl ?? this.lastUserData.imageUrl,
        city: city ?? this.lastUserData.city,
        country: country ?? this.lastUserData.country,
        description: description ?? this.lastUserData.description,
        friendsCount: friendsCount ?? this.lastUserData.friendsCount,
        numberOfVotes: numberOfVotes ?? this.lastUserData.numberOfVotes,
        rating: rating ?? this.lastUserData.rating,
      ));

  @override
  List<Object> get props => [lastUserData];
}

class ProfileScreennNetworkError extends ProfileScreenState {
  final String message;
  ProfileScreennNetworkError({
    required this.message,
  });
}

class ProfileScreenServerError extends ProfileScreenState {
  final String message;
  ProfileScreenServerError({
    required this.message,
  });
}
