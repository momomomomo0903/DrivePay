// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:drivepay/config/api_key.dart';

class MapLogic {
  GoogleMapController? mapController;
  final Function(Set<Marker>) updateMarkers;
  final Function(String) updateStartAddress;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  Position? get currentPosition => _currentPosition;

  MapLogic({
    required this.updateMarkers,
    required this.updateStartAddress,
    GoogleMapController? mapController,
  });

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getCurrentLocation(
    Function(CameraPosition) setInitialLocation, {
    BuildContext? context,
  }) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          if (context != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('位置情報の権限が必要です')));
          }
          return;
        }
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      _currentPosition = position;

      setInitialLocation(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18.0,
        ),
      );
    } catch (e) {
      debugPrint('現在地取得エラー: $e');
      if (context != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('現在地の取得に失敗しました')));
      }
    }
  }

  void moveToCurrentLocation(BuildContext context) async {
    await getCurrentLocation((cameraPosition) {
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
      }
    }, context: context);
  }

  Future<void> searchNavigate(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final target = LatLng(location.latitude, location.longitude);
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: 16.0),
          ),
        );
      }
    } catch (e) {
      debugPrint("検索エラー:$e");
    }
  }

  Future<void> searchDestination(
    String destination,
    BuildContext context,
    Function(Marker) onMarkerCreated,
  ) async {
    if (destination.isEmpty) return;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode.json?address=${Uri.encodeComponent(destination)}&key=$ApiKeys.api_key',
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final location = data['results'][0]['geometry']['location'];
        final latLng = LatLng(location['lat'], location['lng']);

        final marker = Marker(
          markerId: const MarkerId('destination'),
          position: latLng,
          infoWindow: InfoWindow(title: destination),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('場所が見つかりません')));
      }
    } catch (e) {
      debugPrint('検索エラー:$e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('検索に失敗しました')));
    }
  }

  Future<void> searchNearbyGasStations() async {
    return;
  }
}
