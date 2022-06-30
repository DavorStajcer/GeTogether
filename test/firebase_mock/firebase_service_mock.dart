//@dart=2.6

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_together_app/core/error/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'firebase_auth_mock.dart';
import 'firebase_firestore_mock.dart';
import 'firebase_mocked_classes.dart';
import 'firebase_storage_mock.dart';

class FirebaseServiceMock {
  //Services
  final FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
  final FirebaseStorageMock firebaseStorageMock = FirebaseStorageMock();
  final FirebaseFirestoreMock firebaseFirestoreMock = FirebaseFirestoreMock();
  //Firebase classes
  final UserCredentialsMock userCredentialsMock = UserCredentialsMock();
  final CollectionReferenceMock collectionReferenceMock =
      CollectionReferenceMock();
  final DocumentReferenceMock documentReferenceMock = DocumentReferenceMock();
  final UploadTaskMock uploadTaskMock = UploadTaskMock();
  final ReferenceMock referenceMock = ReferenceMock();
  final UserMock userMock = UserMock();
  final QuerySnapshotMock querySnapshot = QuerySnapshotMock();
  final DocumentSnapshotMock documentSnapshotMock = DocumentSnapshotMock();
  final QueryDocumentSnapshotMock queryDocumentSnapshotMock =
      QueryDocumentSnapshotMock();
  //Test values
  static const String tDownloadUrl = "tDownloadUrl";

  FirebaseServiceMock() {
    when(userMock.uid).thenAnswer((realInvocation) => "tUserId");
    when(referenceMock.child(any))
        .thenAnswer((realInvocation) => referenceMock);
    when(documentReferenceMock.set(any))
        .thenAnswer((realInvocation) => Future.value());
    when(referenceMock.putFile(any))
        .thenAnswer((realInvocation) => uploadTaskMock);
    when(uploadTaskMock.then(any))
        .thenAnswer((realInvocation) => Future.value(tDownloadUrl));
    when(collectionReferenceMock.doc(any))
        .thenAnswer((realInvocation) => documentReferenceMock);
    when(collectionReferenceMock.snapshots())
        .thenAnswer((realInvocation) => Stream.value(querySnapshot));
  }

  void setUpFirebaseAuth() {
    when(firebaseAuthMock.currentUser).thenAnswer((realInvocation) => userMock);
  }

  void setUpFirebaseUserId(String userId) {
    when(userMock.uid).thenReturn(userId);
  }

  void returnNullForCurrentUser() =>
      when(firebaseAuthMock.currentUser).thenReturn(null);

  void setUpFirebaseFirestore() {
    when(firebaseFirestoreMock.doc(any))
        .thenAnswer((realInvocation) => documentReferenceMock);

    when(firebaseFirestoreMock.collection(any))
        .thenAnswer((realInvocation) => collectionReferenceMock);

    when(collectionReferenceMock.get())
        .thenAnswer((realInvocation) async => querySnapshot);

    when(documentReferenceMock.get())
        .thenAnswer((realInvocation) async => documentSnapshotMock);

    when(documentReferenceMock.collection(any))
        .thenAnswer((realInvocation) => collectionReferenceMock);
  }

  void setUpFirestoreDocumentData(Map<String, dynamic> data) {
    when(documentSnapshotMock.data()).thenReturn(data);
    when(queryDocumentSnapshotMock.data()).thenReturn(data);
  }

  void setUpNumberOfDocumentsInCollectionSnapshot(
      {int numOfDocs, String docId}) {
    if (numOfDocs < 1) return;
    List<QueryDocumentSnapshotMock> docList = [];
    for (int i = 0; i < numOfDocs; i++) docList.add(queryDocumentSnapshotMock);
    when(querySnapshot.docs).thenReturn(docList);
    when(queryDocumentSnapshotMock.id).thenReturn(docId);
  }

  void setUpFirebaseStorage() {
    when(firebaseStorageMock.ref())
        .thenAnswer((realInvocation) => referenceMock);
  }

  void setUpFirebaseFirestoreError({String message}) {
    when(documentSnapshotMock.data())
        .thenThrow(ServerException(message: message));
    when(documentReferenceMock.set(any)).thenThrow(ServerException());
  }

  void setUpSuccessfullAuth(String tUserEmal, String tUserPassword) {
    when(firebaseAuthMock.signInWithEmailAndPassword(
            email: tUserEmal, password: tUserPassword))
        .thenAnswer(((realInvocation) async => userCredentialsMock));
    when(firebaseAuthMock.createUserWithEmailAndPassword(
            email: tUserEmal, password: tUserPassword))
        .thenAnswer(((realInvocation) async => userCredentialsMock));
  }

  void setUpFailedAuth(String tUserEmal, String tUserPassword) {
    when(firebaseAuthMock.signInWithEmailAndPassword(
            email: tUserEmal, password: tUserPassword))
        .thenThrow(FirebaseAuthException(code: "exception"));
    when(firebaseAuthMock.createUserWithEmailAndPassword(
            email: tUserEmal, password: tUserPassword))
        .thenThrow(FirebaseAuthException(code: "exception"));
  }
}
