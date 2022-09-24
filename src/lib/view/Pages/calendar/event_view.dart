import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uni/model/entities/event.dart';
import 'package:uni/view/Pages/calendar/calendar_view.dart';
import 'package:uni/view/Pages/calendar/edit_event_view.dart';
import 'package:uni/view/Pages/calendar/google_maps_view.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/calendar/rounded_large_button.dart';

import '../../../utils/utils.dart';


class EventView extends StatefulWidget{
  const EventView({Key key}) : super(key: key);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends GeneralPageViewState{
  CameraPosition _initialCameraPosition;
  GeocodingResult _foundLocation;
  bool isPositionAvailable = true;

  @override
  void initState(){
    _fetchLocation();
  }

  Future<void> _fetchLocation() async{
    final geocoder = GoogleGeocoding('AIzaSyAqG3CKqJpFR4Szv0lMZXQo-8ONC6h7cTo');
    geocoder.geocoding.get(tappedEvent.location, null).then(
      (response){
        if(response.status == 'OK'){
          _foundLocation = response.results[0];

          setState(() {
            _initialCameraPosition = CameraPosition(
                target: LatLng(
                    _foundLocation.geometry.location.lat,
                    _foundLocation.geometry.location.lng
                )
            );
          });
        }
        else{
          isPositionAvailable = false;
          setState(() {
            _initialCameraPosition = CameraPosition(
                target: LatLng(41.1892305, -8.5795003)
            );
          });
        }
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
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/3,
                  child: GoogleMap(
                    key: Key('Map'),
                    initialCameraPosition: _initialCameraPosition,
                    zoomControlsEnabled: false,
                    indoorViewEnabled: true,
                    minMaxZoomPreference: MinMaxZoomPreference(15, 20),
                    onTap: isPositionAvailable ?
                    _onGoogleMapsSuccessfulTap : _onGoogleMapsFailedTap,
                    markers: isPositionAvailable ? {
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
                    } : {},
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 2 * MediaQuery.of(context).size.height/3,
                    child: Container(
                      margin: EdgeInsets.all(25),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tappedEvent.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                    tappedEvent.description,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15
                                    )
                                ),
                              ),
                              SizedBox(
                                height: 10,
                                width: 1
                              ),
                              Text(
                                'Location',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                    tappedEvent.location,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15
                                    )
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Column(
                                    children: [
                                      RoundedLargeButton(
                                          text: 'Edit',
                                          isTextButton: true,
                                          textColor: Colors.green,
                                          onPressed: (context) async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => EditEvent())
                                            );
                                            setState(() {});
                                          }
                                      ),
                                      SizedBox(
                                          height: 10,
                                          width: 1
                                      ),
                                      RoundedLargeButton(
                                          text: 'Delete',
                                          backgroundColor: Colors.redAccent,
                                          onPressed: (context){
                                            Future.delayed(
                                                const Duration(seconds: 0),
                                                    () => _displayWarningAlert(context, tappedEvent));
                                          }
                                      ),
                                    ],
                                  )
                              )
                            ],
                          )
                        )
                    )
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height/3 - 40,
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: Icon(Icons.date_range_rounded, size: 30, color: tappedEvent.color),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(3),
                                child: Text(
                                  tappedEvent.dateToString(),
                                  style: const TextStyle(fontSize: 13, color: Colors.black),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3), 
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: Icon(tappedEvent.icon, size: 30, color: tappedEvent.color),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(3),
                                child: Text(
                                  tappedEvent.type,
                                  style: const TextStyle(fontSize: 13, color: Colors.black),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  void _onGoogleMapsSuccessfulTap(LatLng _){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GoogleMapsView())
    );
  }

  void _onGoogleMapsFailedTap(LatLng _){
    showDialog(
      context: context,
      builder: (BuildContext bc){
        return AlertDialog(
          title: const Text('Map view not available'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
                maxHeight: 150,
            ),
            child: const Text(
              "We couldn't find the location you requested, so the " +
              'focused map view is not available! Try to detail the location as best as possible'
                  "so errors like this don't occur so often.",
              style: TextStyle(color: Colors.grey)
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Got it'),
              onPressed: () => Navigator.pop(bc),
            ),
          ],
        );
      }
    );
  }

  void _displayWarningAlert(BuildContext context, Event event){
    showDialog(
        context: context,
        builder:(BuildContext bc){
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxHeight: 50,
                  maxWidth: 80
              ),
              child: const Center(
                  child: Text(
                    'Once the event is deleted you cannot undo it.',
                    style: TextStyle(color: Colors.grey),)
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('No'),
                    onPressed: () => Navigator.pop(bc),
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: (){
                      eventMap[event.date].remove(event);
                      setState(() {});
                      Navigator.pop(bc);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CalendarView())
                      );
                    },
                  ),
                ],
              )
            ],
          );
        }
    );
  }
}