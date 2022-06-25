// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/colors.dart';
import '../commons/routes.dart';
import '../commons/state_enum.dart';
import '../providers/auth_provider.dart';
import '../providers/form_validator_provider.dart';
import '../widgets/custom_snackbar.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SignUpFormValidatorProvider formValidatorProvider(
            {required bool renderUI}) =>
        Provider.of<SignUpFormValidatorProvider>(context, listen: renderUI);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool hasNameValid = formValidatorProvider(renderUI: true).isValidName;
    bool hasEmailValid = formValidatorProvider(renderUI: true).isValidEmail;
    bool hasEightChars =
        formValidatorProvider(renderUI: true).isPasswordEightCharacters;
    bool hasOneNumber =
        formValidatorProvider(renderUI: true).hasPasswordOneNumber;
    bool hasSamePassword = formValidatorProvider(renderUI: true).isSamePassword;
    bool isVisiblePassword =
        formValidatorProvider(renderUI: true).isVisiblePassword;

    bool isValid = hasNameValid &&
        hasEmailValid &&
        hasEightChars &&
        hasOneNumber &&
        hasSamePassword;

    _onSignUp() async {
      String name = nameController.value.text;
      String email = emailController.value.text;
      String password1 = password1Controller.value.text;

      await authProvider.signUp(name, email, password1);

      if (authProvider.state == RequestState.loading) {
        debugPrint('lOADING...');
      } else if (authProvider.state == RequestState.hasData) {
        formValidatorProvider(renderUI: false).onReset();
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.profileSettingsPage, (Route<dynamic> route) => false);
      } else if (authProvider.state == RequestState.error) {
        MySnackbar.showSnackBar(context, authProvider.message);
      } else {
        MySnackbar.showSnackBar(context, authProvider.message);
      }
    }

    Widget _arrowBack() {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          formValidatorProvider(renderUI: false).onReset();
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(22, 32, 22, 20),
          child: Row(
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFEBEAEC),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: MyColor.blackColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _title() {
      return Column(
        children: const [
          Text(
            'Create Your Account',
            style: TextStyle(
              fontSize: 28,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'SIGN UP WITH EMAIL',
            style: TextStyle(
              fontSize: 15,
              color: MyColor.greyTextColor,
            ),
          ),
          SizedBox(height: 32),
        ],
      );
    }

    Widget validatorBox(
        {required Color boxColor,
        required Color borderColor,
        required String title}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 500,
              ),
              decoration: BoxDecoration(
                color: boxColor,
                border: Border.all(
                  color: borderColor,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: MyColor.greyTextColor,
              ),
            ),
          ],
        ),
      );
    }

    Widget _form() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              onChanged: (name) {
                formValidatorProvider(renderUI: false).onNameChanged(name);
              },
              style: const TextStyle(
                fontSize: 16,
                color: MyColor.blackColor,
              ),
              decoration: InputDecoration(
                hintText: 'Your name',
                suffixIcon: hasNameValid
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
              controller: password1Controller,
              obscureText: isVisiblePassword,
              onChanged: (password) {
                String password2 = password2Controller.value.text;
                formValidatorProvider(renderUI: false)
                    .onPasswordChanged(password, password2);
              },
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
            const SizedBox(height: 10),
            validatorBox(
              boxColor: hasEightChars ? Colors.green : Colors.transparent,
              borderColor:
                  hasEightChars ? Colors.transparent : Colors.grey.shade400,
              title: 'Contains 8 characters',
            ),
            const SizedBox(
              height: 6,
            ),
            validatorBox(
              boxColor: hasOneNumber ? Colors.green : Colors.transparent,
              borderColor:
                  hasOneNumber ? Colors.transparent : Colors.grey.shade400,
              title: 'Contains 1 number',
            ),
            const SizedBox(height: 20),
            TextField(
              controller: password2Controller,
              obscureText: isVisiblePassword,
              onChanged: (password) {
                String password1 = password1Controller.value.text;
                if (password1.isNotEmpty) {
                  formValidatorProvider(renderUI: false)
                      .onPasswordDifferent(password1, password);
                }
              },
              style: const TextStyle(
                fontSize: 16,
                color: MyColor.blackColor,
              ),
              decoration: InputDecoration(
                hintText: 'Confirm Password',
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
            const SizedBox(height: 10),
            validatorBox(
              boxColor: hasSamePassword ? Colors.green : Colors.transparent,
              borderColor:
                  hasSamePassword ? Colors.transparent : Colors.grey.shade400,
              title: 'Password Match',
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isValid
                    ? () {
                        _onSignUp();
                      }
                    : null,
                child: const Text('GET STARTED'),
              ),
            ),
            const SizedBox(height: 42),
          ],
        ),
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
                _arrowBack(),
                _title(),
                _form(),
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
