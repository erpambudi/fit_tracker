import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/colors.dart';
import '../commons/routes.dart';
import '../providers/auth_provider.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  startSplashScreen() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (auth.isLoggedIn == true) {
      Navigator.of(context).pushReplacementNamed(Routes.homePage);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.signInPage);
    }
  }

  @override
  void initState() {
    startSplashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.primaryColor,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            'assets/image_splashscreen.png',
            width: 250,
          ),
        ),
      ),
    );
  }
}
