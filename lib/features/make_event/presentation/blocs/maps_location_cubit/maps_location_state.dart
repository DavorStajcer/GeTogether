part of 'maps_location_cubit.dart';

abstract class MapsLocationState extends Equatable {
  const MapsLocationState();

  @override
  List<Object> get props => [];
}

class MapsLocationNotLoaded extends MapsLocationState {}

class MapsLocationLoaded extends MapsLocationState {
  final Position currentPosition;
  MapsLocationLoaded({required this.currentPosition});
}

class MapsLocationFailure extends MapsLocationState {
  final String errorMessage;
  MapsLocationFailure({required this.errorMessage});
}
