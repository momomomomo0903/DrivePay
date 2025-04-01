// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_field, deprecated_member_use
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:drivepay/config/api_key.dart';

class MapLogic {
  final String apiKey = ApiKeys.api_key;
  GoogleMapController? mapController;
  final Function(Set<Marker>) updateMarkers;
  final Function(String) updateStartAddress;
  final Function(Set<Polyline>) updatePolylines;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  Position? get currentPosition => _currentPosition;

  MapLogic({
    required this.updateMarkers,
    required this.updateStartAddress,
    required this.updatePolylines,
    GoogleMapController? mapController,
  });

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      } else {
        return '住所が見つかりません';
      }
    } catch (e) {
      debugPrint('住所取得エラー: $e');
      return '住所の取得に失敗しました';
    }
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

  void startLocationUpdates() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10, // 10m以上動いたら更新
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _currentPosition = position;

      // カメラを現在地にアニメーション移動
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
        );
      }
    });
  }

  Future<String?> findPlaceIdFromAddress(String address) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/findplacefromtext/json'
      '?input=${Uri.encodeComponent(address)}'
      '&inputtype=textquery'
      '&fields=place_id'
      '&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['place_id'];
      }
    } catch (e) {
      debugPrint('Place IDの取得エラー: $e');
    }
    return null;
  }

  Future<void> showPlaceDetailsFromMarker(
    BuildContext context,
    LatLng latLng,
  ) async {
    try {
      final address = await getAddressFromLatLng(latLng);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('場所: $address')));
    } catch (e) {
      debugPrint('施設情報取得エラー: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('施設情報を取得できませんでした。')));
    }
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
      'https://maps.googleapis.com/maps/api/geocode.json'
      '?address=${Uri.encodeComponent(destination)}'
      '&key=$apiKey',
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

  Future<void> drawRoute(
    String startAdd,
    String destinationAdd,
    BuildContext context,
  ) async {
    try {
      List<Location> startLoca = await locationFromAddress(startAdd);
      List<Location> destinationLoca = await locationFromAddress(
        destinationAdd,
      );

      if (startLoca.isEmpty || destinationLoca.isEmpty) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text('エラー'),
                content: Text('出発地または目的地の住所が見つかりませんでした。'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
        return;
      }

      final start = startLoca.first;
      final destination = destinationLoca.first;

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${start.latitude},${start.longitude}'
        '&destination=${destination.latitude},'
        '${destination.longitude}&key=$apiKey'
        '&language=ja&overview=full&steps=true',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final steps = data['routes'][0]['legs'][0]['steps'];
        List<LatLng> fullRoutePoints = [];

        for (var step in steps) {
          final encoded = step['polyline']['points'];
          final decoded = _decodePolyline(encoded);
          fullRoutePoints.addAll(decoded);
        }

        final polyline = Polyline(
          polylineId: const PolylineId('detailed_route'),
          color: Colors.blue,
          width: 5,
          points: fullRoutePoints,
        );

        updatePolylines({polyline});
      } else {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text("ルート検索エラー"),
                content: Text("ルート取得に失敗しました。"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      debugPrint("ルート取得エラー: $e");
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("例外エラー"),
              content: Text("ルート取得中にエラーが発生しました。"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  Future<void> searchNearbyGasStations() async {
    return;
  }
}
