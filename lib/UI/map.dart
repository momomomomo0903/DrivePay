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
  late MapLogic _mapLogic;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _startAddressController = TextEditingController();

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
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: '場所を検索',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                      onSubmitted: (query) {
                        _mapLogic.searchPlace(query);
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      _mapLogic.searchNearbyGasStations();
                    },
                    child: const Text('近くのガソリンスタンドを探す'),
                  ),
                ],
              ),
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
