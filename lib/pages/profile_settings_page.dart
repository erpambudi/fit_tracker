import 'package:fit_tracker/models/user_model.dart';
import 'package:fit_tracker/utils/datetime_helper.dart';
import 'package:fit_tracker/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../commons/colors.dart';
import '../commons/routes.dart';
import '../commons/state_enum.dart';
import '../providers/auth_provider.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  DateTime timeBackPressed = DateTime.now();
  final formKey = GlobalKey<FormState>();
  final heightController = TextEditingController();
  DateTime? selectedBirthday;

  final List<String> genders = ['Male', 'Female', 'Others'];
  String? selectedGender;

  Widget _title() {
    return Container(
      margin: const EdgeInsets.only(top: 52),
      child: Column(
        children: [
          const Text(
            'Complete your profile',
            style: TextStyle(
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 24),
          Consumer<AuthProvider>(
            builder: ((context, provider, _) {
              return Text(
                provider.currentUser!.displayName ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  color: MyColor.greyTextColor,
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _gender() {
    return Container(
      margin: const EdgeInsets.fromLTRB(22, 0, 22, 16),
      width: double.infinity,
      child: DropdownButton<String>(
        hint: const Text(
          "Select your gender",
          style: TextStyle(
            color: MyColor.greyTextColor,
          ),
        ),
        value: selectedGender,
        isExpanded: true,
        elevation: 8,
        underline: Container(
          height: 2,
          color: MyColor.primaryColor,
        ),
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue!;
          });
        },
        items: genders.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _birthDate() {
    return GestureDetector(
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: selectedBirthday ?? DateTime.now(),
          firstDate: DateTime(1800),
          lastDate: DateTime.now(),
        ).then((value) {
          if (value != null) {
            setState(() {
              selectedBirthday = value;
            });
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(22, 0, 22, 16),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFF2F3F7),
        ),
        child: Text(
          selectedBirthday != null
              ? convertDateTimeMonth(selectedBirthday!)
              : "Birth Date",
          style: TextStyle(
            fontSize: 16,
            color: selectedBirthday != null
                ? MyColor.blackTextColor.withOpacity(0.8)
                : MyColor.greyTextColor,
          ),
        ),
      ),
    );
  }

  Widget _heightBody() {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Form(
        key: formKey,
        child: TextFormField(
          controller: heightController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: const TextStyle(
            fontSize: 16,
            color: MyColor.blackColor,
          ),
          decoration: const InputDecoration(
            hintText: 'Your height',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Height can\'t be empty';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 42),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _onSubmit();
        },
        child: const Text('DONE'),
      ),
    );
  }

  void _onSubmit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (selectedGender != null) {
      if (selectedBirthday != null) {
        if (formKey.currentState!.validate()) {
          final user = UserModel(
            uid: authProvider.currentUser!.uid,
            gender: selectedGender,
            birthdate: selectedBirthday!,
            height: double.parse(heightController.text),
          );

          await authProvider.updateProfile(user);

          if (!mounted) return;
          if (authProvider.updateProfileState == RequestState.hasData) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.homePage, (Route<dynamic> route) => false);
          } else {
            MySnackbar.showSnackBar(context, authProvider.message);
          }
        }
      } else {
        MySnackbar.showSnackBar(context, "Choose birth date first");
      }
    } else {
      MySnackbar.showSnackBar(context, "Choose gender first");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          MySnackbar.showSnackBar(
              context, "Press once if you want to skip this step");

          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                _title(),
                _gender(),
                _birthDate(),
                _heightBody(),
                _submitButton(),
              ],
            ),
            Consumer<AuthProvider>(
              builder: (context, provider, _) {
                return provider.updateProfileState == RequestState.loading
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
