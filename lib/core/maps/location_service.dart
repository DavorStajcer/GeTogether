import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/network.dart/network_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

abstract class LocationService {
  final NetworkInfo networkInfo;
  Future<Either<Failure, Position>> getLocation();
  Future<String?> mapLocationToCity(LatLng location);
  Stream<Position> userLocationStream();
  LocationService({required this.networkInfo});
}

class LocationServiceImpl extends LocationService {
  LocationServiceImpl(NetworkInfo networkInfo)
      : super(networkInfo: networkInfo);

  @override
  Future<Either<Failure, Position>> getLocation() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    bool serviceEnabled;
    LocationPermission permission;

    log("CHECKING IS LOCATION ENABLED");
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    log("checked -> $serviceEnabled");
    if (!serviceEnabled) {
      return Left(LocationFailure(message: 'Location services are disabled.'));
    }

    permission = await Geolocator.checkPermission();
    try {
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Left(
              LocationFailure(message: 'Location permissions are denied'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Left(LocationFailure(
            message:
                'Location permissions are permanently denied, we cannot request permissions.'));
      }
      final position = await Geolocator.getCurrentPosition();
      return Right(position);
    } catch (e) {
      return Left(LocationFailure(
          message: "Location problem. Check is your location turned on."));
    }
  }

  Future<String?> mapLocationToCity(LatLng location) async {
    final response = await http.get(
      Uri.https("maps.googleapis.com", "/maps/api/geocode/json", {
        "latlng": "${location.latitude},${location.longitude}",
        "key": "AIzaSyDyi4MtJcldL85gBRT_STdjg8ckpCxpFY4",
      }),
    );

    final jsonRepsonse = json.decode(response.body);

    final List<dynamic> results = jsonRepsonse["results"];

    String? city;
    results.forEach((result) {
      (result["address_components"] as List).forEach((adressComponent) {
        (adressComponent["types"] as List).forEach((type) {
          if (type == "locality") city = adressComponent["long_name"];
          if (type == "administrative_area_level_1" && city == null)
            city = adressComponent["long_name"];
        });
      });
    });

    return city;
  }

  Stream<Position> userLocationStream() => Geolocator.getPositionStream();
}
