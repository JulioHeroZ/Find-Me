import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nubankproject/firebase_services.dart';
import 'package:nubankproject/model/product_model.dart';
import 'package:nubankproject/model/vendor_model.dart';
import 'package:search_page/search_page.dart';

import '../data_search/data_search.dart';

@override
class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.snapshot}) : super(key: key);
  final FirestoreQueryBuilderSnapshot? snapshot;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List productList = [];

  final FirebaseServices _services = FirebaseServices();
  late GoogleMapController mapController;
  Set<Marker> _markers = Set<Marker>();

  Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentPosition;
  var clients = [];
  LatLng? _latLong;
  bool _locating = false;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    getProductList();
    _getUserLocation();
    getMarkerData();
    super.initState();
  }

  getProductList() async {
    QuerySnapshot qn = await _services.produtos.get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        productList.add({
          "productImage": qn.docs[i]["productImage"],
          "productName": qn.docs[i]["productName"],
          "regularPrice": qn.docs[i]["regularPrice"],
          "uid": qn.docs[i]["uid"],
        });
      }
    });
    // return widget.snapshot?.docs.forEach((element) {
    //   Produto produto = element.data();
    //   setState(() {
    //     _productList.add(Produto(
    //       productName: produto.productName,
    //       regularPrice: produto.regularPrice,
    //     ));
    //   });
    // });
    return qn.docs;
  }

  // String uid = FirebaseAuth.instance.currentUser!.uid;
  getMarkerData() {
    _services.vendedor.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        initMarker(doc.data(), doc.id);
      }
    });
  }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),
      infoWindow: InfoWindow(title: specify['businessName']),
    );
    setState(() {
      markers[markerId] = marker;
      //print(markerId);
    });
  }

  Future<void> _goToCurrentPosition(LatLng latlng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latlng.latitude, latlng.longitude),
        //tilt: 59.440717697143555,
        zoom: 18)));
  }

  Future<LocationData> _getLocationPermission() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Service not enabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Permission Denied');
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  _getUserLocation() async {
    _currentPosition = await _getLocationPermission();
    _goToCurrentPosition(
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidht = MediaQuery.of(context).size.height;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 150, 3),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                );
              },
              decoration: InputDecoration(
                  hintText: 'Procurar',
                  prefixIcon: Icon(Icons.search_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white),
            ),
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidht,
        child: GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          markers: Set<Marker>.of(markers.values),
          zoomControlsEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onCameraMove: (CameraPosition position) {
            setState(() {
              _locating = true;
              _latLong = position.target;
            });
          },
        ),
      ),
    );
  }
}
