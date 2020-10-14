import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// default android one was ugly and square
/// so created custom one :)
class ShowLocationButton extends StatelessWidget {
  const ShowLocationButton(
      {Key key,
      @required Completer<GoogleMapController> controller,
      @required CameraPosition userPosition})
      : _controller = controller,
        _userPosition = userPosition,
        super(key: key);

  final Completer<GoogleMapController> _controller;
  final CameraPosition _userPosition;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: RawMaterialButton(
          onPressed: () async {
            // animate camera over users location
            final controller = await _controller.future;
            await controller
                .animateCamera(CameraUpdate.newCameraPosition(_userPosition));
          },
          elevation: 2.0,
          fillColor: Colors.white,
          child: Icon(
            Icons.my_location,
            size: 25.0,
            color: Colors.grey,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
