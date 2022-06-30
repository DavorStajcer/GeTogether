/* //@dart=2.6

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:get_together_app/features/notifications_overview/domain/usecase/send_join_request.dart';
import 'package:get_together_app/features/single_event_overview/domain/entities/event_join_data.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/add_user_to_event.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/check_is_user_joined.dart';
import 'package:get_together_app/features/single_event_overview/presentation/bloc/join_event_cubit/join_event_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

class CheckIsUserJoinedMock extends Mock implements CheckIsUserJoined {}

class ChangeUserJoinStatusMock extends Mock implements ChangeUserJoinStatus {}

class SendJoinRequestMock extends Mock implements SendJoinRequest {}

class ContextMock extends Mock implements BuildContext {}

void main() {
  CheckIsUserJoinedMock checkIsUserJoinedMock;
  ChangeUserJoinStatusMock changeUserJoinStatusMock;
  SendJoinRequestMock sendJoinRequestMock;
  JoinEventCubit joinEventCubit;
  Event tEvent;
  ContextMock contextMock;
  setUp(() {
    checkIsUserJoinedMock = CheckIsUserJoinedMock();
    changeUserJoinStatusMock = ChangeUserJoinStatusMock();
    sendJoinRequestMock = SendJoinRequestMock();
    contextMock = ContextMock();
    tEvent = Event(
      eventId: "tEventId",
      eventType: EventType.coffe,
      dateString: "dateString",
      timeString: "timeString",
      location: LatLng(1, 1),
      adminId: "adminId",
      adminUsername: "adminUsername",
      adminImageUrl: "adminImageUrl",
      adminRating: -1,
      numberOfPeople: 0,
      description: "description",
      peopleImageUrls: {},
    );
    joinEventCubit = JoinEventCubit(
      changeUserJoinStatus: changeUserJoinStatusMock,
      checkIsUserJoined: checkIsUserJoinedMock,
      sendJoinRequest: sendJoinRequestMock,
    );
  });

  test("inital state should be JoinEventLoading", () {
    expect(joinEventCubit.state, JoinEventLoading());
  });

  group("no erros", () {
    //getUserJoinedStatus()
    blocTest(
      "should emit JoinEventFinished with ButtonJoinedUi if user is joined and make a call to usecase",
      build: () {
        when(checkIsUserJoinedMock.call(tEvent))
            .thenAnswer((realInvocation) async => Right(true));
        return joinEventCubit;
      },
      act: (cubit) =>
          (cubit as JoinEventCubit).geUserJoinedStatus(contextMock, tEvent),
      expect: () => [
        JoinEventFinished(buttonData: ButtonJoinedUi(contextMock)),
      ],
      verify: (cubit) => verify(checkIsUserJoinedMock(tEvent)),
    );

    blocTest(
      "should emit JoinEventFinished with ButtonNotJoinedUi if user is joined and make a call to usecase",
      build: () {
        when(checkIsUserJoinedMock.call(tEvent))
            .thenAnswer((realInvocation) async => Right(false));
        return joinEventCubit;
      },
      act: (cubit) =>
          (cubit as JoinEventCubit).geUserJoinedStatus(contextMock, tEvent),
      expect: () => [
        JoinEventFinished(buttonData: ButtonNotJoinedUi(contextMock)),
      ],
      verify: (cubit) => verify(checkIsUserJoinedMock(tEvent)),
    );

    //changeJoinedStatus()
    blocTest(
      "should emit Loading state and than ButtonJoinedUi if user is joining and make a call to usecase",
      build: () {
        when(changeUserJoinStatusMock.call(any))
            .thenAnswer((realInvocation) async => Right(Success()));
        return joinEventCubit;
      },
      act: (cubit) => (cubit as JoinEventCubit).changeJoinedStatus(
        contextMock,
        EventJoinData(
          event: tEvent,
          eventChange: EventChange.join,
        ),
      ),
      expect: () => [
        JoinEventLoading(),
        JoinEventFinished(buttonData: ButtonJoinedUi(contextMock)),
      ],
      verify: (cubit) => verify(
        changeUserJoinStatusMock(
          EventJoinData(
            event: tEvent,
            eventChange: EventChange.join,
          ),
        ),
      ),
    );

    blocTest(
      "should emit Loading state and than ButtonNotJoined if user is leaving event and make a call to usecase",
      build: () {
        when(changeUserJoinStatusMock.call(any))
            .thenAnswer((realInvocation) async => Right(Success()));
        return joinEventCubit;
      },
      act: (cubit) => (cubit as JoinEventCubit).changeJoinedStatus(
        contextMock,
        EventJoinData(
          event: tEvent,
          eventChange: EventChange.leave,
        ),
      ),
      expect: () => [
        JoinEventLoading(),
        JoinEventFinished(buttonData: ButtonNotJoinedUi(contextMock)),
      ],
      verify: (cubit) => verify(
        changeUserJoinStatusMock(
          EventJoinData(
            event: tEvent,
            eventChange: EventChange.leave,
          ),
        ),
      ),
    );
  });

  group("errors", () {
    //getUserJoinedStatus
    blocTest(
      " should emit JoinEventServerFailure when usecase reutrns server failure",
      build: () {
        when(checkIsUserJoinedMock.call(tEvent)).thenAnswer(
            (realInvocation) async =>
                Left(ServerFailure(message: "someMessage")));
        return joinEventCubit;
      },
      act: (cubit) =>
          (cubit as JoinEventCubit).geUserJoinedStatus(contextMock, tEvent),
      expect: () => [
        JoinEventServerFailure("someMessage"),
      ],
      verify: (cubit) => verify(checkIsUserJoinedMock(tEvent)),
    );

    blocTest(
      " should emit JoinEventNetworkFailure when usecase reutrns server failure",
      build: () {
        when(checkIsUserJoinedMock.call(tEvent)).thenAnswer(
            (realInvocation) async =>
                Left(NetworkFailure(message: "someMessage")));
        return joinEventCubit;
      },
      act: (cubit) =>
          (cubit as JoinEventCubit).geUserJoinedStatus(contextMock, tEvent),
      expect: () => [
        JoinEventNetworkFailure("someMessage"),
      ],
      verify: (cubit) => verify(checkIsUserJoinedMock(tEvent)),
    );

    //changeJoinedStatus()
    blocTest(
      "should emit JoinEventServerFailure when usecase reutrns server failure",
      build: () {
        when(changeUserJoinStatusMock.call(any))
            .thenAnswer((realInvocation) async => Left(
                  ServerFailure(message: "someMessage"),
                ));
        return joinEventCubit;
      },
      act: (cubit) => (cubit as JoinEventCubit).changeJoinedStatus(
        contextMock,
        EventJoinData(
          event: tEvent,
          eventChange: EventChange.leave,
        ),
      ),
      expect: () => [
        JoinEventLoading(),
        JoinEventServerFailure("someMessage"),
      ],
      verify: (cubit) => verify(
        changeUserJoinStatusMock(
          EventJoinData(
            event: tEvent,
            eventChange: EventChange.leave,
          ),
        ),
      ),
    );
    blocTest(
      "should emit JoinEventNetworkFailure when usecase reutrns server failure",
      build: () {
        when(changeUserJoinStatusMock.call(any))
            .thenAnswer((realInvocation) async => Left(
                  NetworkFailure(message: "someMessage"),
                ));
        return joinEventCubit;
      },
      act: (cubit) => (cubit as JoinEventCubit).changeJoinedStatus(
        contextMock,
        EventJoinData(
          event: tEvent,
          eventChange: EventChange.leave,
        ),
      ),
      expect: () => [
        JoinEventLoading(),
        JoinEventNetworkFailure("someMessage"),
      ],
      verify: (cubit) => verify(
        changeUserJoinStatusMock(
          EventJoinData(
            event: tEvent,
            eventChange: EventChange.leave,
          ),
        ),
      ),
    );
  });
}
 */