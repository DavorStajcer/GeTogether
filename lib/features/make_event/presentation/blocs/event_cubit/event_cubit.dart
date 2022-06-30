import 'dart:developer';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/util/date_formater.dart';
import 'package:get_together_app/features/make_event/domain/entities/create_event_data.dart';
import 'package:get_together_app/features/make_event/domain/usecases/create_event.dart';
import 'package:get_together_app/features/make_event/domain/usecases/listen_to_user_location_change.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String stateErrorMessage =
    "We experienced a bug in the application, please try again.";

class EventCubit extends Cubit<EventState> {
  final ListenToUserLocationChange listenToUserLocationChange;
  final CreateEvent _createEvent;
  final DateFormater dateFormater = DateFormater();
  EventCubit(
    this._createEvent, {
    DateFormater? dateFormater,
    required this.listenToUserLocationChange,
  }) : super(EventStateUnfinished());

  void eventTypeChanged(EventType newType) {
    final CreateEventData newData =
        (state as EventStateUnfinished).createEventData.copyWith(type: newType);
    _emitNewSate(newData);
  }

  void eventNameChanged(String newEventName) {
    final CreateEventData newData = (state as EventStateUnfinished)
        .createEventData
        .copyWith(eventName: newEventName);
    _emitNewSate(newData);
  }

  void evenLocationChanged(LatLng newlocation) {
    if (isEventLocationOutOfRange(newlocation,
        (state as EventStateUnfinished).createEventData.currentUserPosition)) {
      final newState = EventStateLocationOutOfRange.fromUnfinishedState(
          (state as EventStateUnfinished));
      emit(newState.copyWith(location: newlocation));
    } else {
      final CreateEventData newData = (state as EventStateUnfinished)
          .createEventData
          .copyWith(location: newlocation);
      _emitNewSate(newData);
    }
  }

  void makeEventScreenInitialized() {
    listenToUserLocationChange(this);
  }

  void stopListeningToLocationChnages() {
    listenToUserLocationChange.stop();
  }

  void userLocationChanged(LatLng newUserLocation) {
    final oldPosition =
        (state as EventStateUnfinished).createEventData.currentUserPosition;
    log(calculateDistance(newUserLocation.latitude, newUserLocation.longitude,
            oldPosition.latitude, oldPosition.longitude)
        .toString());
    if (calculateDistance(newUserLocation.latitude, newUserLocation.longitude,
            oldPosition.latitude, oldPosition.longitude) <
        0.05) return;
    if (isEventLocationOutOfRange(
        (state as EventStateUnfinished).createEventData.location,
        newUserLocation)) {
      emit(EventStateLocationOutOfRange.fromUnfinishedState(
          (state as EventStateUnfinished)
              .copyWith(currentUserPosition: newUserLocation)));
    } else {
      final CreateEventData newData = (state as EventStateUnfinished)
          .createEventData
          .copyWith(currentUserPosition: newUserLocation);
      _emitNewSate(newData);
    }
  }

  void setInitialLocation(LatLng initalUserLocation) {
    emit((state as EventStateUnfinished).copyWith(
        currentUserPosition: initalUserLocation, location: initalUserLocation));
  }

  void eventDescriptionChanged(String newDescription) {
    final CreateEventData newData = (state as EventStateUnfinished)
        .createEventData
        .copyWith(description: newDescription);
    _emitNewSate(newData);
  }

  void eventDateChanged(DateTime newDate) {
    final CreateEventData newData = (state as EventStateUnfinished)
        .createEventData
        .copyWith(dateString: dateFormater.getDotFormat(newDate));
    _emitNewSate(newData);
  }

  void resetOnError() {
    emit(EventStateUnfinished());
  }

  void eventTimeChanged(String newTime) {
    final CreateEventData newData = (state as EventStateUnfinished)
        .createEventData
        .copyWith(timeString: newTime);
    _emitNewSate(newData);
  }

  void createEvent() async {
    print("CREATING EVENT .. current state -> $state");

    if (!(state is EventStateFinished))
      emit(EventStateServerFailure(stateErrorMessage));
    else {
      final CreateEventData createEventData =
          (state as EventStateFinished).createEventData;
      emit(EventStateLoading());
      final response = await _createEvent(createEventData);
      final eventToEmit = response.fold((failure) {
        if (failure is NetworkFailure)
          return EventStateNetworkFailure(failure.message);
        else
          return EventStateServerFailure(failure.message);
      }, (success) => EventStateCreated());
      emit(eventToEmit);
    }
  }

  void _emitNewSate(CreateEventData newData) {
    if (_areAllFieldsValid(newData))
      emit(EventStateFinished(newData));
    else
      emit(EventStateUnfinished(createEventData: newData));
  }

  bool _areAllFieldsValid(CreateEventData createEventData) {
    if (createEventData.dateString == null ||
        createEventData.timeString == null ||
        createEventData.eventName.isEmpty) return false;
    return createEventData.dateString!.isNotEmpty &&
        createEventData.timeString!.isNotEmpty &&
        createEventData.description.isNotEmpty;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }

  bool isEventLocationOutOfRange(
      LatLng newLocation, LatLng currentUserLocation) {
    double distance = calculateDistance(
        newLocation.latitude,
        newLocation.longitude,
        currentUserLocation.latitude,
        currentUserLocation.longitude);
    log("DISTANCE -> $distance");
    if (distance > 5) return true;
    return false;
  }
}
