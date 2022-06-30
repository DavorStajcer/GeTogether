/* //@dart=2.6
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/chats_overview/data/repositories/event_messages_repository_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../firebase_mock/firebase_service_mock.dart';
import '../../../../network_info_mock/network_info_mock.dart';

void main() {
  FirebaseServiceMock firebaseServiceMock;
  NetworkInfoMock networkInfoMock;
  EventMessageRepositoryImpl eventMessageRepositoryImpl;
  //LocationServiceMock locationServiceMock;
  String tEventId;
  String tUserId;
  // String tCity;

  setUp(() {
    firebaseServiceMock = FirebaseServiceMock();
    networkInfoMock = NetworkInfoMock();
    //locationServiceMock = LocationServiceMock();
    eventMessageRepositoryImpl = EventMessageRepositoryImpl(
      networkInfo: networkInfoMock,
      firebaseAuth: firebaseServiceMock.firebaseAuthMock,
      firebaseFirestore: firebaseServiceMock.firebaseFirestoreMock,
      // locationService: locationServiceMock,
    );
    tEventId = "tEventId";
    tUserId = "tUserId";
    // tCity = "tCity";
    firebaseServiceMock.setUpFirebaseAuth();
    firebaseServiceMock.setUpFirebaseFirestore();
  });

  group("no errors", () {
    setUp(() {
      networkInfoMock.setUpItHasConnection();

      firebaseServiceMock.setUpFirebaseUserId(tUserId);
      firebaseServiceMock.setUpFirestoreDocumentData({
        "adminIds": [tEventId, tEventId],
        "eventIds": [tEventId, tEventId]
      });
    });

    //listenToMessageSnippetChanges
    test("should make a call to firestore chats/event id", () {
      eventMessageRepositoryImpl.listenToMessageSnippetChanges(tEventId);
      verify(firebaseServiceMock.firebaseFirestoreMock.collection("chats"));
      verify(firebaseServiceMock.collectionReferenceMock.doc(tEventId));
    });
  });
}
 */