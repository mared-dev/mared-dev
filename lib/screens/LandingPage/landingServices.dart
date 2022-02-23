import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/models/sharedPrefUser.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LandingService with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userPhoneNoController = TextEditingController();
  bool store = false;

  final _formKey = GlobalKey<FormState>();
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
  ]);

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            bottom: true,
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Select Profile Picture",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: constantColors.transperant,
                    backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .userAvatar,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        child: Text(
                          "Reselect",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .pickUserAvatar(
                            context,
                            ImageSource.gallery,
                          );
                        },
                      ),
                      MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          "Confirm Image",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .uploadUserAvatar(context)
                              .whenComplete(() {
                            signUpSheet(context);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        });
  }

  Future<SharedPrefUser> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefUser userData;
    var itemData = prefs.getString("mydata");

    userData = sharedPrefUserFromJson(itemData!);

    return userData;
  }

  Widget passwordlessSignIn(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<SharedPrefUser>(
          future: getUser(),
          builder: (context, userData) {
            if (userData.hasError) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Welcome to Mared!\nSign up to connect with businesses near you!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ));
            } else {
              SharedPrefUser savedUserData = userData.data!;
              return ListTile(
                trailing: Container(
                  width: 120,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () async {
                          try {
                            await Provider.of<Authentication>(context,
                                    listen: false)
                                .loginIntoAccount(savedUserData.useremail!,
                                    savedUserData.userpassword!);

                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: SplitPages(),
                                  type: PageTransitionType.bottomToTop),
                            );
                          } catch (e) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              title: "Sign In Failed",
                              text: e.toString(),
                            );
                          }
                        },
                        icon: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.blueColor,
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     Provider.of<FirebaseOperations>(context,
                      //             listen: false)
                      //         .deleteUserData(documentSnapshot['useruid']);
                      //   },
                      //   icon: Icon(
                      //     FontAwesomeIcons.trashAlt,
                      //     color: constantColors.redColor,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: constantColors.darkColor,
                  backgroundImage: NetworkImage(savedUserData.userimage!),
                ),
                subtitle: Text(
                  savedUserData.useremail!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: constantColors.whiteColor,
                    fontSize: 12,
                  ),
                ),
                title: Text(
                  savedUserData.username!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: constantColors.greenColor,
                  ),
                ),
              );
            }
          },
        ));
  }

  loginSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SafeArea(
            bottom: true,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 150),
                        child: Divider(
                          thickness: 4,
                          color: constantColors.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: userEmailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: constantColors.whiteColor,
                              fontSize: 16,
                            ),
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: constantColors.whiteColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: userPasswordController,
                          validator: passwordValidator,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: constantColors.whiteColor,
                              fontSize: 16,
                            ),
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: constantColors.whiteColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: FloatingActionButton(
                            backgroundColor: constantColors.blueColor,
                            child: Icon(
                              FontAwesomeIcons.check,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await Provider.of<Authentication>(context,
                                          listen: false)
                                      .loginIntoAccount(
                                          userEmailController.text,
                                          userPasswordController.text);

                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: SplitPages(),
                                        type: PageTransitionType.bottomToTop),
                                  );
                                } catch (e) {
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    title: "Sign In Failed",
                                    text: e.toString(),
                                  );
                                }
                              } else {
                                warningText(context, "Fill all details");
                              }
                            }),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: constantColors.blueGreyColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      )),
                ),
              ),
            ),
          );
        });
  }

  signUpSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  ToggleSwitch(
                    changeOnTap: true,
                    minWidth: 130.0,
                    initialLabelIndex: 0,
                    borderWidth: 8,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ['Individual', ' Company'],
                    icons: const [
                      Icons.person,
                      FontAwesomeIcons.storeAlt,
                    ],
                    activeBgColors: const [
                      [Colors.blue],
                      [Colors.pink]
                    ],
                    onToggle: (index) {
                      if (index == 1) {
                        store = true;
                      } else {
                        store = false;
                      }
                      print(store);
                    },
                  ),
                  CircleAvatar(
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .getUserAvatar),
                    backgroundColor: constantColors.redColor,
                    radius: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: store == true ? "Company Name" : "Name",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      validator: (value) => value!.isEmpty
                          ? 'Contact Number cannot be blank'
                          : null,
                      controller: userPhoneNoController,
                      decoration: InputDecoration(
                        hintText: "Contact Number",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      validator: (value) =>
                          value!.isEmpty || !value.contains("@")
                              ? 'Invalid Email'
                              : null,
                      controller: userEmailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      validator: (value) => value!.isEmpty || value.length < 6
                          ? 'Password must be 6 Characters long'
                          : null,
                      controller: userPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                        backgroundColor: constantColors.redColor,
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () async {
                          if (userEmailController.text.isNotEmpty &&
                              userPasswordController.text.isNotEmpty &&
                              _formKey.currentState!.validate()) {
                            try {
                              await Provider.of<Authentication>(context,
                                      listen: false)
                                  .createAccount(userEmailController.text,
                                      userPasswordController.text);

                              SharedPreferences.setMockInitialValues({});

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.setString(
                                  'mydata',
                                  json.encode({
                                    'userpassword': userPasswordController.text,
                                    'usercontactnumber':
                                        userPhoneNoController.text,
                                    'store': store,
                                    'useruid': Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUserId,
                                    'useremail': userEmailController.text,
                                    'username': userNameController.text,
                                    'userimage': Provider.of<LandingUtils>(
                                            context,
                                            listen: false)
                                        .getUserAvatarUrl,
                                  }));

                              String name = "${userNameController.text} ";

                              List<String> splitList = name.split(" ");
                              List<String> indexList = [];

                              for (int i = 0; i < splitList.length; i++) {
                                for (int j = 0; j < splitList[i].length; j++) {
                                  indexList.add(splitList[i]
                                      .substring(0, j + 1)
                                      .toLowerCase());
                                }
                              }

                              await Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .createUserCollection(context, {
                                'userpassword': userPasswordController.text,
                                'usercontactnumber': userPhoneNoController.text,
                                'store': store,
                                'useruid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserId,
                                'useremail': userEmailController.text,
                                'username': userNameController.text,
                                'userimage': Provider.of<LandingUtils>(context,
                                        listen: false)
                                    .getUserAvatarUrl,
                                'usersearchindex': indexList,
                              });

                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: SplitPages(),
                                    type: PageTransitionType.bottomToTop),
                              );
                            } catch (e) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                title: "Sign In Failed",
                                text: e.toString(),
                              );
                            }
                          } else {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              title: "Sign Up Failed",
                              text: "Missing Details",
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
