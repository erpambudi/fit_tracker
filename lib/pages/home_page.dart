import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_tracker/commons/routes.dart';
import 'package:fit_tracker/commons/state_enum.dart';
import 'package:fit_tracker/models/weight_model.dart';
import 'package:fit_tracker/providers/weight_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../commons/colors.dart';
import '../providers/auth_provider.dart';
import '../utils/datetime_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? _currentUser;
  late WeightProvider _weightProvider;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      Future.microtask(() =>
          context.read<WeightProvider>().getAllWeights(_currentUser!.uid));
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _weightProvider = Provider.of<WeightProvider>(context);
    super.didChangeDependencies();
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 30),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<AuthProvider>(
                  builder: (context, provider, _) {
                    if (provider.currentUser != null) {
                      if (provider.currentUser!.displayName != null &&
                          provider.currentUser!.displayName != '') {
                        return Text(
                          'Hai ${provider.currentUser!.displayName}',
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      } else {
                        return Text(
                          'Hai ${provider.currentUser!.email}',
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    } else {
                      return const Text(
                        'Hai Guest',
                        style: TextStyle(
                          fontSize: 28,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                  },
                ),
                const Text(
                  'Let\'s measure your weight',
                  style: TextStyle(
                    fontSize: 18,
                    color: MyColor.greyTextColor,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false)
                  .getDetailProfile(_currentUser!.uid);
              Navigator.of(context).pushNamed(Routes.profilePage);
            },
            child: const SizedBox(
              height: 45,
              width: 45,
              child: CircleAvatar(
                backgroundColor: MyColor.primaryColor,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weightItem(WeightModel weight) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${weight.weight}",
                      style: const TextStyle(
                        color: MyColor.blackTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    const Text(
                      "Kg",
                      style: TextStyle(
                        color: MyColor.blackTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  convertDateTimeMonth(weight.date!),
                  style: const TextStyle(
                    fontSize: 12,
                    color: MyColor.greyTextColor,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(Routes.updateWeightPage, arguments: weight);
            },
            child: const Icon(
              Icons.edit,
              color: MyColor.primaryColor,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {
              _onRemove(weight.id!);
            },
            child: Icon(
              Icons.delete,
              color: Colors.red.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  void _showForm(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext contextDialog) {
        return AlertDialog(
          scrollable: true,
          content: Column(
            children: [
              const Center(
                child: Text(
                  "Today's weight",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyColor.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Divider(),
              const SizedBox(
                height: 6,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  controller: _weightController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Weight can\'t be empty.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter today\'s weight',
                  ),
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(contextDialog).pop();
                _weightController.clear();
              },
            ),
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(
                  color: MyColor.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                _onAdding(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _onAdding(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      final weightTotal = _weightController.text;
      final weightModel = WeightModel(
        uid: _currentUser!.uid,
        weight: double.parse(weightTotal),
        date: DateTime.now(),
      );

      await _weightProvider.addWeight(weightModel);

      if (_weightProvider.addWeightState == RequestState.hasData) {
        _weightProvider.getAllWeights(_currentUser!.uid);
      }
      _weightController.clear();
    }
  }

  void _onRemove(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Are you sure you want to remove item?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop();
                _weightProvider.removeWeight(id);
                _weightProvider.getAllWeights(_currentUser!.uid);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: _currentUser != null
                  ? Consumer<WeightProvider>(
                      builder: (context, provider, _) {
                        if (provider.weightsState == RequestState.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (provider.weightsState ==
                            RequestState.hasData) {
                          final weights = provider.listWisata;
                          return RefreshIndicator(
                            onRefresh: () async {
                              provider.getAllWeights(_currentUser!.uid);
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: weights.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    top: weights[i] == weights.first ? 8 : 0,
                                    bottom: weights[i] == weights.last ? 62 : 0,
                                  ),
                                  child: _weightItem(weights[i]),
                                );
                              },
                            ),
                          );
                        } else {
                          return RefreshIndicator(
                            onRefresh: () async {
                              provider.getAllWeights(_currentUser!.uid);
                            },
                            child: ListView(
                              children: [
                                Container(
                                  height: 200,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Center(
                                    child: Text(
                                      provider.message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: MyColor.greyTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )
                  : const Center(
                      child: Text(
                        'Please login first',
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context);
        },
        backgroundColor: MyColor.primaryColor,
        child: const Icon(
          Icons.post_add_sharp,
          color: Colors.white,
        ),
      ),
    );
  }
}
