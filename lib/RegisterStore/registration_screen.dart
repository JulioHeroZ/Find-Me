import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentPosition;

  final _businessName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _emailContact = TextEditingController();
  final _latitudeReg = TextEditingController();
  final _longitudeReg = TextEditingController();

  XFile? _shopImage;
  final ImagePicker _picker = ImagePicker();

  String? _bName;

  Widget _formField(
      {TextEditingController? controller,
      String? label,
      TextInputType? type,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixText: controller == _contactNumber ? '+55' : null,
      ),
      validator: validator,
      onChanged: (value) {
        if (controller == _businessName) {
          setState(() {
            _bName = value;
          });
        }
      },
    );
  }

  Future<XFile?> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
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
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 240,
            child: Stack(
              children: [
                _shopImage == null
                    ? Container(
                        color: Colors.amber,
                        height: 250,
                        child: Center(
                            child: TextButton(
                                child: const Center(
                                    child: Text(
                                  'Clique para adicionar a imagem',
                                  style: TextStyle(color: Colors.grey),
                                )),
                                onPressed: () {
                                  _pickImage().then((value) {
                                    setState(() {
                                      _shopImage = value;
                                    });
                                  });
                                })),
                      )
                    : InkWell(
                        onTap: () {
                          _pickImage().then((value) {
                            setState(() {
                              _shopImage = value;
                            });
                          });
                        },
                        child: Container(
                          height: 240,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              image: DecorationImage(
                                  image: FileImage(
                                    File(_shopImage!.path),
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                SizedBox(
                    height: 80,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.exit_to_app),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => MyAppBar(),
                              ),
                            );
                          },
                        ),
                      ],
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(children: [
                      const Card(
                        elevation: 5,
                        color: Colors.white,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                              child: Text(
                            '+',
                            style: TextStyle(fontSize: 30, color: Colors.amber),
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(_bName == null ? '' : _bName!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white))
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                children: [
                  _formField(
                      controller: _businessName,
                      label: 'Nome da loja',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Coloque o nome da sua loja';
                        }
                      }),
                  _formField(
                      controller: _contactNumber,
                      label: 'Numero para contato',
                      type: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Coloque o numero de contato';
                        }
                      }),
                  _formField(
                      controller: _emailContact,
                      label: 'Email',
                      type: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email';
                        }
                      }),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: ElevatedButton(
                      child: Text('Achar posição'),
                      style: ElevatedButton.styleFrom(
                        primary:
                            Color.fromARGB(255, 36, 131, 255), // background
                        onPrimary: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        // foreground
                      ),
                      onPressed: () {
                        print('Teste');
                      },
                    ),
                  ),
                  _formField(
                      controller: _latitudeReg,
                      label: 'Latitude',
                      type: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Latitude';
                        }
                      }),
                  _formField(
                      controller: _longitudeReg,
                      label: 'Longitude',
                      type: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Longitude';
                        }
                      }),
                ],
              ))
        ],
      )),
      persistentFooterButtons: [
        Row(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Registrar'),
              onPressed: () {},
            ),
          ))
        ])
      ],
    );
  }
}
