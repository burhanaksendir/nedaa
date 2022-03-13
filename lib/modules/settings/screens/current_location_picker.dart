import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CurrentLocationPicker extends StatefulWidget {
  const CurrentLocationPicker({Key? key}) : super(key: key);

  @override
  State<CurrentLocationPicker> createState() => _CurrentLocationPickerState();
}

class _CurrentLocationPickerState extends State<CurrentLocationPicker> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  // LocationPermission permission = LocationPermission.unableToDetermine;

  _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    debugPrint(permission.toString());
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _getCurrentLocation();
    } else if (permission == LocationPermission.denied) {
      LocationPermission reqPermission = await Geolocator.requestPermission();
      if (reqPermission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      } else {
        _getCurrentLocation();
      }
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }
  }

  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    setState(() {
      cityValue = placemark.locality!;
      countryValue = placemark.country!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t!.currentLocation),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          CSCPicker(
            ///Enable disable state dropdown [OPTIONAL PARAMETER]
            showStates: true,

            /// Enable disable city drop down [OPTIONAL PARAMETER]
            showCities: true,

            ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
            flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

            ///placeholders for dropdown search field
            countrySearchPlaceholder: t.country,
            stateSearchPlaceholder: t.state,
            citySearchPlaceholder: t.city,

            ///labels for dropdown
            countryDropdownLabel: t.country,
            stateDropdownLabel: t.state,
            cityDropdownLabel: t.city,

            ///Default Country
            //defaultCountry: DefaultCountry.India,

            ///Disable country dropdown (Note: use it with default country)
            //disableCountry: true,

            ///Dialog box radius [OPTIONAL PARAMETER]
            dropdownDialogRadius: 10.0,

            ///Search bar radius [OPTIONAL PARAMETER]
            searchBarRadius: 10.0,

            ///triggers once country selected in dropdown
            onCountryChanged: (value) {
              setState(() {
                ///store value in country variable
                countryValue = value;
              });
            },

            ///triggers once state selected in dropdown
            onStateChanged: (value) {
              if (value != null) {
                setState(() {
                  stateValue = value;
                });
              }
            },

            ///triggers once city selected in dropdown
            onCityChanged: (value) {
              if (value != null) {
                setState(() {
                  cityValue = value;
                });
              }
            },
          ),
          const Divider(),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(t.getCurrentLocation),
                onPressed: () async {
                  _checkPermission();
                },
              ),
            ],
          ),
          cityValue.isNotEmpty && countryValue.isNotEmpty
              ? Text(
                  '$cityValue, $countryValue',
                  style: Theme.of(context).textTheme.headline6,
                )
              : const SizedBox(),
        ]),
      ),
    );
  }
}
