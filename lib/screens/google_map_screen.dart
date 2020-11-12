import 'package:covidvaccineapp/state%20models/user_details_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatefulWidget {
  static const routeName = "/map";
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  PlacesSearchResponse hospitals;
  Set<Marker> markers = {};
  @override
  void initState() {
    hospitals = context.read<UserData>().nearbyHospitals;
    getMarkers();
    super.initState();
  }

  void getMarkers() {
    print("Showing places. Length is ${hospitals.results.length}");
    List<PlacesSearchResult> placesList = hospitals.results;
    for (final place in placesList) {
      print(place.name);
      markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position:
              LatLng(place.geometry.location.lat, place.geometry.location.lng),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(context.watch<UserData>().userLocation.latitude,
              context.watch<UserData>().userLocation.longitude),
          zoom: 18,
        ),
      ),
    );
  }
}
