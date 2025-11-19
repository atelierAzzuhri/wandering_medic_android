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

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF212529),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return IntrinsicHeight(child: AddLocationDetail());
      },
    );
  }

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
            color: Color(0xFFD7ED72),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD7ED72)),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            HereMap(onMapCreated: _onMapCreated),
            const Center(child: PluckIcon()),
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
            color: Color(0xFFD7ED72),
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

class PluckIcon extends StatelessWidget {
  const PluckIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.location_on, size: 40, color: Colors.redAccent);
  }
}

class AddLocationDetail extends ConsumerStatefulWidget {
  const AddLocationDetail({super.key});

  @override
  _AddLocationDetailState createState() => _AddLocationDetailState();
}

class _AddLocationDetailState extends ConsumerState<AddLocationDetail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController addressNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Text(
              'Address Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'complete address would  assist us better in serving you',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            // ADDRESS NAME
            const SizedBox(height: 24),
            Text(
              'Address Name',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: addressNameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your address name',
                hintStyle: TextStyle(color: Colors.white54),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'address name is required';
                }
                return null;
              },
            ),
            // ADDRESS LINE
            const SizedBox(height: 24),
            Text(
              'Address line',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: addressController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your address line',
                hintStyle: TextStyle(color: Colors.white54),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFD7ED72), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'address line is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD7ED72),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Handle valid submission
                    logger.i('address have been saved');
                  }
                },
                child: Text('save address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
