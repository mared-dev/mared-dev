import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mared_social/constants/general_styles.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController passwordController;
  final String? Function(String? value)? validator;
  final String hintText;

  PasswordTextField(
      {required this.passwordController,
      required this.validator,
      this.hintText = 'Password'});
  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool showText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showText = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.passwordController,
        cursorColor: Colors.black,
        obscureText: !showText,
        enableSuggestions: false,
        autocorrect: false,
        decoration: getAuthInputDecoration(
            prefixIcon: Icons.lock_outline,
            hintText: widget.hintText,
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  showText = !showText;
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: 22,
                height: 18,
                child: SvgPicture.asset(
                  'assets/icons/eye_icon.svg',
                  width: 22,
                  height: 18,
                  fit: BoxFit.fill,
                ),
              ),
            )),
        validator: widget.validator);
  }
}
