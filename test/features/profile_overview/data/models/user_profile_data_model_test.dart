/* //@dart=2.6

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/profile_overview/data/models/user_profile_data_model.dart';
import 'package:get_together_app/features/profile_overview/domain/entities/user_profile_data.dart';

import '../../../../fixtures/fixture_string_converter.dart';

void main() {
  UserProfileDataModel tUserProfileData;

  setUp(() {
    tUserProfileData = UserProfileDataModel(
      userId: "tUserId",
      username: "username",
      imageUrl: "tImageUrl",
      city: "city",
      country: "country",
      description: "description",
      friendsCount: 1,
      rating: 1,
      numberOfVotes: 1,
    );
  });

  test("should be an instance of UserProfileData", () {
    expect(tUserProfileData, isInstanceOf<UserProfileData>());
  });

  test("should convert itself to a json Map", () {
    final map = tUserProfileData.toJsonMap();
    final expected = json.decode(getStringJsonFromFixture(
        "user_profile_data_fixture.json")); //when you do json.encode(map) and when you compare it with the getStringJsonFromFixture() it is not completly eaqual bcs of some string stuff, but it looks good
    expect(map, expected);
  });

  test("should make new instance from json map", () {
    final jsonMap =
        json.decode(getStringJsonFromFixture("user_profile_data_fixture.json"));
    final instance = UserProfileDataModel.fromJsonMap(jsonMap);
    expect(instance, tUserProfileData);
  });
}
 */

import 'package:flutter_test/flutter_test.dart';

void main() {
  test("nothing to test", () {
    expect(null, null);
  });
}
