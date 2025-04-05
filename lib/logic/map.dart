// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_field, deprecated_member_use, unnecessary_null_comparison
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

  // マップの設定
  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  // 緯度経度から住所を取得
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

  // 現在地の取得
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

  // カメラ位置の設定
  void moveToCurrentLocation(BuildContext context) async {
    await getCurrentLocation((cameraPosition) {
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
      }
    }, context: context);
  }

  // ルートの全体が見える範囲を探索
  LatLngBounds _createLatLngBounds(List<LatLng> points) {
    double south = points.first.latitude;
    double north = points.first.latitude;
    double west = points.first.longitude;
    double east = points.first.longitude;

    for (var point in points) {
      if (point.latitude < south) south = point.latitude;
      if (point.latitude > north) north = point.latitude;
      if (point.longitude < west) west = point.longitude;
      if (point.longitude > east) east = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  // 住所からplaceIDを取得
  Future<String?> findPlaceIdFromAddress(LatLng latLng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=${latLng.latitude},${latLng.longitude}'
      '&radius=30' // 半径30m以内にある施設を検索
      '&type=point_of_interest'
      '&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'] != null) {
        return data['results'][0]['place_id'];
      }
    } catch (e) {
      debugPrint('Place IDの取得エラー: $e');
    }
    return null;
  }

  // マーカーの情報を表示
  Future<void> showPlaceDetailsFromMarker(
    BuildContext context,
    LatLng latLng,
  ) async {
    try {
      final placeId = await findPlaceIdFromAddress(latLng);
      if (placeId != null) {
        debugPrint('placeID:$placeId');
        debugPrint('マップ情報取得開始');
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&fields=name,rating,formatted_address,formatted_phone_number,geometry,photos,opening_hours,reviews,user_ratings_total'
          '&language=ja'
          '&key=$apiKey',
        );
        final response = await http.get(url);
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['result'] != null) {
          final place = data['result'];
          final name = place['name'] ?? '名称不明';
          final address = place['formatted_address'] ?? '住所不明';
          final rating = place['rating']?.toString() ?? '評価なし';
          final totalRatings = place['user_ratings_total']?.toString() ?? '0';
          final phone = place['formatted_phone_number'] ?? '電話番号なし';
          final photos = place['photos'];
          String? photoUrl;
          if (photos != null && photos.isNotEmpty) {
            final photoRef = photos[0]['photo_reference'];
            if (photoRef != null) {
              photoUrl =
                  'https://maps.googleapis.com/maps/api/place/photo'
                  '?maxwidth=400'
                  '&photoreference=$photoRef'
                  '&key=$apiKey';
            }
          }

          debugPrint('施設情報を取得完了');
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder:
                (context) => DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.2,
                  maxChildSize: 0.85,
                  builder: (context, ScrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        controller: ScrollController,
                        children: [
                          const Center(
                            child: Icon(Icons.drag_handle, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          Text('$name', style: TextStyle(fontSize: 30)),
                          Text('$rating($totalRatings)'),
                          Text(address),
                          Text(phone),
                          if (photoUrl != null) Image.network(photoUrl),
                        ],
                      ),
                    );
                  },
                ),
          );
        }
      }
    } catch (e) {
      debugPrint('施設情報取得エラー: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('施設情報を取得できませんでした。')));
    }
  }

  // 目的地を検索
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

  // ルートの取得・表示
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
        if (mapController != null && fullRoutePoints.isNotEmpty) {
          LatLngBounds bounds = _createLatLngBounds(fullRoutePoints);
          mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 50), // 50はパディング（調整可能）
          );
        }

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

  // polylineを使える形式に変更
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

  // 近くのガソスタを検索
  Future<void> searchNearbyGasStations(BuildContext context) async {
    if (_currentPosition == null) return;

    final lat = _currentPosition!.latitude;
    final lng = _currentPosition!.longitude;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=$lat,$lng'
      '&radius=10000' // 10km圏内の検索
      '&type=gas_station' // ガソリンスタンドを検索
      '&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        Set<Marker> gasStationMarkers = {};

        for (var result in data['results']) {
          final loc = result['geometry']['location'];
          final name = result['name'];
          final position = LatLng(loc['lat'], loc['lng']);

          gasStationMarkers.add(
            Marker(
              markerId: MarkerId(result['place_id']),
              position: position,
              infoWindow: InfoWindow(title: name),
            ),
          );
        }

        updateMarkers(gasStationMarkers);
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ガソリンスタンドを検索できませんでした')));
      }
    } catch (e) {
      debugPrint('ガソリンスタンド検索例外: $e');
    }
  }
}
