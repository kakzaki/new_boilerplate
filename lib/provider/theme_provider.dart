import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import '../provider/setting.dart';
import 'package:provider/provider.dart';
import '../enumextension/selected_theme.dart';

const keyTheme = 'Theme';

class ThemeProvider with ChangeNotifier {
  SelectedTheme selectedTheme = SelectedTheme.light;
  bool isSystemDarkMode = false;

  var box = Hive.box(boxSetting);

  void init() async {
    box = await Hive.openBox(keyTheme);
    if (box.get(keyTheme) != null) {
      selectedTheme = getSelectedThemeID(box.get(keyTheme));
    }
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    isSystemDarkMode = brightness == Brightness.dark ? true : false;
    notifyListeners();
  }

  void setTheme({required SelectedTheme selectedTheme}) async {
    box.put(keyTheme, selectedTheme.name);
    this.selectedTheme = selectedTheme;
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    isSystemDarkMode = brightness == Brightness.dark ? true : false;
    debugPrint("selectedThemeInProvider: $selectedTheme");
    notifyListeners();
  }

  SelectedTheme get theme => selectedTheme;

  TextStyle get textStyleDefault {
    return TextStyle(color: colorFont, fontSize: 16);
  }

  Color get colorBackground {
    return Colors.grey.shade50;
  }

  Color get colorPrimary {
    return Colors.orange;
  }

  Color get colorPrimaryFont {
    return Colors.white;
  }

  Color get colorFont {
    return Colors.grey.shade800;
  }

  Color get colorGrey {
    return Colors.grey.shade600;
  }
}

Size mediaSize(BuildContext context) => MediaQuery.of(context).size;
ThemeProvider theme(BuildContext context) =>
    Provider.of<ThemeProvider>(context, listen: false);
