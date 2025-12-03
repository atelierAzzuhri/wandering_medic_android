import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:medics_patient/features/account/widgets/add_address_detail.dart';
import 'package:medics_patient/logger.dart';
import 'package:medics_patient/store/location_store.dart';

// Class names remain AddressPage

class AddressPage extends ConsumerStatefulWidget {
  const AddressPage({super.key});

  @override
  // Renamed _MapViewState to _AddressPageState
  ConsumerState<AddressPage> createState() => _AddressPageState();
}

// Renamed _MapViewState to _AddressPageState
class _AddressPageState extends ConsumerState<AddressPage> {
  // Keeping initState for SDK initialization as it's typically a one-time setup
  @override
  void initState() {
    super.initState();
    _initializeHERESDK();
  }

  GeoCoordinates? _centerCoordinates;

  // --- Widget: Pluck Icon ---
  Widget _buildPluckIcon() {
    return const Icon(Icons.location_on, size: 40, color: Colors.redAccent);
  }
  // -------------------------

  // --- Functions (Futures) ---

  Future<void> _initializeHERESDK() async {
    logger.i('initializing HERE-SDK');
    SdkContext.init(IsolateOrigin.main);

    String accessKeyId = "CBphv7CsPNEF3hYRKDQWWg";
    String accessKeySecret =
        "AxliTA3GoB_AyXVt_kBvGxMYV2Q7wgMcUqOwJ1o-tKENZt57_SKv2LFD1n4ZyLKJF8NZSJlEsp0TuC9cZA9Pww";
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

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.best, // replaces desiredAccuracy
      distanceFilter: 0,
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    return GeoCoordinates(position.latitude, position.longitude);
  }

  // Renamed the function to reflect its purpose within the AddressPage context
  Future<void> _onAddressPageCreated(HereMapController hereMapController) async {
    GeoCoordinates? currentLocation = await getCurrentLocation();

    if (currentLocation == null) {
      logger.w('Cannot initialize map camera: Current location is null.');
      return;
    }

    // The camera can be configured before or after a scene is loaded.
    const double distanceToEarthInMeters = 8000;
    MapMeasure mapMeasureZoom = MapMeasure(
      MapMeasureKind.distanceInMeters,
      distanceToEarthInMeters,
    );
    hereMapController.camera.lookAtPointWithMeasure(
      currentLocation,
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

  // --- Show Sheet Function ---

  void _showSheet(BuildContext context) {
    // Assuming AddLocationDetail is now imported
    // The implementation remains the same, assuming AddLocationDetail is visible
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF212529),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Assuming AddLocationDetail is a globally visible widget now
          child: const AddAddressDetail(),
        );
      },
    );
  }

  // --- Widget Build ---
  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add Location',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFFD7ED72),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD7ED72)),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Changed onMapCreated call to the new function name
            HereMap(onMapCreated: _onAddressPageCreated),
            Center(child: _buildPluckIcon()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSheet(context);
        },
        icon: const Icon(Icons.edit_location_alt, color: Color(0xFFD7ED72)),
        label: Text(
          'Confirm & Add Details',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFFD7ED72),
          ),
        ),
        backgroundColor: const Color(0xFF212529),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}