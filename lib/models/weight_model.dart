class WeightModel {
  WeightModel({
    this.id,
    this.uid,
    this.weight,
    this.date,
  });

  String? id;
  String? uid;
  double? weight;
  DateTime? date;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'weight': weight,
      'date': date != null ? date!.millisecondsSinceEpoch : null,
    };
  }
}
