import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/widgets/bottom_sheets/auth_sheets/login_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

ForgotPasswordSheet(BuildContext context) {
  TextEditingController userEmailController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                      padding: const EdgeInsets.only(top: 8.0),
                      child: FloatingActionButton(
                          backgroundColor: constantColors.blueColor,
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () async {
                            print('@@@@@@@@@@@@@@@@@@@@@@');
                            if (_formKey.currentState!.validate()) {
                              try {
                                await Provider.of<Authentication>(context,
                                        listen: false)
                                    .resetPassword(
                                  userEmailController.text,
                                );

                                Navigator.of(context).pop();
                                LoginSheet(context);
                              } catch (e) {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  title: "operation Failed",
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
