//@dart=2.6

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/check_is_current_user_event_admin.dart';
import 'package:get_together_app/features/single_event_overview/presentation/bloc/single_event_screen_cubit/single_event_screen_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../firebase_mock/firebase_service_mock.dart';

class CheckIsCurrentUserEventAdminMock extends Mock
    implements CheckIsCurrentUserEventAdmin {}

void main() {
  CheckIsCurrentUserEventAdminMock checkIsCurrentUserEventAdminMock;
  FirebaseServiceMock firebaseServiceMock;
  SingleEventScreenCubit singleEventScreenCubit;
  String tAdminId;

  setUp(() {
    tAdminId = "tAdminId";
    firebaseServiceMock = FirebaseServiceMock();
    checkIsCurrentUserEventAdminMock = CheckIsCurrentUserEventAdminMock();
    singleEventScreenCubit = SingleEventScreenCubit(
        checkIsCurrentUserEventAdmin: checkIsCurrentUserEventAdminMock);
    tAdminId = "tAdminId";
    firebaseServiceMock.setUpFirebaseAuth();
  });

  group("no errors", () {
    blocTest(
      "should make a call to checkIsCurrentUserEventAdmin usecase",
      build: () {
        when(checkIsCurrentUserEventAdminMock(any))
            .thenAnswer((realInvocation) async => Right(true));
        return singleEventScreenCubit;
      },
      act: (cubit) => (cubit as SingleEventScreenCubit)
          .checkIsAdminOfEventCurrentUser(tAdminId),
      verify: (cubit) {
        verify(checkIsCurrentUserEventAdminMock.call(tAdminId));
      },
    );
    blocTest(
      "should emit loaded state with true parameter",
      build: () {
        when(checkIsCurrentUserEventAdminMock(any))
            .thenAnswer((realInvocation) async => Right(true));
        return singleEventScreenCubit;
      },
      act: (cubit) => (cubit as SingleEventScreenCubit)
          .checkIsAdminOfEventCurrentUser(tAdminId),
      expect: () => [
        SingleEventScreenLoaded(true),
      ],
    );
    blocTest(
      "should emit loaded state with false parameter",
      build: () {
        when(checkIsCurrentUserEventAdminMock(any))
            .thenAnswer((realInvocation) async => Right(false));
        return singleEventScreenCubit;
      },
      act: (cubit) => (cubit as SingleEventScreenCubit)
          .checkIsAdminOfEventCurrentUser(tAdminId),
      expect: () => [
        SingleEventScreenLoaded(false),
      ],
    );
  });

  group("errors", () {
    blocTest(
      "should emit failure when usecase returns network failure",
      build: () {
        when(checkIsCurrentUserEventAdminMock(any)).thenAnswer(
            (realInvocation) async =>
                Left(NetworkFailure(message: "someMessage")));
        return singleEventScreenCubit;
      },
      act: (cubit) => (cubit as SingleEventScreenCubit)
          .checkIsAdminOfEventCurrentUser(tAdminId),
      expect: () => [
        SingleEventScreenFailure("someMessage"),
      ],
    );
    blocTest(
      "should emit failure when usecase returns network failure",
      build: () {
        when(checkIsCurrentUserEventAdminMock(any)).thenAnswer(
            (realInvocation) async =>
                Left(ServerFailure(message: "someOtherMessage")));
        return singleEventScreenCubit;
      },
      act: (cubit) => (cubit as SingleEventScreenCubit)
          .checkIsAdminOfEventCurrentUser(tAdminId),
      expect: () => [
        SingleEventScreenFailure("someOtherMessage"),
      ],
    );
  });
}
