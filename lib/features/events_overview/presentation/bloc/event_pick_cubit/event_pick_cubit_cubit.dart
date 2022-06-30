import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'picked_event_state.dart';

class EventPickCubit extends Cubit<PickedEventState> {
  EventPickCubit()
      : super(PickedEventState(pickedEventId: null, location: null));

  void eventPicked(String eventId, LatLng location) =>
      emit(PickedEventState(pickedEventId: eventId, location: location));
}
