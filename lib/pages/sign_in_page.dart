// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/colors.dart';
import '../commons/routes.dart';
import '../commons/state_enum.dart';
import '../providers/auth_provider.dart';
import '../providers/form_validator_provider.dart';
import '../widgets/custom_snackbar.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SignInFormValidatorProvider formValidatorProvider(
            {required bool renderUI}) =>
        Provider.of<SignInFormValidatorProvider>(context, listen: renderUI);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool isValid = formValidatorProvider(renderUI: true).isValidEmail &&
        formValidatorProvider(renderUI: true).isNotEmptyPassword;

    bool hasEmailValid = formValidatorProvider(renderUI: true).isValidEmail;
    bool isVisiblePassword =
        formValidatorProvider(renderUI: true).isVisiblePassword;

    _onSignIn() async {
      String email = emailController.value.text;
      String password = passwordController.value.text;

      await authProvider.signIn(email, password);

      if (authProvider.state == RequestState.loading) {
        debugPrint('lOADING...');
      } else if (authProvider.state == RequestState.hasData) {
        formValidatorProvider(renderUI: false).onReset();
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.homePage, (Route<dynamic> route) => false);
      } else if (authProvider.state == RequestState.error) {
        MySnackbar.showSnackBar(context, authProvider.message);
      } else {
        MySnackbar.showSnackBar(context, authProvider.message);
      }
    }

    Widget _title() {
      return Column(
        children: const [
          SizedBox(height: 72),
          Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'LOGIN WITH EMAIL',
            style: TextStyle(
              fontSize: 15,
              color: MyColor.greyTextColor,
            ),
          ),
          SizedBox(height: 32),
        ],
      );
    }

    Widget _form() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              onChanged: (email) {
                formValidatorProvider(renderUI: false).onEmailChanged(email);
              },
              style: const TextStyle(
                fontSize: 16,
                color: MyColor.blackColor,
              ),
              decoration: InputDecoration(
                hintText: 'Email address',
                suffixIcon: hasEmailValid
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              onChanged: (password) {
                formValidatorProvider(renderUI: false)
                    .onPasswordChanged(password);
              },
              obscureText: isVisiblePassword,
              style: const TextStyle(
                fontSize: 16,
                color: MyColor.blackColor,
              ),
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisiblePassword ? Icons.visibility : Icons.visibility_off,
                    color: MyColor.blackColor,
                  ),
                  onPressed: () {
                    formValidatorProvider(renderUI: false)
                        .onChangeVisiblePassword();
                  },
                  splashColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isValid
                    ? () {
                        _onSignIn();
                      }
                    : null,
                child: const Text('LOG IN'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    Widget _signUpTitle() {
      return Column(
        children: [
          const Text(
            'Don\'t have an account?',
            style: TextStyle(
              fontSize: 15,
              color: MyColor.greyTextColor,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Routes.signUpPage);
            },
            child: const Text(
              'SIGN UP',
              style: TextStyle(
                fontSize: 15,
                color: MyColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      );
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          await formValidatorProvider(renderUI: false).onReset();
          return true;
        },
        child: Stack(
          children: [
            ListView(
              children: [
                _title(),
                _form(),
                _signUpTitle(),
              ],
            ),
            Consumer<AuthProvider>(
              builder: (context, provider, _) {
                return authProvider.state == RequestState.loading
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
