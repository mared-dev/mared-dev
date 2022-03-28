import 'package:flutter/material.dart';
import 'package:mared_social/widgets/reusable/auth_checkbox_item.dart';
import 'package:collection/collection.dart';

class AuthCheckBoxGroup extends StatefulWidget {
  final List<String> options;
  final changeSelectedItemCallback;

  const AuthCheckBoxGroup(
      {Key? key,
      required this.options,
      required this.changeSelectedItemCallback})
      : super(key: key);
  @override
  _AuthCheckBoxGroupState createState() => _AuthCheckBoxGroupState();
}

class _AuthCheckBoxGroupState extends State<AuthCheckBoxGroup> {
  List<bool> selectedList = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedList = List.filled(widget.options.length, false);
    selectedList[selectedIndex] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: widget.options
            .mapIndexed((index, option) => GestureDetector(
                  onTap: () {
                    _changeSelectedItem(index);
                  },
                  child: AuthCheckboxItem(
                    optionText: option,
                    isSelected: selectedList[index],
                  ),
                ))
            .toList());
  }

  _changeSelectedItem(int newIndex) {
    widget.changeSelectedItemCallback(newIndex);
    setState(() {
      selectedIndex = newIndex;
      selectedList = List.filled(widget.options.length, false);
      selectedList[selectedIndex] = true;
    });
  }
}
