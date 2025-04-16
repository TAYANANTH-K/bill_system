import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:math';
import 'search_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> billItems = [];
  List<CameraDescription> cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  final List<Map<String, dynamic>> sampleProducts = [
    {"name": "Milk", "price": 45},
    {"name": "Bread", "price": 30},
    {"name": "Rice", "price": 120},
    {"name": "Eggs", "price": 60},
    {"name": "Butter", "price": 50}
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startCameraDetection();
  }

  /// Initializes the camera
  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  /// Simulates barcode scanning every 5 seconds
  void _startCameraDetection() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        _simulateProductDetection();
      }
    });
  }

  /// Simulates a product being detected
  void _simulateProductDetection() {
    final random = Random();
    var newItem = sampleProducts[random.nextInt(sampleProducts.length)];

    setState(() {
      billItems.add(newItem);
    });
  }

  int _calculateTotalAmount() {
    return billItems.fold(0, (sum, item) => sum + (item["price"] as int));
  }

  void _processPayment() {
    // Dummy function for Razorpay integration
    print("Proceeding to Razorpay payment...");
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Trolley Dashboard"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: Text("Locate Products"),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Side - Camera Feed
          Expanded(
            flex: 2,
            child: Container(
              height: 200,
              color: Colors.black,
              child: _isCameraInitialized
                  ? CameraPreview(_cameraController!)
                  : Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          // Right Side - Bill List
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bill Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: billItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(billItems[index]["name"]),
                          trailing: Text("₹${billItems[index]["price"]}"),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Text("Total: ₹${_calculateTotalAmount()}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _processPayment,
                    child: Text("Click to Pay"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
