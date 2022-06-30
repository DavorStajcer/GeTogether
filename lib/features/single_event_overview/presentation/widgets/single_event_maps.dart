import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleEventMaps extends StatelessWidget {
  final LatLng _eventLocation;
  const SingleEventMaps(this._eventLocation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _initalCameraPosition = CameraPosition(
      target: _eventLocation,
      zoom: 13,
    );

    final _eventMarker = Marker(
      markerId: MarkerId(DateTime.now().toString()),
      position: _eventLocation,
      draggable: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    return GoogleMap(
      initialCameraPosition: _initalCameraPosition,
      markers: {
        _eventMarker,
      },
    );
  }
}
