import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/store/location_store.dart';

import '../../../models/location_model.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  @override
  void initState() {
    super.initState();
    _initializeHERESDK();
  }

  GeoCoordinates? _centerCoordinates;

  void _showAddressSheet(BuildContext context, LocationModel? location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _AddressBottomSheet(location: location),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: Stack(
        children: [
          HereMap(onMapCreated: _onMapCreated),
          const Center(child: PluckIcon()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddressSheet(context, location),
        icon: const Icon(Icons.edit_location_alt),
        label: const Text('Edit Address'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _initializeHERESDK() async {
    logger.i('initializing HERE-SDK');
    SdkContext.init(IsolateOrigin.main);

    String accessKeyId = "CBphv7CsPNEF3hYRKDQWWg";
    String accessKeySecret =
        "AxliTA3GoB_AyXVt_kBvGxMYV2Q7wgMcUqOwJ1o-tKENZt57_SKv2LFD1n4ZyLKJF8NZSJvEsp0TuC9cZA9Pww";
    AuthenticationMode authenticationMode = AuthenticationMode.withKeySecret(
      accessKeyId,
      accessKeySecret,
    );
    SDKOptions sdkOptions = SDKOptions.withAuthenticationMode(
      authenticationMode,
    );

    try {
      await SDKNativeEngine.makeSharedInstance(sdkOptions);
    } on InstantiationException {
      logger.i("Failed to initialize the HERE SDK.");
      throw Exception("Failed to initialize the HERE SDK.");
    }
  }

  Future<GeoCoordinates?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      logger.i('location services are disabled');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        logger.i('location permissions are denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      logger.i('location permissions are permanently denied.');
      return null;
    }

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best, // replaces desiredAccuracy
      distanceFilter: 0,
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    return GeoCoordinates(position.latitude, position.longitude);
  }

  Future<void> _onMapCreated(HereMapController hereMapController) async {
    GeoCoordinates? currentLocation = await getCurrentLocation();
    // The camera can be configured before or after a scene is loaded.
    const double distanceToEarthInMeters = 8000;
    MapMeasure mapMeasureZoom = MapMeasure(
      MapMeasureKind.distanceInMeters,
      distanceToEarthInMeters,
    );
    hereMapController.camera.lookAtPointWithMeasure(
      currentLocation!,
      mapMeasureZoom,
    );

    hereMapController.gestures.panListener = PanListener((
        gestureState,
        origin,
        translation,
        velocity,
        ) {
      if (gestureState == GestureState.end) {
        final center = hereMapController.camera.state.targetCoordinates;

        setState(() {
          _centerCoordinates = center;
        });
        logger.i('Drag ended. Center: ${center.latitude}, ${center.longitude}');
      }
    });

    // Load the map scene using a map scheme to render the map with.
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (
        MapError? error,
        ) {
      if (error != null) {
        logger.i('Map scene not loaded. MapError: ${error.toString()}');
      }
    });
  }
}

class _AddressBottomSheet extends ConsumerStatefulWidget {
  final LocationModel? location;

  const _AddressBottomSheet({super.key, this.location});

  @override
  ConsumerState<_AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends ConsumerState<_AddressBottomSheet> {
  final _streetController = TextEditingController();
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final location = ref.read(locationProvider);
    _streetController.text = location?.street ?? '';
    _line1Controller.text = location?.province ?? '';
    _line2Controller.text = location?.city ?? '';
  }

  @override
  void dispose() {
    _streetController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32), // Increased bottom padding
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Please insert your address details correctly.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          _LabeledField(label: 'Street', controller: _streetController),
          _LabeledField(label: 'Address Line 1', controller: _line1Controller, isMultiline: true),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isMultiline;

  const _LabeledField({
    required this.label,
    required this.controller,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            maxLines: isMultiline ? 4 : 1,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PluckIcon extends StatelessWidget {
  const PluckIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.location_on, size: 40, color: Colors.redAccent);
  }
}
