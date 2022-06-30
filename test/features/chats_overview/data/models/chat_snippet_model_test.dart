//@dart=2.6

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/chats_overview/data/models/chat_snippet_model.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';

import '../../../../fixtures/fixture_string_converter.dart';

void main() {
  ChatSnippetModel chatSnippetModel;
  String tEventId;

  setUp(() {
    tEventId = "tEventId";
    chatSnippetModel = ChatSnippetModel(
        eventId: tEventId,
        eventName: "tEventName",
        adminImageUrl: "tAdminImageUrl",
        lastMessageDate: DateTime(
          2021,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
        ),
        lastMessageSnippet: "tLastMesageSnippet");
  });

  test("should be an instance of ChatSnippet", () {
    expect(chatSnippetModel, isInstanceOf<ChatSnippet>());
  });
//!!DUNNO RIGHT NOW HOW TO REPRESENT FIRESTORE TIMESTAMP IN A JSON FILE
  /*  test("should convert itself to a json Map", () {
    final map = chatSnippetModel.toJsonMap();
    final expected = json.decode(getStringJsonFromFixture(
        "chat_snippet_fixture.json")); //when you do json.encode(map) and when you compare it with the getStringJsonFromFixture() it is not completly eaqual bcs of some string stuff, but it looks good
    expect(map, expected);
  });

  test("should make new instance from json map", () {
    final jsonMap =
        json.decode(getStringJsonFromFixture("chat_snippet_fixture.json"));
    final instance = ChatSnippetModel.fromJsonMap(tEventId, jsonMap);
    expect(instance, chatSnippetModel);
  }); */
}
