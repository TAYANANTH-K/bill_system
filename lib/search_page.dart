import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'rack_location_map.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, Map<String, dynamic>> productRackMap = {
    "Milk": {"rack": "Rack A1"},
    "Bread": {"rack": "Rack A2"},
    "Rice": {"rack": "Rack B1"},
    "Eggs": {"rack": "Rack B2"},
    "Butter": {"rack": "Rack C1"},
    "Fruits": {"rack": "Rack D1"},
    "Vegetables": {"rack": "Rack D2"},
  };

  // Mock GPS coordinates for racks
  Map<String, LatLng> rackCoordinates = {
    'Rack A1': LatLng(37.4221, -122.0841),
    'Rack A2': LatLng(37.4222, -122.0842),
    'Rack B1': LatLng(37.4223, -122.0843),
    'Rack B2': LatLng(37.4224, -122.0844),
    'Rack C1': LatLng(37.4225, -122.0845),
    'Rack D1': LatLng(37.4226, -122.0846),
    'Rack D2': LatLng(37.4227, -122.0847),
  };

  List<String> products = [];
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    products = productRackMap.keys.toList();
  }

  void _searchProducts(String query) {
    setState(() {
      searchResults = products
          .where((product) =>
          product.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Products")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: _searchProducts,
              decoration: InputDecoration(
                hintText: "Search for products...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                String product = searchResults[index];
                var rackInfo = productRackMap[product]!;
                String rack = rackInfo['rack'];
                LatLng latLng = rackCoordinates[rack]!;

                return ListTile(
                  title: Text("$product ($rack)"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RackLocationMapPage(
                          rack: rack,
                          lat: latLng.latitude,
                          lng: latLng.longitude,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
