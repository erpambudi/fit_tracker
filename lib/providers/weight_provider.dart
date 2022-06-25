import 'package:fit_tracker/commons/constants.dart';
import 'package:fit_tracker/commons/state_enum.dart';
import 'package:fit_tracker/models/weight_model.dart';
import 'package:fit_tracker/services/weight_services.dart';
import 'package:flutter/material.dart';

class WeightProvider extends ChangeNotifier {
  final WeightServices weightServices;

  WeightProvider({required this.weightServices});

  List<WeightModel> _listWisata = [];
  List<WeightModel> get listWisata => _listWisata;

  RequestState _weightsState = RequestState.empty;
  RequestState get weightsState => _weightsState;

  RequestState _addWeightState = RequestState.empty;
  RequestState get addWeightState => _addWeightState;

  RequestState _updateWeightState = RequestState.empty;
  RequestState get updateWeightState => _updateWeightState;

  RequestState _removeWeightState = RequestState.empty;
  RequestState get removeWeightState => _removeWeightState;

  String _message = "";
  String get message => _message;

  Future<void> getAllWeights(String uid) async {
    try {
      _weightsState = RequestState.loading;
      notifyListeners();
      _listWisata = await weightServices.getAllWeight(uid);
      if (listWisata.isNotEmpty) {
        _weightsState = RequestState.hasData;
        notifyListeners();
      } else {
        _weightsState = RequestState.noData;
        _message = MessageConst.noData;
        notifyListeners();
      }
    } catch (e) {
      _weightsState = RequestState.error;
      notifyListeners();
      _message = MessageConst.error;
    }
  }

  Future<void> addWeight(WeightModel weight) async {
    try {
      _addWeightState = RequestState.loading;
      notifyListeners();
      weightServices.addWeight(weight);
      _addWeightState = RequestState.hasData;
      notifyListeners();
    } catch (e) {
      _addWeightState = RequestState.error;
      notifyListeners();
      _message = MessageConst.error;
    }
  }

  Future<void> removeWeight(String id) async {
    try {
      _removeWeightState = RequestState.loading;
      notifyListeners();
      weightServices.removeWeight(id);
      _removeWeightState = RequestState.hasData;
      notifyListeners();
    } catch (e) {
      _removeWeightState = RequestState.error;
      notifyListeners();
      _message = MessageConst.error;
    }
  }

  Future<void> updateWeight(String id, double weight) async {
    try {
      _updateWeightState = RequestState.loading;
      notifyListeners();
      weightServices.updateWeight(id, weight);
      _updateWeightState = RequestState.hasData;
      notifyListeners();
    } catch (e) {
      _updateWeightState = RequestState.error;
      notifyListeners();
      _message = MessageConst.error;
    }
  }
}
