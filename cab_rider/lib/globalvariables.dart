import 'package:cab_rider/datamodels/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = 'AIzaSyCMY0WiYYW-LcNZBXaKhL5gqQldvf5p65Y';




 final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);


UserModelFile currentUserInfo ;

