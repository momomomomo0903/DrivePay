// lib/logic/map.dart
import 'dart:convert';
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

  static Position? _currentPosition;

  MapLogic({
    required this.updateMarkers,
    required this.updateStartAddress,
    GoogleMapController? mapController,
  });

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getCurrentLocation(
    Function(CameraPosition) setInitialLocation,
  ) async {
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
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      _currentPosition = position;

      setInitialLocation(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18.0,
        ),
      );
      await _getAddress();
    } catch (e) {
      debugPrint('現在地取得エラー: $e');
    }
  }

  void moveToCurrentLocation(BuildContext context) {
    if (_currentPosition != null && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          18.0,
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('現在地が取得できません')));
    }
  }

  Future<void> _getAddress() async {
    return;
  }

  Future<void> searchPlace(String query) async {
    return;
  }

  Future<void> searchNearbyGasStations() async {
    return;
  }
}
