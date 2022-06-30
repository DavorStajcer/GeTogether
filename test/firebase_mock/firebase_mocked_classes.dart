import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mockito/mockito.dart';

class UserMock extends Mock implements User {}

class ReferenceMock extends Mock implements Reference {}

class UploadTaskMock extends Mock implements UploadTask {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class UserCredentialsMock extends Mock implements UserCredential {}

class QuerySnapshotMock extends Mock implements QuerySnapshot {}

class QueryDocumentSnapshotMock extends Mock implements QueryDocumentSnapshot {}

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {}
