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
  bool _isExpanded = false;
  Set<Marker> _markers = {};
  late MapLogic _mapLogic;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _startAddressController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _viaController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _mapLogic = MapLogic(
      mapController: mapController,
      updateMarkers: (newMarkers) {
        setState(() {
          _markers = newMarkers;
        });
      },
      updateStartAddress: (address) {
        setState(() {
          _startAddressController.text = address;
        });
      },
    );

    _mapLogic.getCurrentLocation((cameraPosition) {
      setState(() {
        _initialLocation = cameraPosition;
      });
    });
  }

  Widget buildRouteSearchArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '目的地',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
              onSubmitted: (value) async {
                await _mapLogic.searchNavigate(value);
              },
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  controller: _viaController,
                  decoration: const InputDecoration(
                    labelText: '経由地（任意）',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                TextField(
                  controller: _startController,
                  decoration: const InputDecoration(
                    labelText: '開始位置',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    final start =
                        _startController.text.isEmpty
                            ? '現在地'
                            : _startController.text;
                    final via = _viaController.text;
                    final destination = _searchController.text;

                    // TODO: MapLogicでルート検索を呼び出す
                  },
                  child: const Text('検索'),
                ),
              ],
            ),
          ),
          crossFadeState:
              _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
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
              mapType: MapType.normal,
              zoomControlsEnabled: false,
            ),
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: buildRouteSearchArea(),
            ),
            Positioned(
              bottom: 10,
              right: 16,
              child: ClipOval(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(Icons.my_location),
                    ),
                    onTap: () {
                      _mapLogic.moveToCurrentLocation(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
