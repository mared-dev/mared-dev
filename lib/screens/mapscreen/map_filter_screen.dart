import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/models/category_model.dart';

import '../../widgets/reusable/simple_appbar_with_back.dart';

class FilterPage extends StatelessWidget {
  final List<CategoryModel> selectedCategoryList;
  final Function onApplySelected;
  const FilterPage(
      {Key? key,
      required this.selectedCategoryList,
      required this.onApplySelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('******************');
    print(selectedCategoryList);
    return Scaffold(
      appBar: simpleAppBarWithBack(context,
          title: 'Filter Screen',
          leadingIcon: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            fit: BoxFit.fill,
            width: 22.w,
            height: 22.h,
          ), leadingCallback: () {
        Navigator.of(context).pop();
      }),
      body: SafeArea(
        child: FilterListWidget<CategoryModel>(
          themeData: FilterListThemeData(context),
          hideSelectedTextCount: true,
          listData: categories,
          selectedListData: selectedCategoryList,
          onApplyButtonClick: (list) {
            onApplySelected(list);
            Navigator.pop(context, list);
          },
          choiceChipLabel: (item) {
            /// Used to print text on chip
            return item!.categoryName;
          },

          // choiceChipBuilder: (context, item, isSelected) {
          //   return Container(
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //     decoration: BoxDecoration(
          //         border: Border.all(
          //       color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
          //     )),
          //     child: Text(item.name),
          //   );
          // },
          validateSelectedItem: (list, val) {
            ///  identify if item is selected or not
            return list!.contains(val);
          },
          onItemSearch: (user, query) {
            /// When search query change in search bar then this method will be called
            ///
            /// Check if items contains query
            return user.categoryName
                .toLowerCase()
                .contains(query.toLowerCase());
          },
        ),
      ),
    );
  }
}
