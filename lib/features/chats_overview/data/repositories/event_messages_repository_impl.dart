import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/network.dart/network_info.dart';
import 'package:get_together_app/features/chats_overview/data/models/message_model.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/message.dart';
import 'package:get_together_app/features/chats_overview/domain/repositories/event_messages_repository.dart';
import 'package:get_together_app/features/chats_overview/presentation/widgets/chat_messages.dart';

class EventMessageRepositoryImpl extends EventMessagesRepository {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  NetworkInfo networkInfo;
  late StreamController<Either<Failure, List<Message>>>
      _messageStreamController;
  StreamSubscription<QuerySnapshot>? _currentMessageSubscription;
  StreamSubscription<DocumentSnapshot>? _currentSnippetSubscription;
  int _lastPageNum = -1;
  int _nextPageToLoad = -1;
  bool _canLoadNewPage = true;

  EventMessageRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
    required this.networkInfo,
    // required this.locationService,
  })  : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<Either<Failure, List<Message>>> listenToChatMessages(String eventId) {
    _messageStreamController = StreamController();
    _listenToPage(eventId);
    _currentSnippetSubscription = firebaseFirestore
        .collection("chats")
        .doc(eventId)
        .snapshots()
        .listen((chatSnippet) {
      final data = chatSnippet.data();
      if (data != null) {
        if (_lastPageNum != data["lastPageNum"]) {
          _lastPageNum = data["lastPageNum"];
          _listenToPage(eventId);
        }
      }
    }, onError: (error) {
      return Left(NetworkFailure());
    });
    return _messageStreamController.stream;
  }

  void _listenToPage(String eventId) {
    if (_currentMessageSubscription != null)
      _currentMessageSubscription!.cancel();
    _currentMessageSubscription = firebaseFirestore
        .collection("chats")
        .doc(eventId)
        .collection("messages")
        .doc("page$_lastPageNum")
        .collection("page_messages")
        .orderBy("timestamp")
        .snapshots()
        .listen((pageMessages) {
      final List<Map<String, dynamic>> changedData = [];
      final docChanges = pageMessages.docChanges;
      for (var docChange in docChanges) {
        if (docChange.type == DocumentChangeType.modified) {
          log("DOC MODIFIED");
          if (docChange.doc.data() != null)
            changedData.add(docChange.doc.data()!);
        }
        if (docChange.type == DocumentChangeType.added) {
          final timestamp = docChange.doc.data()!["timestamp"];
          log("DOC ADDED -> $timestamp");
          if (timestamp != null) {
            changedData.add(docChange.doc.data()!);
          }
        }
      }

      final messages = changedData.map((data) {
        final currentUserUid = firebaseAuth.currentUser!.uid;
        final senderId = data["senderId"];
        Sender messageSender = Sender.other;
        if (currentUserUid == senderId) messageSender = Sender.currentUser;
        return MessageModel.fromJsonMap(messageSender, data);
      }).toList();
      messages.removeWhere((messageModel) => messageModel.date == null);
      if (messages.isNotEmpty)
        _messageStreamController.sink.add(Right(messages));
    },
            onError: (error) =>
                _messageStreamController.sink.add(Left(ServerFailure())));
  }

  Future<void> stopListeningToChatMessages() async {
    _lastPageNum = -1;
    _nextPageToLoad = -1;
    await _messageStreamController.sink.close();
    if (_currentMessageSubscription != null)
      await _currentMessageSubscription!.cancel();
    if (_currentSnippetSubscription != null)
      await _currentSnippetSubscription!.cancel();
  }

  @override
  Future<Either<Failure, Success>> addMessage(
      String eventId, String eventCity, String message) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected == false) return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return Left(ServerFailure());
    final String currentUid = currentUser.uid;
    try {
      final eventSnippetSnapshot =
          await firebaseFirestore.collection("chats").doc(eventId).get();
      if (!eventSnippetSnapshot.exists) return Left(ServerFailure());
      final snippetData = eventSnippetSnapshot.data();
      if (snippetData == null) return Left(ServerFailure());
      final int lastPageNum = snippetData["lastPageNum"];

      final userSnapashot =
          await firebaseFirestore.collection("users").doc(currentUid).get();
      final userData = userSnapashot.data();
      if (userData == null) return Left(ServerFailure());
      final String userImageUrl = userData["imageUrl"];
      final String username = userData["username"];
      final MessageModel messageModel = MessageModel(
          username: username,
          userImageUrl: userImageUrl,
          content: message,
          sender: Sender.currentUser);
      await firebaseFirestore
          .collection("chats")
          .doc(eventId)
          .collection("messages")
          .doc("page$lastPageNum")
          .collection("page_messages")
          .add(messageModel.toJsonMap(currentUid, eventCity));
      return Right(Success());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> loadInitMessages(
      String eventId) async {
    try {
      final eventDoc =
          await firebaseFirestore.collection("chats").doc(eventId).get();
      final data = eventDoc.data();
      if (data == null) return Left(ServerFailure());
      _lastPageNum = data["lastPageNum"];
      List<Map<String, dynamic>> messagesData = [];
      messagesData.insertAll(0, await _getPageData(eventId, _lastPageNum));
      if (_lastPageNum > 1)
        messagesData.insertAll(
            0, await _getPageData(eventId, _lastPageNum - 1));
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) return Left(ServerFailure());
      final String currentUid = currentUser.uid;
      final List<Message> messages =
          _mapMessageDataToMessage(messagesData, currentUid);
      if (_lastPageNum > 2) _nextPageToLoad = _lastPageNum - 2;
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> loadNextPage(String eventId) async {
    if (_nextPageToLoad == -1) return Right([]);
    if (!_canLoadNewPage) return Right([]);
    try {
      final List<Map<String, dynamic>> pageMessagesData = [];
      pageMessagesData.insertAll(
          0, await _getPageData(eventId, _nextPageToLoad));

      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) return Left(ServerFailure());
      final String currentUid = currentUser.uid;
      final List<Message> messages =
          _mapMessageDataToMessage(pageMessagesData, currentUid);
      _nextPageToLoad--;
      if (_nextPageToLoad == 0) _nextPageToLoad = -1;
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  List<Message> _mapMessageDataToMessage(
      List<Map<String, dynamic>> data, String uid) {
    return data.map(
      (messageData) {
        Sender messageSender = Sender.other;
        if (uid == messageData["senderId"]) messageSender = Sender.currentUser;
        return MessageModel.fromJsonMap(messageSender, messageData);
      },
    ).toList();
  }

  Future<List<Map<String, dynamic>>> _getPageData(
      String eventId, int page) async {
    final List<Map<String, dynamic>> pageMessagesData = [];
    final pageSnapshot = await firebaseFirestore
        .collection("chats")
        .doc(eventId)
        .collection("messages")
        .doc("page$page")
        .collection("page_messages")
        .orderBy("timestamp")
        .get();

    for (var messageSnapshot in pageSnapshot.docs) {
      pageMessagesData.add(messageSnapshot.data());
    }
    return pageMessagesData;
  }

  @override
  bool isAableToLoadMorePages() => _nextPageToLoad != -1;
}
