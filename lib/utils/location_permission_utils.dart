import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/settings/bloc/user_settings_bloc.dart';
import 'package:nedaa/modules/settings/models/user_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> checkPermission(BuildContext context) async {
  LocationPermission permission = await Geolocator.checkPermission();
  switch (permission) {
    case LocationPermission.always:
    case LocationPermission.whileInUse:
      return true;
    case LocationPermission.denied:
      LocationPermission reqPermission = await Geolocator.requestPermission();
      if (reqPermission == LocationPermission.deniedForever ||
          reqPermission == LocationPermission.denied) return false;
      // managed to get permission
      return true;
    case LocationPermission.deniedForever:
      return false;
    case LocationPermission.unableToDetermine:
      // only supported in browsers, so we can't get here
      return false;
  }
}

Future<void> openLocationSettings(BuildContext context) async {
  await Geolocator.openAppSettings();
}

updateCurrentLocation(BuildContext context) async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low);
  await updateUserLocation(context, position.latitude, position.longitude);
}

Future<UserLocation> updateUserLocation(
    BuildContext context, double latitude, double longitude) async {
  var t = AppLocalizations.of(context);

  List<Placemark> placemarks = await placemarkFromCoordinates(
    latitude,
    longitude,
    localeIdentifier: t!.localeName,
  );
  Placemark placemark = placemarks[0];

  var userLocation = UserLocation(
    city: placemark.locality!,
    country: placemark.country!,
    state: placemark.administrativeArea!,
    location: Location(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
    ),
  );
  var userSettingsBloc = context.read<UserSettingsBloc>();
  var userSettingsState = userSettingsBloc.state;
  userSettingsBloc.add(
    UserLocationEvent(userLocation),
  );

  context.read<PrayerTimesBloc>().add(
      FetchPrayerTimesEvent(userLocation, userSettingsState.calculationMethod));

  return userLocation;
}
