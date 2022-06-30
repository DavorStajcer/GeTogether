//@dart=2.6

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/make_event/domain/entities/create_event_data.dart';
import 'package:get_together_app/features/make_event/domain/usecases/create_event.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

class CreateEventMock extends Mock implements CreateEvent {}

//class ContextMock extends Mock implements BuildContext {}

//class DateFormaterMock extends Mock implements DateFormater {}

void main() {
  //ContextMock contextMock;
  // DateFormaterMock dateFormaterMock;
  CreateEventMock createEventMock;
  EventCubit eventCubit;
  CreateEventData tCreateEventData;
  //CreateEventData tFinishedData;

  setUp(() {
    //dateFormaterMock = DateFormaterMock();
    //contextMock = ContextMock();
    createEventMock = CreateEventMock();
    eventCubit = EventCubit(createEventMock);
    tCreateEventData = CreateEventData(
      type: EventType.games,
      location: LatLng(0, 0),
      dateString: null,
      timeString: null,
      description: "This is some event.",
    );
    // when(dateFormaterMock.getDotFormat(any)).thenReturn("01.01.1111");

/*     tFinishedData = CreateEventData(
      type: EventType.games,
      location: LatLng(0, 0),
      dateString: "07.12.1998",
      timeString: "21:10",
      description: "Some description",
    ); */
  });

  test("inital state should be all default values (except time and date)", () {
    expect(
      eventCubit.state,
      EventStateUnfinished(createEventData: tCreateEventData),
    );
  });

  group("no erros", () {
    setUp(() {
      when(createEventMock.call(any))
          .thenAnswer((realInvocation) async => Right(Success()));
    });

    //eventTypeChanged()
    blocTest<EventCubit, EventState>(
      "should emit state with changed event type",
      build: () => eventCubit,
      act: (cubit) => cubit.eventTypeChanged(EventType.games),
      expect: () => [
        EventStateUnfinished(
          createEventData: tCreateEventData.copyWith(
            type: EventType.games,
          ),
        )
      ],
    );
    //eventLocationChanged()
    blocTest(
      "should emit state with changed location",
      build: () => eventCubit,
      act: (cubit) => (cubit as EventCubit).evenLocationChanged(LatLng(3, 3)),
      expect: () => [
        EventStateUnfinished(
          createEventData: tCreateEventData.copyWith(
            location: LatLng(3, 3),
          ),
        )
      ],
    );

    //eventDateChnaged()
    blocTest(
      "should emit state with changed date",
      build: () => eventCubit,
      act: (cubit) => (cubit as EventCubit).eventDateChanged(DateTime(2021)),
      expect: () => [
        EventStateUnfinished(
          createEventData: tCreateEventData.copyWith(
            dateString: "01.01.2021",
          ),
        )
      ],
    );

    //eventTimeChanged()
    blocTest(
      "should emit state with changed time",
      build: () => eventCubit,
      act: (cubit) => (cubit as EventCubit).eventTimeChanged("22:22"),
      expect: () => [
        EventStateUnfinished(
            createEventData: tCreateEventData.copyWith(timeString: "22:22")),
      ],
    );

    //createEvent()
    blocTest("should return Success when event created",
        build: () {
          when(createEventMock.call(any))
              .thenAnswer((realInvocation) async => Right(Success()));
          return eventCubit;
        },
        act: (cubit) {
          (cubit as EventCubit).eventDateChanged(DateTime(2021));
          (cubit as EventCubit).eventTimeChanged("11:11");
          (cubit as EventCubit).createEvent();
        },
        expect: () => [
              isA<EventStateUnfinished>(),
              isA<EventStateFinished>(),
              EventStateLoading(),
              EventStateCreated()
            ],
        verify: (cubit) {
          verify(createEventMock.call(tCreateEventData.copyWith(
            dateString: "01.01.2021",
            timeString: "11:11",
          )));
        });
  });

  group("errors", () {
    blocTest(
      "should emit server failure with message passed form usecase that retured server failure",
      build: () {
        when(createEventMock.call(any)).thenAnswer((realInvocation) async =>
            Left(ServerFailure(message: "someMessage")));
        return eventCubit;
      },
      act: (cubit) {
        (cubit as EventCubit).eventDateChanged(DateTime(2021));
        (cubit as EventCubit).eventTimeChanged("11:11");
        (cubit as EventCubit).createEvent();
      },
      expect: () => [
        isA<EventStateUnfinished>(),
        isA<EventStateFinished>(),
        EventStateLoading(),
        EventStateServerFailure("someMessage"),
      ],
    );
  });

  group("errors", () {
    blocTest(
      "should emit network failure with message passed form usecase that returned network failure",
      build: () {
        when(createEventMock.call(any)).thenAnswer((realInvocation) async =>
            Left(NetworkFailure(message: "someMessage")));
        return eventCubit;
      },
      act: (cubit) {
        (cubit as EventCubit).eventDateChanged(DateTime(2021));
        (cubit as EventCubit).eventTimeChanged("11:11");
        (cubit as EventCubit).createEvent();
      },
      expect: () => [
        isA<EventStateUnfinished>(),
        isA<EventStateFinished>(),
        EventStateLoading(),
        EventStateNetworkFailure("someMessage"),
      ],
    );
  });
}
