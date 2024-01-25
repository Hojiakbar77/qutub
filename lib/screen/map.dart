import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:qutub/utils/colors.dart';

import '../blocs/location/location_bloc.dart';
import '../home.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(41.3111, 69.2406),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController langController = TextEditingController();
  Set<Marker> markers = {};
  late LatLng _currentCameraPosition;
  late String _currentAddressName = "";
  late String _currentAddressDescription = "";
  late String _currentAddressLot = "";
  late String _currentAddressLat = "";

  @override
  void dispose() {
    _googleMapController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void logOut() {
    final box = GetStorage();
    box.remove("accessToken");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const  HomePage(),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _googleMapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentCameraPosition = position.target;
    });
  }

  Future<void> _addMarker(LatLng position) async {
    // Clear existing markers
    markers.clear();

    // Perform reverse geocoding
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        Marker marker = Marker(
          markerId: MarkerId(markers.length.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: placemark.name, // Use placemark name
            snippet: placemark.street, // Use placemark street
          ),
        );

        setState(() {
          markers.add(marker);
          _currentAddressName = placemark.name ?? ""; // Set name from placemark
          _currentAddressDescription = placemark.street ?? ""; // Set street from placemark
          _currentAddressLot = position.longitude.toString();
          _currentAddressLat = position.latitude.toString();

          // Update TextFields with the new information
          titleController.text = _currentAddressName;
          descriptionController.text = _currentAddressDescription;
          lotController.text=_currentAddressLot;
          langController.text=_currentAddressLat;
          double? longitude = double.tryParse(lotController.text);
          double? latitude = double.tryParse(langController.text);
        });
      }
    } catch (e) {
      print("Error during reverse geocoding: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New ads",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color:  colorBlack),
        ),
        leading: const Icon(Icons.close, color: colorBlack),
        elevation: 0,
        backgroundColor: colorWhite,
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: const Icon(Icons.logout,color: colorBlack,),
          )
        ],
      ),
      body: BlocProvider(
  create: (context) => LocationBloc(),
  child: BlocListener<LocationBloc, LocationState>(
  listener: (context, state) {
    if(state is CheckDataFailure){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Data Error'),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    if(state is CheckDataSuccess){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Congratulation'),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  },
  child: BlocBuilder<LocationBloc, LocationState>(
  builder: (context, state) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text("street_number".tr()),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "enter_address_from_map".tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              text("address_street_repeat".tr()),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "address_street".tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(
                height: 5,
              ),
            text("Lang"),
              TextFormField(
                controller: langController,
                decoration: InputDecoration(
                  hintText: "Lang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(
                height: 5,
              ),
             text("Lot"),
              TextFormField(
                controller: lotController,
                decoration: InputDecoration(
                  hintText: "Lot",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 200,

                child: GoogleMap(
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _initialCameraPosition,
                  markers: markers,
                  onCameraMove: _onCameraMove,
                  onTap: (LatLng location) {
                    FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping on the map
                    _addMarker(location); // Add a marker when tapping on the map
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  double? longitude = double.tryParse(lotController.text);
                  double? latitude = double.tryParse(langController.text);
                  context.read<LocationBloc>().add(CheckUserEvent(
                    title: titleController.text,
                    description: descriptionController.text,
                    lot: longitude,
                    lang: latitude,
                  ));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,

                  color: colorBlack,
                  child: const Center(
                    child: Text("Save",style: TextStyle(color: colorWhite),),),
                ),
              )

            ],
          ),
        ),
      );
  },
),
),
),
    );
  }

}
Widget text(String name){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(name,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
  );
}
