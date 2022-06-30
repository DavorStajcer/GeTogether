//@dart=2.6
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/events_overview/presentation/bloc/event_pick_cubit/event_pick_cubit_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  EventPickCubit eventPickCubitCubit;
  setUp(() {
    eventPickCubitCubit = EventPickCubit();
  });

  test("initaly no event should be picked", () {
    expect(eventPickCubitCubit.state,
        PickedEventState(pickedEventId: null, location: null));
  });

  blocTest(
    "emit new state with id of the picked event",
    build: () => eventPickCubitCubit,
    act: (cubit) =>
        (cubit as EventPickCubit).eventPicked("testId", LatLng(1, 1)),
    expect: () => [
      PickedEventState(
        pickedEventId: "testId",
        location: LatLng(1, 1),
      )
    ],
  );
}
