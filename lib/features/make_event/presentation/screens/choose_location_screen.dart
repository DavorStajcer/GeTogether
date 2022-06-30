import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/widgets/location_error.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_state.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/maps_location_cubit/maps_location_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_button_with_back_icon.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_maps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChooseLocationScreen extends StatelessWidget {
  final Function() goFowards;
  final Function() goBack;
  final Function() onError;
  ChooseLocationScreen({
    Key? key,
    required this.goFowards,
    required this.goBack,
    required this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    //  bool shouldGoToCurrentLocaction = false;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.055),
        child: BlocBuilder<MapsLocationCubit, MapsLocationState>(
            // bloc: BlocProvider.of<MapsLoca(context),
            builder: (context, state) {
          if (state is MapsLocationNotLoaded) {
            BlocProvider.of<MapsLocationCubit>(context).requestLocation();
            //   shouldGoToCurrentLocaction = true; */
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MapsLocationFailure)
            return LocationErrorWidget(
              state.errorMessage,
              onReload: onError,
            );

          final eventCubit = BlocProvider.of<EventCubit>(context);
          final LatLng initalCurrentUserPosition = LatLng(
              (state as MapsLocationLoaded).currentPosition.latitude,
              state.currentPosition.longitude);
          eventCubit.setInitialLocation(initalCurrentUserPosition);
          return Column(
            children: [
              Flexible(
                flex: 10,
                child: EventMaps(eventCubit),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Flexible(
                  flex: 2,
                  child: BlocBuilder<EventCubit, EventState>(
                    builder: (context, state) {
                      if (state is EventStateLocationOutOfRange)
                        return EventButtonWithBackIcon(
                          text: "Set details",
                          goBack: goBack,
                          goFowards: goFowards,
                          isOn: false,
                        );
                      else
                        return EventButtonWithBackIcon(
                          text: "Set details",
                          goBack: goBack,
                          goFowards: goFowards,
                        );
                    },
                  )),
            ],
          );
        }));
  }
}
