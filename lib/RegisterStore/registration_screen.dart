// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nubankproject/RegisterStore/landing_screen.dart';
import 'package:nubankproject/firebase_services.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseServices _services = FirebaseServices();
  _saveToDB() {
    if (_formKey.currentState!.validate()) {}

    EasyLoading.show(status: 'Por favor aguarde...');

    _services
        .uploadImage(
            _shopImage, 'vendedores/${_services.user!.uid}/shopImage.jpg')
        .then((String? url) {
      if (url != null) {
        setState(() {
          _shopImageUrl = url;
        });
      }
    }).then(((value) {
      _services
          .uploadImage(_logo, 'vendedores/${_services.user!.uid}/logo.jpg')
          .then((url) {
        setState(() {
          _logoUrl = url;
        });
      }).then((value) {
        _services.addVendor(data: {
          'shopImage': _shopImageUrl,
          'logo': _logoUrl,
          'latitude': _lat,
          'longitude': _long,
          'businessName': _businessName.text,
          'contactNumber': _contactNumber.text,
          'email': _emailContact.text,
          'street': _rua,
          'streetNumber': _numero,
          'bairro': _bairro,
          'cidade': _cidade,
          'cep': _cep,
          'estado': _estado,
          'pais': _pais,
          'aprovado': false,
          'uid': _services.user!.uid,
          'time': DateTime.now()
        });
      }).then(((value) {
        EasyLoading.dismiss();
        return Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LandingScreen()));
      }));
    }));
  }

  String? _lat;
  String? _long;
  String? _rua;
  String? _numero;
  String? _bairro;
  String? _cidade;
  String? _cep;
  String? _estado;
  String? _pais;
  String? _address;
  String? _shopImageUrl;
  String? _logoUrl;

  final _formKey = GlobalKey<FormState>();
  final _businessName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _emailContact = TextEditingController();

  XFile? _shopImage;
  XFile? _logo;
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

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    _address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                          child: TextButton(
                            // ignore: prefer_const_constructors
                            child: Center(
                              child: Text(
                                'Adicionar Imagem',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            onPressed: () {
                              _pickImage().then((value) {
                                setState(() {
                                  _shopImage = value;
                                });
                              });
                            },
                          ))
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
                              color: Colors.amber,
                              image: DecorationImage(
                                  opacity: 100,
                                  image: FileImage(
                                    File(_shopImage!.path),
                                  ),
                                  fit: BoxFit.cover),
                            ),
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
                        InkWell(
                          onTap: () {
                            _pickImage().then((value) {
                              setState(() {
                                _logo = value;
                              });
                            });
                          },
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            child: _logo == null
                                ? const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                        child: Text(
                                      '+',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.amber),
                                    )),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                          child: Image.file(
                                        File(_logo!.path),
                                      )),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          _bName == null ? '' : _bName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )
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
                            return 'Coloque o numero para contato';
                          }
                        }),
                    _formField(
                        controller: _emailContact,
                        label: 'Email',
                        type: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Coloque seu email para contato';
                          }
                        }),
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: ElevatedButton(
                        child: Text('Achar posição'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 255, 255, 255),
                          backgroundColor: Color.fromARGB(255, 36, 131, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          // foreground
                        ),
                        onPressed: () async {
                          Position position = await _getGeoLocationPosition();
                          _lat = '${position.latitude}';
                          _long = '${position.longitude}';
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                  position.latitude, position.longitude);
                          Placemark place = placemarks[0];
                          _rua = '${place.thoroughfare}';
                          _numero = '${place.subThoroughfare}';
                          _bairro = '${place.subLocality}';
                          _cidade = '${place.subAdministrativeArea}';
                          _cep = '${place.postalCode}';
                          _estado = '${place.administrativeArea}';
                          _pais = '${place.country}';

                          GetAddressFromLatLong(position);
                        },
                      ),
                    ),
                    _formField(
                      controller: TextEditingController(text: _lat),
                      type: TextInputType.text,
                      label: 'Latitude',
                    ),
                    _formField(
                      controller: TextEditingController(text: _long),
                      type: TextInputType.text,
                      label: 'Longitude',
                    ),
                    _formField(
                        controller: TextEditingController(text: _rua),
                        type: TextInputType.text,
                        label: 'Rua',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Coloque o nome da rua onde a sua loja está';
                          }
                        }),
                    _formField(
                        controller: TextEditingController(text: _numero),
                        type: TextInputType.text,
                        label: 'Numero',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Coloque o numero da rua onde a sua loja está';
                          }
                        }),
                    _formField(
                        controller: TextEditingController(text: _bairro),
                        type: TextInputType.text,
                        label: 'Bairro',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Coloque o Bairro onde a sua loja está';
                          }
                        }),
                    _formField(
                        controller: TextEditingController(text: _cidade),
                        type: TextInputType.text,
                        label: 'Cidade',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Coloque a Cidade onde a sua loja está';
                          }
                        }),
                    _formField(
                      controller: TextEditingController(text: _cep),
                      type: TextInputType.text,
                      label: 'Cep',
                    ),
                    _formField(
                        controller: TextEditingController(text: _estado),
                        type: TextInputType.text,
                        label: 'Estado',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Coloque o Estado onde a sua loja está';
                          }
                        }),
                    _formField(
                        controller: TextEditingController(text: _pais),
                        type: TextInputType.text,
                        label: 'País',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Coloque o País onde a sua loja está';
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
                child: const Text('Registrar'),
                onPressed: () {
                  _saveToDB();
                },
              ),
            ))
          ])
        ],
      ),
    );
  }
}
