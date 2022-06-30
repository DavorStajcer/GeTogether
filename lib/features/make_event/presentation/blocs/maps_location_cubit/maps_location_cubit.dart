import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_together_app/core/maps/location_service.dart';
part 'maps_location_state.dart';

class MapsLocationCubit extends Cubit<MapsLocationState> {
  final LocationService locationService;
  MapsLocationCubit({required this.locationService})
      : super(MapsLocationNotLoaded());

  void requestLocation() async {
    emit(MapsLocationNotLoaded());
    final response = await locationService.getLocation();
    response.fold(
        (
          failure,
        ) =>
            emit(
              MapsLocationFailure(errorMessage: failure.message),
            ), (
      position,
    ) async {
      emit(
        MapsLocationLoaded(currentPosition: position),
      );
    });
  }

  void resetOnError() {
    emit(MapsLocationNotLoaded());
  }
}
