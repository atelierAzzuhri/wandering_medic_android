import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medics_patient/logger.dart';
import '../models/location_model.dart';

class LocationNotifier extends StateNotifier<LocationModel?> {
  LocationNotifier() : super(null) {
    _loadLocationFromPrefs();
  }

  Future<void> _loadLocationFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('location');

    if (jsonString != null) {
      logger.i('location jsonString: $jsonString');
      final jsonMap = jsonDecode(jsonString);
      state = LocationModel.fromJson(jsonMap);
    }
  }

  Future<void> setLocation(LocationModel model) async {
    logger.i('setting location: $model');
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    await prefs.setString('location', jsonString);
    state = model;
  }

  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('location');
    state = null;
  }
}

final locationProvider =
StateNotifierProvider<LocationNotifier, LocationModel?>(
      (ref) => LocationNotifier(),
);