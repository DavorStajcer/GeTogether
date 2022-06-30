//@dart=2.6

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/check_is_current_user_event_admin.dart';
import 'package:mockito/mockito.dart';

import '../../../firebase_mock/firebase_service_mock.dart';

void main() {
  FirebaseServiceMock firebaseServiceMock;
  CheckIsCurrentUserEventAdmin checkIsCurrentUserEventAdmin;
  String tAdminId;

  setUp(() {
    tAdminId = "tAdminId";
    firebaseServiceMock = FirebaseServiceMock();
    checkIsCurrentUserEventAdmin = CheckIsCurrentUserEventAdmin(
        firebaseAuth: firebaseServiceMock.firebaseAuthMock);
    firebaseServiceMock.setUpFirebaseAuth();
  });

  group("no errors", () {
    test("should make a call to firebase auth for current user", () async {
      await checkIsCurrentUserEventAdmin(tAdminId);
      verify(firebaseServiceMock.firebaseAuthMock.currentUser);
    });

    test("should return true if it is eaqual", () async {
      firebaseServiceMock.setUpFirebaseUserId(tAdminId);
      final response = await checkIsCurrentUserEventAdmin(tAdminId);
      expect(response, Right(true));
    });
    test("should return false if it is eaqual", () async {
      firebaseServiceMock.setUpFirebaseUserId("not admin id");
      final response = await checkIsCurrentUserEventAdmin(tAdminId);
      expect(response, Right(false));
    });
  });

  group("errors", () {
    test("should return server failure when current user is null", () async {
      firebaseServiceMock.returnNullForCurrentUser();
      final response = await checkIsCurrentUserEventAdmin(tAdminId);
      expect(response, Left(ServerFailure()));
    });
  });
}
