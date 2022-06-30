import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get_together_app/core/maps/location_service.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ListenToUserLocationChange {
  LocationService locationService;
  ListenToUserLocationChange(this.locationService);
  late StreamSubscription<Position> subscription;

  void call(EventCubit eventCubit) {
    subscription = locationService.userLocationStream().listen((position) {
      log("LOCATION CHANGED -> ${position.latitude},${position.longitude}");
      eventCubit
          .userLocationChanged(LatLng(position.latitude, position.longitude));
    });
  }

  void stop() {
    subscription.cancel();
  }
}
