import 'package:fit_tracker/commons/colors.dart';
import 'package:fit_tracker/commons/state_enum.dart';
import 'package:fit_tracker/models/weight_model.dart';
import 'package:fit_tracker/providers/weight_provider.dart';
import 'package:fit_tracker/utils/datetime_helper.dart';
import 'package:fit_tracker/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class UpdateWeightPage extends StatefulWidget {
  final WeightModel weightModel;
  const UpdateWeightPage({Key? key, required this.weightModel})
      : super(key: key);

  @override
  State<UpdateWeightPage> createState() => _UpdateWeightPageState();
}

class _UpdateWeightPageState extends State<UpdateWeightPage> {
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AuthProvider _authProvider;

  @override
  void initState() {
    _weightController.text = widget.weightModel.weight.toString();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _authProvider = Provider.of<AuthProvider>(context);
    super.didChangeDependencies();
  }

  void _onUpdate() async {
    final weightProvider = Provider.of<WeightProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);

      await weightProvider.updateWeight(widget.weightModel.id!, weight);

      if (!mounted) return;
      if (weightProvider.updateWeightState == RequestState.hasData) {
        Navigator.of(context).pop();
        weightProvider.getAllWeights(_authProvider.currentUser!.uid!);
      } else {
        MySnackbar.showSnackBar(context, weightProvider.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Weight'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 32, 20, 24),
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
            child: Text(
              convertDateTimeMonth(widget.weightModel.date!),
              style: const TextStyle(
                color: MyColor.blackTextColor,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 52),
            child: Form(
              key: _formKey,
              child: TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                controller: _weightController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Weight can\'t be empty.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter weight',
                ),
              ),
            ),
          ),
          Consumer<WeightProvider>(
            builder: (context, provider, _) {
              if (provider.updateWeightState == RequestState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: ElevatedButton(
                    onPressed: _onUpdate,
                    child: const Text("UPDATE"),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
