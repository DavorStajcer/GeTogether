import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/network.dart/network_info.dart';
import 'package:get_together_app/features/chats_overview/data/models/chat_snippet_model.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';
import 'package:get_together_app/features/chats_overview/domain/repositories/chat_snippets_repository.dart';

class ChatSnippetsRepositoryImpl extends ChatSnippetsReposiotry {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final NetworkInfo networkInfo;
  ChatSnippetsRepositoryImpl({
    FirebaseFirestore? firebaseFirestore,
    FirebaseAuth? firebaseAuth,
    required this.networkInfo,
  })   : firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  StreamController<ChatSnippet>? _chatSnippetsController;
  List<StreamSubscription> _chatSnippetsSubscriptions = [];

  @override
  Stream<ChatSnippet> listenToChatSnippetsChanges(
    List<ChatSnippet> chatSnippets,
  ) {
    _chatSnippetsController = StreamController();
    for (var chatSnippet in chatSnippets) {
      final newSubscription = _listenToSingleChatSnippet(chatSnippet.eventId);
      _chatSnippetsSubscriptions.add(newSubscription);
    }
    return _chatSnippetsController!.stream;
  }

  StreamSubscription _listenToSingleChatSnippet(String userChatId) =>
      firebaseFirestore
          .collection("chats")
          .doc(userChatId)
          .snapshots()
          .map<ChatSnippet?>((chatSnippetSnapshot) {
        if (!chatSnippetSnapshot.exists) return null;
        final chatSnippetData = chatSnippetSnapshot.data();
        if (chatSnippetData == null) return null;
        final currentUser = firebaseAuth.currentUser;
        if (currentUser == null) return null;
        final currentUserId = currentUser.uid;
        final List<dynamic> unreadFor = chatSnippetData["unreadFor"];
        bool isUnread = false;
        if (unreadFor.contains(currentUserId)) isUnread = true;
        return ChatSnippetModel.fromJsonMap(
          eventId: userChatId,
          isUnread: isUnread,
          json: chatSnippetData,
        );
      }).listen((chatSnippet) {
        if (chatSnippet != null) _chatSnippetsController!.sink.add(chatSnippet);
      });
  @override
  Future<void> stopListeningToChatSnippetChanges() async {
    for (var subscription in _chatSnippetsSubscriptions) {
      await subscription.cancel();
    }
    if (_chatSnippetsController != null)
      await _chatSnippetsController!.sink.close();
  }

  @override
  Future<Either<Failure, List<ChatSnippet>>> getInitialChatSnippets(
      List<String> userChatIds) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null)
      return Left(ServerFailure(
          message: "Couldnt identify curent user. Please try again."));
    final currentUserId = currentUser.uid;
    final List<ChatSnippet> userChatSnippets = [];
    try {
      for (var userChatId in userChatIds) {
        final ChatSnippet? chatSnippet =
            await _mapChatIdToChatSnippet(userChatId, currentUserId);
        if (chatSnippet != null) userChatSnippets.add(chatSnippet);
      }
      return Right(userChatSnippets);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<ChatSnippet?> _mapChatIdToChatSnippet(
      String userChatId, String currentUserId) async {
    ChatSnippet? chatSnippet;
    final chatSnippetSnapshot =
        await firebaseFirestore.collection("chats").doc(userChatId).get();
    if (chatSnippetSnapshot.exists) {
      final chatSnippetData = chatSnippetSnapshot.data();
      if (chatSnippetData != null) {
        final List<dynamic> unreadFor = chatSnippetData["unreadFor"];
        bool isUnread = false;
        if (unreadFor.contains(currentUserId)) isUnread = true;
        chatSnippet = ChatSnippetModel.fromJsonMap(
          eventId: userChatId,
          isUnread: isUnread,
          json: chatSnippetData,
        );
      }
    }
    return chatSnippet;
  }

  @override
  Future<void> markChatSnippetAsRead(String userChatId) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return; //return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return;
    try {
      await firebaseFirestore.collection("chats").doc(userChatId).update({
        "unreadFor": FieldValue.arrayRemove([currentUser.uid]),
      });
    } catch (e) {
      return;
    }
  }
}
