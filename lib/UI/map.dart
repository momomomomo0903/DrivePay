// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:drivepay/logic/map.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  GoogleMapController? mapController;
  CameraPosition? _initialLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  late MapLogic _mapLogic;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _viaController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _mapLogic = MapLogic(
      updateMarkers: (newMarkers) {
        setState(() {
          _markers = newMarkers;
        });
      },
      updateStartAddress: (address) {
        setState(() {
          _startController.text = address;
        });
      },
      updatePolylines: (newPolylines) {
        setState(() {
          _polylines = newPolylines;
        });
      },
    );

    _mapLogic.getCurrentLocation((cameraPosition) {
      setState(() {
        _initialLocation = cameraPosition;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _mapLogic.setMapController(controller);
    _mapLogic.getCurrentLocation((cameraPosition) {
      setState(() {
        _initialLocation = cameraPosition;
      });
    });
  }

  Widget buildSearchArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '目的地を検索',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onSubmitted: (value) async {
            await _mapLogic.searchNavigate(value);

            if (_mapLogic.currentPosition != null) {
              final LatLng address =
                  (await _mapLogic.getAddressFromLatLng(
                        LatLng(
                          _mapLogic.currentPosition!.latitude,
                          _mapLogic.currentPosition!.longitude,
                        ),
                      ))
                      as LatLng;

              if (address != null) {
                await _mapLogic.showPlaceDetailsFromMarker(context, address);
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('住所の取得に失敗しました')));
              }
            }
          },
        ),
        ElevatedButton(
          onPressed: () async {
            await _mapLogic.searchNearbyGasStations();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          child: const Text('近くのガソリンスタンドを探す'),
        ),
      ],
    );
  }

  void buildRouteSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.2,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    const Center(
                      child: Icon(Icons.drag_handle, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _startController,
                      decoration: InputDecoration(
                        hintText: '出発地を入力',
                        prefixIcon: const Icon(Icons.circle_outlined),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _destinationController,
                      decoration: InputDecoration(
                        hintText: '目的地を入力',
                        prefixIcon: const Icon(Icons.location_on),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSubmitted: (value) async {
                        final start =
                            _startController.text.isEmpty
                                ? await _mapLogic.getAddressFromLatLng(
                                  LatLng(
                                    _mapLogic.currentPosition!.latitude,
                                    _mapLogic.currentPosition!.longitude,
                                  ),
                                )
                                : _startController.text;

                        final destination = _destinationController.text;

                        if (destination.isEmpty) {
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: Text('エラー'),
                                  content: Text('目的地を入力してください'),
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

                        await _mapLogic.drawRoute(start, destination, context);
                        setState(() {});
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final start =
                            _startController.text.isEmpty
                                ? await _mapLogic.getAddressFromLatLng(
                                  LatLng(
                                    _mapLogic.currentPosition!.latitude,
                                    _mapLogic.currentPosition!.longitude,
                                  ),
                                )
                                : _startController.text;

                        final destination = _destinationController.text;

                        if (destination.isEmpty) {
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: Text('エラー'),
                                  content: Text('目的地を入力してください'),
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

                        await _mapLogic.drawRoute(start, destination, context);
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text('ルート検索'),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const Text(
                      '候補（例）',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListTile(title: Text('東京駅')),
                    ListTile(title: Text('渋谷スクランブル交差点')),
                  ],
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_initialLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialLocation!,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
              polylines: _polylines,
              zoomControlsEnabled: false,
              onTap: (LatLng tappedPoint) {
                _mapLogic.showPlaceDetailsFromMarker(context, tappedPoint);
              },
            ),
            Positioned(top: 10, left: 0, right: 0, child: buildSearchArea()),
            Positioned(
              bottom: 70,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  _mapLogic.moveToCurrentLocation(context);
                },
                child: const Icon(Icons.my_location),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  buildRouteSearch(context);
                },
                child: const Icon(Icons.turn_right_rounded),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
