import 'dart:ui';

import 'package:geocoding/geocoding.dart';

class UserLocation {
  final Location? location;
  final String? country;
  final String? state;
  final String? city;

  UserLocation({this.location, this.country, this.state, this.city});

  String? get cityAddress => city ?? state;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is UserLocation &&
        other.location == location &&
        other.country == country &&
        other.state == state &&
        other.city == city;
  }

  @override
  int get hashCode => hashValues(location, country, state, city);

  Map<String, dynamic> toJson() => {
        'location': location?.toJson(),
        'country': country,
        'state': state,
        'city': city,
      };

  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
        location: json['location'] == null
            ? null
            : Location.fromMap(json['location'] as Map<String, dynamic>),
        country: json['country'] as String?,
        state: json['state'] as String?,
        city: json['city'] as String?,
      );
}
