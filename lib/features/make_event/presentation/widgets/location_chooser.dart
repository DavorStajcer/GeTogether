/* import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/maps_location_cubit/maps_location_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_maps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationChooser extends StatelessWidget {
  LocationChooser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool shouldGoToCurrentLocaction = false;
    return BlocBuilder<MapsLocationCubit, MapsLocationState>(
      bloc: BlocProvider.of<MapsLocationCubit>(context),
      builder: (context, state) {
        log(state.runtimeType.toString());
        if (state is MapsLocationNotLoaded) {
          shouldGoToCurrentLocaction = true;
          BlocProvider.of<MapsLocationCubit>(context).requestLocation();
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is MapsLocationFailure) {
          shouldGoToCurrentLocaction = true;
          return _buildErrorWidget(context, state);
        }
        if (shouldGoToCurrentLocaction) {
          final Position currentPosition =
              (state as MapsLocationLoaded).currentPosition;
          final LatLng latLngPosition =
              LatLng(currentPosition.latitude, currentPosition.longitude);
          BlocProvider.of<EventCubit>(context)
              .evenLocationChanged(latLngPosition);
        }
        return EventMaps();
      },
    );
  }

  Widget _buildErrorWidget(
          BuildContext context, MapsLocationFailure failureState) =>
      Center(
        child: Column(
          children: [
            Text(
              failureState.errorMessage,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18),
            ),
            TextButton(
              onPressed: () =>
                  BlocProvider.of<MapsLocationCubit>(context).requestLocation(),
              child: Text("Try again"),
            ),
          ],
        ),
      );
}
 */