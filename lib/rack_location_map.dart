import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RackLocationMapPage extends StatefulWidget {
  final String rack;
  final double lat;
  final double lng;

  RackLocationMapPage({
    required this.rack,
    required this.lat,
    required this.lng,
  });

  @override
  _RackLocationMapPageState createState() => _RackLocationMapPageState();
}

class _RackLocationMapPageState extends State<RackLocationMapPage> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    LatLng rackPosition = LatLng(widget.lat, widget.lng);

    return Scaffold(
      appBar: AppBar(
        title: Text("Map to ${widget.rack}"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: rackPosition,
          zoom: 18.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.rack),
            position: rackPosition,
            infoWindow: InfoWindow(
              title: widget.rack,
              snippet: "Product Rack",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        },
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
