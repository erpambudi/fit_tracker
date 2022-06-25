import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_tracker/commons/theme.dart';
import 'package:fit_tracker/models/weight_model.dart';
import 'package:fit_tracker/pages/home_page.dart';
import 'package:fit_tracker/pages/profile_page.dart';
import 'package:fit_tracker/pages/profile_settings_page.dart';
import 'package:fit_tracker/pages/sign_in_page.dart';
import 'package:fit_tracker/pages/sign_up_page.dart';
import 'package:fit_tracker/pages/splashscreen_page.dart';
import 'package:fit_tracker/pages/update_weight_page.dart';
import 'package:fit_tracker/providers/auth_provider.dart';
import 'package:fit_tracker/providers/form_validator_provider.dart';
import 'package:fit_tracker/services/weight_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'commons/colors.dart';
import 'commons/routes.dart';
import 'providers/weight_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: MyColor.primaryColor,
    statusBarBrightness: Brightness.light,
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpFormValidatorProvider()),
        ChangeNotifierProvider(create: (_) => SignInFormValidatorProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..statusLogin()),
        ChangeNotifierProvider(
            create: (_) => WeightProvider(weightServices: WeightServices())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fit Tracker',
        theme: MyTheme.light(),
        initialRoute: Routes.splashPage,
        routes: {
          Routes.splashPage: (context) => const SplashScreenPage(),
          Routes.signUpPage: (context) => SignUpPage(),
          Routes.signInPage: (context) => SignInPage(),
          Routes.homePage: (context) => const HomePage(),
          Routes.updateWeightPage: (context) => UpdateWeightPage(
              weightModel:
                  ModalRoute.of(context)?.settings.arguments as WeightModel),
          Routes.profileSettingsPage: (context) => const ProfileSettingsPage(),
          Routes.profilePage: (context) => const ProfilePage(),
        },
      ),
    );
  }
}
