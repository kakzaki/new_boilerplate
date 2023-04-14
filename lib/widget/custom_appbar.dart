import 'package:flutter/material.dart';
import '../constant/constant.dart';
import '../provider/theme_provider.dart';

PreferredSizeWidget customAppBarSmartWatch(BuildContext context,
    {required String title, List<Widget>? actions, Function()? customPop}) {
  return AppBar(
    elevation: 1,
    toolbarHeight: 60,
    surfaceTintColor: theme(context).colorBackground,
    shadowColor: Colors.grey,
    iconTheme: IconThemeData(color: theme(context).colorFont),
    automaticallyImplyLeading: false,
    leading: Navigator.canPop(context)
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: theme(context).colorFont,
              size: 24,
            ),
            onPressed: customPop ??
                () {
                  Navigator.of(context).pop();
                },
          )
        : null,
    centerTitle: false,
    backgroundColor: theme(context).colorBackground,
    title: Text(
      title,
      style: TextStyle(
          fontSize: fontSize1,
          color: theme(context).colorFont,
          fontWeight: FontWeight.w600),
    ),
    actions: actions,
  );
}
