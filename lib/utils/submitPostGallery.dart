import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';

class SubmitAuctionScreen extends StatefulWidget {
  final String auctionCategory;

  const SubmitAuctionScreen({Key? key, required this.auctionCategory})
      : super(key: key);
  @override
  _SubmitAuctionScreenState createState() => _SubmitAuctionScreenState();
}

class _SubmitAuctionScreenState extends State<SubmitAuctionScreen> {
  final ConstantColors constantColors = ConstantColors();
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final startingPriceController = TextEditingController();
  final minimumBidController = TextEditingController();
  TextEditingController adrController = TextEditingController();
  int _current = 0;
  late UploadTask imagePostUploadTask;

  @override
  void dispose() {
    super.dispose();
  }

  List<XFile> multipleImages = [];
  List<String> imagesList = [];

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.queryAutocomplete.get(value);
    if (result != null && result.predictions != null) {
      predictions = result.predictions!;
    }
  }

  getDetils({required String placeId, required GooglePlace googlePlace}) async {
    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null) {
      detailsResult = result.result!;

      lat = detailsResult.geometry!.location!.lat.toString();
      lng = detailsResult.geometry!.location!.lng.toString();
    }
  }

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  //Method for showing the date picker
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(2021),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2023)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Empty Selection",
            text: "Start date cannot be empty");
        return;
      }

      if (pickedDate.isBefore(DateTime.now())) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Start date Error",
            text:
                "Start date cannot be before ${DateTime.now().toString().substring(0, 10)}");
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedStartDate = pickedDate;
      });
    });
  }

  Future uploadAuctionImageToFirebase() async {
    for (var element in multipleImages) {
      Reference imageReference = FirebaseStorage.instance
          .ref()
          .child('posts/${element.path}/${TimeOfDay.now()}');

      imagePostUploadTask = imageReference.putFile(File(element.path));
      await imagePostUploadTask.whenComplete(() {});
      await imageReference.getDownloadURL().then((imageUrl) {
        imagesList.add(imageUrl);
      });
    }
  }

  Future<List<XFile>> multiImagePicker() async {
    List<XFile>? _images = await ImagePicker().pickMultiImage();
    if (_images != null && _images.isNotEmpty) {
      return _images;
    }
    return [];
  }

  void _pickEndDateDialog() {
    showDatePicker(
            context: context,
            initialDate: _selectedStartDate!,
            //which date will display when user open the picker
            firstDate: DateTime(2021),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2023)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null || pickedDate.isBefore(_selectedStartDate!)) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Date Selection Error",
            text: "End Date cannot be before Start Date");
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedEndDate = pickedDate;
      });
    });
  }

  GooglePlace googlePlace =
      GooglePlace("AIzaSyCHjJlqqJ-eLChGmUX0RH2iJH5TtdU3RrI");

  List<AutocompletePrediction> predictions = [];
  late DetailsResult detailsResult;

  late String lat;
  late String lng;
  String address = "";
  bool adrSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: constantColors.blueGreyColor,
        title: Text(
          "Auction Form",
          style: TextStyle(
            color: constantColors.blueColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(EvaIcons.arrowBackOutline),
          color: constantColors.greenColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                multipleImages = await multiImagePicker();
                if (multipleImages.isNotEmpty) {
                  setState(() {});
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                color: constantColors.lightColor,
                child: multipleImages.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.image,
                            size: 60,
                            color: constantColors.whiteColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              "Add Auction Photos",
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Swiper(
                        autoplay: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.file(
                            File(multipleImages[index].path),
                            fit: BoxFit.cover,
                          );
                        },
                        itemCount: multipleImages.length,
                        itemHeight: MediaQuery.of(context).size.height * 0.3,
                        itemWidth: MediaQuery.of(context).size.width,
                        layout: SwiperLayout.DEFAULT,
                        indicatorLayout: PageIndicatorLayout.SCALE,
                        pagination: SwiperPagination(
                          margin: EdgeInsets.all(10),
                          builder: DotSwiperPaginationBuilder(
                            color: constantColors.whiteColor.withOpacity(0.6),
                            activeColor:
                                constantColors.darkColor.withOpacity(0.6),
                            size: 15,
                            activeSize: 15,
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FieldValue(
                          constantColors: constantColors,
                          maxLines: 1,
                          controller: titleController,
                          header: "Title",
                          validator: (value) =>
                              value!.isEmpty ? "Title cant be empty" : null,
                          hintValue: "Example: Incredible S-Class For Auction",
                        ),
                        FieldValue(
                          constantColors: constantColors,
                          maxLines: 5,
                          controller: descriptionController,
                          keyboardType: TextInputType.text,
                          header: "Description",
                          validator: (value) => value!.isEmpty
                              ? "Description cant be empty"
                              : null,
                          hintValue:
                              "Example: Great Condition, Top of the line specs, barely used and kept with love. Auctioning off for it find a better home!",
                        ),
                        FieldValue(
                          constantColors: constantColors,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          controller: startingPriceController,
                          header: "Starting Price",
                          validator: (value) => value!.isEmpty
                              ? "Starting Price cant be empty"
                              : null,
                          hintValue: "Example: AED 100",
                        ),
                        FieldValue(
                          constantColors: constantColors,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          controller: minimumBidController,
                          header: "Minimum Bid",
                          validator: (value) => value!.isEmpty
                              ? "Minimum bid amount cant be empty"
                              : null,
                          hintValue: "Example: AED 10",
                        ),
                        Visibility(
                          visible: adrSelected == false,
                          child: SizedBox(
                            child: FieldValue(
                              constantColors: constantColors,
                              controller: adrController,
                              header: "Location",
                              validator: (value) => value!.isEmpty
                                  ? "Location cant be empty"
                                  : null,
                              hintValue: "Example: The Dubai Mall",
                              maxLines: 1,
                              function: (value) {
                                if (value.isNotEmpty) {
                                  autoCompleteSearch(value);
                                } else {
                                  if (predictions.isNotEmpty) {
                                    predictions = [];
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            width: 330,
                            color: constantColors.darkColor,
                            height: predictions.isNotEmpty ? 100 : 0,
                            child: ListView.builder(
                              itemCount: predictions.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Icon(
                                      Icons.pin_drop,
                                      color: constantColors.whiteColor,
                                      size: 12,
                                    ),
                                  ),
                                  title: Text(
                                    predictions[index].description!,
                                    style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 10,
                                    ),
                                  ),
                                  onTap: () async {
                                    await getDetils(
                                      googlePlace: googlePlace,
                                      placeId: predictions[index].placeId!,
                                    );

                                    setState(() {
                                      address = predictions[index].description!;
                                      adrSelected = true;
                                      predictions = [];
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: address.isNotEmpty && adrSelected == true,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Selected Address: $address",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: constantColors.greenColor,
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
                                icon: Icon(
                                  Icons.edit,
                                  color: constantColors.redColor,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Set Start and End Date",
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: _selectedStartDate == null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                  child:
                                                      const Text('Start Date'),
                                                  onPressed: _pickDateDialog),
                                            )
                                          : Stack(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    _selectedStartDate!
                                                        .toString()
                                                        .substring(0, 10),
                                                    style: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _selectedStartDate =
                                                            null;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.clear,
                                                      size: 18,
                                                      color: constantColors
                                                          .darkColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                    Text(
                                      " - ",
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                      ),
                                    ),
                                    Expanded(
                                      child: _selectedEndDate == null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                  child: const Text('End Date'),
                                                  onPressed:
                                                      _pickEndDateDialog),
                                            )
                                          : Stack(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    _selectedEndDate!
                                                        .toString()
                                                        .substring(0, 10),
                                                    style: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          _selectedEndDate =
                                                              null;
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.clear,
                                                      size: 18,
                                                      color: constantColors
                                                          .darkColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: constantColors.lightColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Your Personal Info",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        FieldValue(
                          constantColors: constantColors,
                          maxLines: 1,
                          controller: emailController,
                          header: "Email",
                          validator: (value) =>
                              value!.isEmpty ? "Email cannot be empty" : null,
                          hintValue: "Example: john.doe@gmail.com",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        FieldValue(
                          constantColors: constantColors,
                          maxLines: 1,
                          controller: phoneController,
                          header: "Phone Number",
                          validator: (value) =>
                              value!.isEmpty || value.length < 10
                                  ? "Error - Must be as 05X XXX XXXX"
                                  : null,
                          hintValue: "Example: 05X XXX XXXX",
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            constantColors.greenColor),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate() &&
                                        multipleImages.isNotEmpty) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.loading,
                                          title: "Posting Your Auction");
                                      await uploadAuctionImageToFirebase()
                                          .whenComplete(() {
                                        print(imagesList.length);
                                        String auctionId =
                                            nanoid(14).toString();
                                        String name =
                                            "${titleController.text} ${descriptionController.text}";

                                        List<String> splitList =
                                            name.split(" ");
                                        List<String> indexList = [];

                                        for (int i = 0;
                                            i < splitList.length;
                                            i++) {
                                          for (int j = 0;
                                              j < splitList[i].length;
                                              j++) {
                                            indexList.add(splitList[i]
                                                .substring(0, j + 1)
                                                .toLowerCase());
                                          }
                                        }
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .uploadAuctionData(auctionId, {
                                          'auctionid': auctionId,
                                          'searchindex': indexList,
                                          'auctioncategory':
                                              widget.auctionCategory,
                                          'title': titleController.text,
                                          'views': 0,
                                          'username':
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .getInitUserName,
                                          'userimage':
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .getInitUserImage,
                                          'useruid':
                                              Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .getUserId,
                                          'time': Timestamp.now(),
                                          'useremail':
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .getInitUserEmail,
                                          'description':
                                              descriptionController.text,
                                          'imageslist': imagesList,
                                          'address': address,
                                          'lat': lat,
                                          'lng': lng,
                                          'startingprice':
                                              startingPriceController.text,
                                          'minimumbid':
                                              minimumBidController.text,
                                          'currentprice':
                                              startingPriceController.text,
                                          'phone': phoneController.text,
                                          'startdate': Timestamp.fromDate(
                                              _selectedStartDate!),
                                          'enddate': Timestamp.fromDate(
                                              _selectedEndDate!),
                                        }).whenComplete(() async {
                                          // Add data under user profile
                                          return FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .getUserId)
                                              .collection("auctions")
                                              .doc(auctionId)
                                              .set({
                                            'auctionid': auctionId,
                                            'searchindex': indexList,
                                            'auctioncategory':
                                                widget.auctionCategory,
                                            'views': 0,
                                            'title': titleController.text,
                                            'phone': phoneController.text,
                                            'username':
                                                Provider.of<FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .getInitUserName,
                                            'userimage':
                                                Provider.of<FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .getInitUserImage,
                                            'useruid':
                                                Provider.of<Authentication>(
                                                        context,
                                                        listen: false)
                                                    .getUserId,
                                            'time': Timestamp.now(),
                                            'useremail':
                                                Provider.of<FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .getInitUserEmail,
                                            'description':
                                                descriptionController.text,
                                            'currentprice':
                                                startingPriceController.text,
                                            'imageslist': imagesList,
                                            'address': address,
                                            'lat': lat,
                                            'lng': lng,
                                            'startingprice':
                                                startingPriceController.text,
                                            'minimumbid':
                                                minimumBidController.text,
                                            'startdate': Timestamp.fromDate(
                                                _selectedStartDate!),
                                            'enddate': Timestamp.fromDate(
                                                _selectedEndDate!),
                                          });
                                        }).whenComplete(() {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      });
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          title: "Missing Fields",
                                          text:
                                              "Please ensure all fields have been filed out");
                                    }
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.paperPlane,
                                    color: constantColors.darkColor,
                                    size: 18,
                                  ),
                                  label: Text(
                                    "Post Auction",
                                    style: TextStyle(
                                      color: constantColors.darkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FieldValue extends StatelessWidget {
  const FieldValue({
    Key? key,
    required this.constantColors,
    required this.controller,
    required this.header,
    this.hintValue,
    required this.maxLines,
    this.keyboardType,
    this.function,
    this.maxLength,
    required this.validator,
  }) : super(key: key);

  final String header;
  final String? hintValue;
  final ConstantColors constantColors;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? function;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          TextFormField(
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
              counterStyle: TextStyle(
                color: constantColors.greenColor,
              ),
              hintText: hintValue,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: constantColors.lightBlueColor),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: constantColors.greyColor),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: function,
          ),
        ],
      ),
    );
  }
}
