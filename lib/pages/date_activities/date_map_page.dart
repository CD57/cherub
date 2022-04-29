import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_it/get_it.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/location_service.dart';

class DateMap extends StatefulWidget {
  const DateMap({Key? key, required this.currentPosition}) : super(key: key);
  final LatLng currentPosition;
  @override
  State<DateMap> createState() => _DateMapState();
}

class _DateMapState extends State<DateMap> {
  late LocationService _locationService;
  String location = "Choose a location";
  String selectedLocation = "10,10";
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  late LatLng beginLocation = const LatLng(10.10, -10.10);

  @override
  void initState() {
    if (kDebugMode) {
      print("date_map_page.dart - initState");
    }
    super.initState();
    _locationService = GetIt.instance.get<LocationService>();
  }

  @override
  void didChangeDependencies() async {
    if (kDebugMode) {
      print("date_details_page.dart - didChangeDependencies()");
    }
    super.didChangeDependencies();
    String location = await _locationService.getCurrentLocationString();
    List<String> latLng = location.split(",");
    LatLng _locationLatLng = LatLng(double.parse(latLng[0]), double.parse(latLng[1]));

    setState(() {
      beginLocation = _locationLatLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Map.dart - build()");
    }

    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: const Center(child: Text("Choose a Date Location")),
              toolbarHeight: 45,
            ),
            body: Stack(children: [
              GoogleMap(
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: widget.currentPosition,
                  zoom: 7.0,
                ),
                mapType: MapType.hybrid,
                onMapCreated: (controller) {
                  if (mounted) {
                    if (kDebugMode) {
                      print("DateMap.dart - onMapCreate - setState");
                    }
                    setState(() {
                      mapController = controller;
                    });
                  }
                },
                onCameraMove: (CameraPosition cameraPositiona) {
                  cameraPosition = cameraPositiona;
                },
                onCameraIdle: () async {
                  List<Placemark> newPlace;
                  String stringLocation = "No Data on Location";
                  try {
                    newPlace = await placemarkFromCoordinates(
                        cameraPosition!.target.latitude,
                        cameraPosition!.target.longitude,
                        localeIdentifier: "en");
                    stringLocation = newPlace.first.street.toString();
                    if (kDebugMode) {
                      print(newPlace.first.street.toString());
                    }
                    if (mounted) {
                      setState(() {
                        if (kDebugMode) {
                          print("Map.dart - onCameraIdle - setState");
                        }
                        selectedLocation =
                            cameraPosition!.target.latitude.toString() +
                                "," +
                                cameraPosition!.target.longitude.toString();
                        location = stringLocation;
                      });
                    }
                  } on Exception catch (exception) {
                    if (kDebugMode) {
                      print(
                          "Map.dart - ExceptionError: " + exception.toString());
                    }
                  } catch (error) {
                    if (kDebugMode) {
                      print("Map.dart - " + error.toString());
                    }
                  }
                },
              ),
              Positioned(
                  bottom: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 300,
                          child: ListTile(
                            leading: const Icon(Icons.gps_not_fixed_sharp),
                            title: Text(
                              location,
                              style: const TextStyle(fontSize: 20),
                            ),
                            dense: true,
                          )),
                    ),
                  )),
              const Center(
                child: Icon(Icons.gps_not_fixed_sharp),
              ),
              Positioned(
                  bottom: 25,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: const EdgeInsets.all(0),
                          height: 50,
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              if (kDebugMode) {
                                print(
                                    "Map.dart - ElevatedButton - onPressed - Sending: " +
                                        selectedLocation);
                              }
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                Navigator.pop(context, selectedLocation);
                              });
                              if (kDebugMode) {
                                print(
                                    "Map.dart - ElevatedButton - onPressed - Finished");
                              }
                            },
                            child: const Text(
                              "Confirm Location",
                              style: TextStyle(fontSize: 20),
                            ),
                          )),
                    ),
                  ))
            ])));
  }
}
