import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LokasiPage extends StatefulWidget {
  @override
  _LokasiPageState createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {

  final LatLng pnp = LatLng(-0.9137768,100.4640162);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Politeknik Negeri Padang'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('Politeknik Negeri Padang',
                    style: TextStyle(fontSize: 18,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold),),
                  ),
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: pnp,
                          zoom: 10.0
                        ),
                        markers: Set<Marker>.of(
                          <Marker>[
                            Marker(
                              markerId: MarkerId("id_pnp"),
                              position:  LatLng(pnp.latitude, pnp.longitude),
                              infoWindow: InfoWindow(
                                title: "Politeknik Negeri Padang",
                                snippet: "Politeknik Negeri padang"
                              )
                            )
                          ]
                        ),
                        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                          Factory<OneSequenceGestureRecognizer>(
                              () => ScaleGestureRecognizer(),
                          ),
                        ].toSet()
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ) ,
    );
  }
}
