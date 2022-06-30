import 'dart:io';

String getStringJsonFromFixture(String fileName) =>
    File("test/fixtures/$fileName").readAsStringSync();
