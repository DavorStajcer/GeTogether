part of 'event_pick_cubit_cubit.dart';

class PickedEventState extends Equatable {
  final String? pickedEventId;
  final LatLng? location;
  PickedEventState({required this.pickedEventId, required this.location});

  @override
  List<Object?> get props => [pickedEventId];
}
