class TrainingModel {
  String? message;
  List<TrainingModelData>? data;

  TrainingModel({this.message, this.data});

  factory TrainingModel.fromJson(Map<String, dynamic> json) => TrainingModel(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<TrainingModelData>.from(
            json["data"]!.map((x) => TrainingModelData.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TrainingModelData {
  int? id;
  String? title;

  TrainingModelData({this.id, this.title});

  factory TrainingModelData.fromJson(Map<String, dynamic> json) =>
      TrainingModelData(
        id: int.tryParse(json["id"].toString()),
        title: json["title"]?.toString(),
      );

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}
