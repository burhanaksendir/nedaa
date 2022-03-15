import 'package:geocoding/geocoding.dart';

class UserLocation {
  final Location? location;
  final String? country;
  final String? state;
  final String? city;

  UserLocation({this.location, this.country, this.state, this.city});

  String? get cityAddress => city ?? state;
}
