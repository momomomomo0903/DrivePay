// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  GoogleMapController? mapController;
  bool _isMapRendered = false;
  bool _isMapCreated = false;

  @override
  bool get wantKeepAlive => true;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _isMapCreated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          onCameraIdle: () {
            if (_isMapCreated && !_isMapRendered) {
              Future.delayed(const Duration(seconds: 6), () {
                if (mounted) {
                  setState(() {
                    _isMapRendered = true;
                  });
                }
              });
            }
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(35.681236, 139.767125),
            zoom: 14,
          ),
        ),
        if (!_isMapRendered) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
