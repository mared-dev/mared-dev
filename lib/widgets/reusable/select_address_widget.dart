import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../../constants/Constantcolors.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_api;

class SelectAddressWidget extends StatefulWidget {
  final Function setSelectedAddress;
  final String buttonText;
  final String startingAddress;

  const SelectAddressWidget(
      {Key? key,
      required this.setSelectedAddress,
      required this.buttonText,
      required this.startingAddress})
      : super(key: key);
  @override
  _SelectAddressWidgetState createState() => _SelectAddressWidgetState();
}

class _SelectAddressWidgetState extends State<SelectAddressWidget> {
  PickResult? selectedPlace;
  String lat = "";
  String lng = "";
  String address = "";
  bool adrSelected = false;
  TextEditingController adrController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    address = widget.startingAddress;
    adrSelected = (address.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: adrSelected == false,
          child: ElevatedButton.icon(
            icon: SvgPicture.asset('assets/icons/location_icon.svg'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              primary: AppColors.commentButtonColor,
            ),
            label: Text(
              widget.buttonText,
              style: regularTextStyle(
                  fontSize: 11, textColor: AppColors.backGroundColor),
            ),
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Container(
                      color: constantColors.whiteColor,
                      child: PlacePicker(
                        autocompleteComponents: [
                          google_maps_api.Component("country", "ae")
                        ],
                        apiKey: "AIzaSyCHjJlqqJ-eLChGmUX0RH2iJH5TtdU3RrI",
                        hintText: "Find a place ...",
                        searchingText: "Please wait ...",
                        selectText: "Select place",
                        outsideOfPickAreaText: "Place not in area",
                        initialPosition: LatLng(25.2048, 55.2708),
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        usePinPointingSearch: true,
                        usePlaceDetailSearch: true,
                        onPlacePicked: (result) {
                          selectedPlace = result;

                          String addressToShow = "";
                          int numOfComponents =
                              result.addressComponents!.length;
                          try {
                            addressToShow = 'UAE, ' +
                                result.addressComponents![numOfComponents - 2]
                                    .shortName +
                                ', ' +
                                result.addressComponents![numOfComponents - 4]
                                    .shortName;
                          } catch (e) {
                            addressToShow = 'UAE, Dubai';
                          }

                          Navigator.pop(context, {
                            "address": addressToShow,
                            "lat": result.geometry!.location.lat,
                            "lng": result.geometry!.location.lng
                          });
                        },
                        automaticallyImplyAppBarLeading: false,
                        region: 'ae',
                      ),
                    );
                  },
                ),
              );

              if (result['address'].toString().isNotEmpty) {
                setState(() {
                  adrSelected = true;
                  address = result['address'].toString();
                  lat = result['lat'].toString();
                  lng = result['lng'].toString();

                  widget.setSelectedAddress(address, lat, lng);
                });
              } else {
                setState(() {
                  adrSelected = false;
                });
              }
            },
          ),
        ),
        Visibility(
          visible: address.isNotEmpty && adrSelected == true,
          child: Container(
            width: 330,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Selected Address: $address",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: semiBoldTextStyle(
                      textColor: AppColors.accentColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      address = "";
                      adrSelected = false;
                    });
                    adrController.clear();
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.commentButtonColor,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
