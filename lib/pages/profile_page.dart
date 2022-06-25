import 'package:fit_tracker/commons/state_enum.dart';
import 'package:fit_tracker/providers/auth_provider.dart';
import 'package:fit_tracker/utils/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _rowData(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          if (provider.detailProfileState == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 32, 16, 50),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: const Color(0xFFF2F2F2)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB7ABAB).withOpacity(0.15),
                        blurRadius: 8.0,
                        spreadRadius: 0.0,
                        offset: const Offset(
                          1.0,
                          1.0,
                        ),
                      )
                    ],
                  ),
                  child: provider.currentUser != null
                      ? Column(
                          children: [
                            _rowData("Name",
                                provider.currentUser!.displayName ?? "-"),
                            _rowData(
                                "Email", provider.currentUser!.email ?? "-"),
                            _rowData(
                                "Gender", provider.currentUser!.gender ?? "-"),
                            _rowData(
                                "Date of Birth",
                                provider.currentUser!.birthdate != null
                                    ? convertDateTimeMonth(
                                        provider.currentUser!.birthdate!)
                                    : "-"),
                            _rowData(
                                "Height",
                                provider.currentUser!.height != null
                                    ? provider.currentUser!.height.toString()
                                    : "-"),
                          ],
                        )
                      : const SizedBox(),
                ),
                provider.state == RequestState.loading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: ElevatedButton(
                          onPressed: () async {
                            await provider.signOut();
                            if (!mounted) return;
                            if (provider.state == RequestState.empty) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  Routes.signInPage,
                                  (Route<dynamic> route) => false);
                            }
                          },
                          child: const Text(
                            "LOGOUT",
                          ),
                        ),
                      ),
              ],
            );
          }
        },
      ),
    );
  }
}
