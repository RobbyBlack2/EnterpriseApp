import 'package:enterpriseapp/core/constants/constants.dart';
import 'package:enterpriseapp/models/config.dart';
import 'package:enterpriseapp/providers/config.dart';
import 'package:enterpriseapp/providers/session.dart';
import 'package:enterpriseapp/providers/settings.dart';
import 'package:enterpriseapp/services/localstorage.dart';
import 'package:enterpriseapp/views/screens/closed.dart';
import 'package:enterpriseapp/views/screens/config.dart';
import 'package:enterpriseapp/views/screens/dob.dart';
import 'package:enterpriseapp/views/screens/email.dart';
import 'package:enterpriseapp/views/screens/fname.dart';
import 'package:enterpriseapp/views/screens/lname.dart';
import 'package:enterpriseapp/views/screens/phone.dart';
import 'package:enterpriseapp/views/screens/reason.dart';
import 'package:enterpriseapp/views/screens/start.dart';
import 'package:enterpriseapp/views/screens/submit.dart';
import 'package:enterpriseapp/views/screens/subreason.dart';

import 'package:enterpriseapp/views/screens/tq1.dart';
import 'package:enterpriseapp/views/screens/tq2.dart';
import 'package:enterpriseapp/views/screens/yn1.dart';
import 'package:enterpriseapp/views/screens/yn2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocalStorage localStorage = LocalStorage();
  Config? config = await localStorage.getConfig();
  int? seedColor = await localStorage.getSeedColor();
  seedColor ??= Colors.blue.toARGB32();
  // Declare and assign intRt correctly
  String intRt;
  if (config == null) {
    intRt = '/';
  } else {
    intRt = '/start';
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = ConfigProvider();
            if (config != null) {
              provider.setConfig(config);
            }
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: AppRoot(initialRoute: intRt, initialSeedColor: seedColor),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRoot extends StatefulWidget {
  final String initialRoute;
  final int initialSeedColor;
  const AppRoot({
    super.key,
    required this.initialRoute,
    required this.initialSeedColor,
  });

  @override
  State<AppRoot> createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  late int seedColor;

  @override
  void initState() {
    super.initState();
    seedColor = widget.initialSeedColor;
  }

  void updateSeedColor(int newColor) {
    setState(() {
      seedColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainApp(initialRoute: widget.initialRoute, seedColor: seedColor);
  }
}

class MainApp extends StatelessWidget {
  final String initialRoute;
  final int seedColor;

  const MainApp({
    super.key,
    required this.initialRoute,
    required this.seedColor,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1280, 800),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          title: Constants.appName,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Color(seedColor)),
            fontFamily: 'VarelaRound',
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  ColorScheme.fromSeed(seedColor: Color(seedColor)).primary,
                ),
                foregroundColor: WidgetStatePropertyAll(
                  ColorScheme.fromSeed(seedColor: Color(seedColor)).onPrimary,
                ),
                textStyle: WidgetStatePropertyAll(
                  const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          themeMode: ThemeMode.system,
          initialRoute: initialRoute,
          navigatorKey: navigatorKey,
          routes: {
            '/': (context) => ConfigScreen(),
            '/config': (context) => ConfigScreen(),
            '/closed': (context) => ClosedScreen(),
            '/start': (context) => StartScreen(),
            '/fname': (context) => FirstNameScreen(),
            '/lname': (context) => LastNameScreen(),
            '/dob': (context) => DobScreen(),
            '/email': (context) => EmailScreen(),
            '/phone': (context) => PhoneScreen(),
            '/tq1': (context) => TQ1Screen(),
            '/tq2': (context) => TQ2Screen(),
            '/yn1': (context) => YesNo1Screen(),
            '/yn2': (context) => YesNo2Screen(),
            '/reason': (context) => ReasonScreen(),
            '/subreason': (context) => SubReasonScreen(),
            '/submit': (context) => SubmitScreen(),
          },
        );
      },
    );
  }
}
