import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'provider/navigation.dart';
import 'provider/rest_api.dart';
import 'provider/setting.dart';
import 'provider/theme_provider.dart';
import 'provider/url.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constant/constant.dart';
import 'dbhelper/dbhelper.dart';
import 'home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => URL()),
          ChangeNotifierProvider(create: (_) => Navigation()),
          ChangeNotifierProvider(create: (_) => RestApi()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => Setting()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: nameApk,
            restorationScopeId: nameApk,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('id', 'ID'), // Indonesia, no country code
            ],
            theme: ThemeData(
                useMaterial3: true,
                fontFamily: 'MaisonNeue',
                visualDensity: VisualDensity.adaptivePlatformDensity,
                indicatorColor: Colors.orange,
                highlightColor: Colors.grey,
                primaryColor: Colors.orange,
                primaryColorDark: Colors.orange,
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(secondary: Colors.orange)),
            builder: (context, widget) => ResponsiveWrapper.builder(
                ClampingScrollWrapper.builder(context, widget!),
                defaultScale: true,
                maxWidth: 1200,
                minWidth: 450,
                breakpoints: [
                  const ResponsiveBreakpoint.resize(450, name: MOBILE),
                  const ResponsiveBreakpoint.resize(800, name: TABLET),
                  const ResponsiveBreakpoint.resize(1000, name: TABLET),
                  const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                  const ResponsiveBreakpoint.resize(2460, name: "4K"),
                ],
                background: Container(color: Colors.transparent)),
            home: const InitHomepage()));
  }
}

class InitHomepage extends StatefulWidget {
  const InitHomepage({Key? key}) : super(key: key);

  @override
  State<InitHomepage> createState() => _InitHomepageState();
}

class _InitHomepageState extends State<InitHomepage> {
  Future<void> _initOneSignalState() async {
    OneSignal.shared.setAppId(onesignalAppId);
    OneSignal.shared.setLogLevel(OSLogLevel.none, OSLogLevel.none);
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Accepted permissioon:$accepted");
    });
  }

  @override
  void initState() {
    SchedulerBinding.instance.endOfFrame.then((value) {
      Provider.of<ThemeProvider>(context, listen: false).init();
      fetchURL(context);
      _initOneSignalState();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<URL, ThemeProvider, Setting>(
        builder: (context, url, theme, sett, child) {
      if (url.getUrl() != null) {
        return Localizations.override(
            context: context,
            locale: sett.getLanguage(),
            child: Builder(builder: (context) {
              return FutureBuilder<int?>(
                  future: countUserFromDatabase(context),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.data != null) {
                      // if (snapshot.data! >= 1) {
                      return const HomeScreen();
                      // } else {
                      //   return const LoginPage();
                      // }
                    } else {
                      return _splashScreen(context);
                    }
                  });
            }));
      } else {
        return _splashScreen(context);
      }
    });
  }
}

Widget _splashScreen(BuildContext context) {
  return Scaffold(
    backgroundColor: theme(context).colorBackground,
    body: Center(
      child: SizedBox(
        width: mediaSize(context).width / 1.9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.asset(
            "assets/logo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
    bottomSheet: Container(
      color: theme(context).colorBackground,
      width: mediaSize(context).width,
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: InkWell(
              onTap: () async {
                Uri link = Uri.parse("https://dorandev.com/");
                await launchUrl(link);
              },
              child: SizedBox(
                width: mediaSize(context).width / 2.2,
                height: 140,
                child: Image.asset(
                  "assets/powered.png",
                  fit: BoxFit.scaleDown,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
