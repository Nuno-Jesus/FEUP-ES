import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uni/view/Pages/general_page_view.dart';

import '../../../model/entities/event.dart';
import '../../../utils/utils.dart';


class GoogleMapsView extends StatefulWidget{
  @override
  _GoogleMapsViewState createState() => _GoogleMapsViewState();

}

class _GoogleMapsViewState extends GeneralPageViewState with TickerProviderStateMixin{
  CameraPosition _initialCameraPosition;
  GeocodingResult _foundLocation;
  bool markerWasTapped = false;

  @override
  void initState(){
    _fetchLocation();
  }

  Future<void> _fetchLocation() async{
    var geocoder = GoogleGeocoding('AIzaSyAqG3CKqJpFR4Szv0lMZXQo-8ONC6h7cTo');
    geocoder.geocoding.get(tappedEvent.location, null).then(
      (response){
        /* If the specified location couldn't be matched, display the user's current location */
          _foundLocation = response.results[0];
          print(response.status);

          setState(() {
            _initialCameraPosition = CameraPosition(
              target: LatLng(
                  _foundLocation.geometry.location.lat,
                  _foundLocation.geometry.location.lng
              )
            );
          });

      }
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_initialCameraPosition == null){
      return Scaffold(
        appBar: buildAppBar(context),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: buildAppBar(context),
      body: GoogleMap(
        key: Key('Map'),
        initialCameraPosition: _initialCameraPosition,
        zoomControlsEnabled: false,
        indoorViewEnabled: true,
        minMaxZoomPreference: MinMaxZoomPreference(15, 20),
        markers: {
          Marker(
            markerId: MarkerId('${_foundLocation.geometry.location.lat}'),
            position: LatLng(
              _foundLocation.geometry.location.lat,
              _foundLocation.geometry.location.lng
            ),
            infoWindow: InfoWindow(
              title: _foundLocation.formattedAddress,
            ),
          )
        },
      ),
      /*bottomSheet: _buildBottomSheet(),*/
    );
  }
}