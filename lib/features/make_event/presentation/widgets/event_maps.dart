import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventMaps extends StatefulWidget {
  // final LatLng currentLocation;
  final EventCubit eventCubit;
  const EventMaps(this.eventCubit, {Key? key}) : super(key: key);

  @override
  _EventMapsState createState() => _EventMapsState();
}

class _EventMapsState extends State<EventMaps> {
  GoogleMapController? _controller;
  LatLng currentLocation = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    widget.eventCubit.makeEventScreenInitialized();
    /*   Geolocator.getPositionStream().listen((position) {
      currentLocation = LatLng(position.latitude, position.longitude);
     widget.eventCubit.userLocationChanged(currentLocation);
    }); */
  }

  @override
  void dispose() {
    widget.eventCubit.stopListeningToLocationChnages();
    super.dispose();
  }

  Marker _generateEventMarker(LatLng eventLocation, EventCubit eventCubit) =>
      Marker(
        markerId: MarkerId(DateTime.now().toString()),
        position: eventLocation,
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        onDragEnd: (newLocation) => _onMarkerDragEnd(newLocation, eventCubit),
      );

  void _onMarkerDragEnd(LatLng newLocation, EventCubit eventCubit) {
    _generateEventMarker(newLocation, eventCubit);
    eventCubit.evenLocationChanged(newLocation);
  }

  Color _mapLocationStateToCircleColor(EventState eventState) {
    if (eventState is EventStateLocationOutOfRange)
      return Color.fromRGBO(255, 43, 28, 0.2);
    return Color.fromRGBO(97, 136, 255, 0.2);
  }

  Circle _generateEventCreationCircle(
          LatLng curretnUserLocation, Color circleColor) =>
      Circle(
        circleId: CircleId(DateTime.now().toString()),
        radius: 5000,
        center: curretnUserLocation,
        consumeTapEvents: false,
        strokeColor: Color.fromRGBO(97, 136, 255, 1),
        visible: true,
        zIndex: 1,
        strokeWidth: 1,
        fillColor: circleColor,
      );

  void _onMapsCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        log("MAPS : STATE -> $state");
        if (state is EventStateNetworkFailure)
          return Center(
            child: Text(state.message),
          );
        if (state is EventStateServerFailure)
          return Center(
            child: Text(state.message),
          );
        if (state is EventStateLoading || state is EventStateCreated)
          return Center(
            child: CircularProgressIndicator(),
          );

        LatLng _eventLocation =
            (state as EventStateUnfinished).createEventData.location;
        final circleColor = _mapLocationStateToCircleColor(state);
        final cricle = _generateEventCreationCircle(
            state.createEventData.currentUserPosition, circleColor);
        if (_eventLocation.latitude == 0 && _eventLocation.longitude == 0)
          _eventLocation = currentLocation;
        final marker = _eventLocation == LatLng(0, 0)
            ? null
            : _generateEventMarker(
                _eventLocation, BlocProvider.of<EventCubit>(context));
        log("MAPS : LOCATION -> $_eventLocation");
        if (_controller != null) {
          _controller!.animateCamera(CameraUpdate.newLatLng(_eventLocation));
        }
        return GoogleMap(
          onMapCreated: _onMapsCreated,
          initialCameraPosition: CameraPosition(
            target: _eventLocation,
            zoom: 12,
          ),
          myLocationEnabled: true,
          markers: marker == null ? {} : {marker},
          circles: marker == null ? {} : {cricle},
        );
      },
    );
  }
}
