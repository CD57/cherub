import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DateMap extends StatefulWidget {
  const DateMap({Key? key}) : super(key: key);

  @override
  State<DateMap> createState() => _DateMapState();
}

class _DateMapState extends State<DateMap> {
  String location = "Choose a location";
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  LatLng selectedLocation = const LatLng(0.0, 0.0);
  LatLng beginLocation = const LatLng(53.23934, -7.76989);

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
                  target: beginLocation,
                  zoom: 7.0,
                ),
                mapType: MapType.normal,
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
                        selectedLocation = LatLng(
                            cameraPosition!.target.latitude,
                            cameraPosition!.target.longitude);
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
                                        selectedLocation.toString());
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

  @override
  void initState() {
    if (kDebugMode) {
      print("Map.dart - initState");
    }
    super.initState();
  }
}
