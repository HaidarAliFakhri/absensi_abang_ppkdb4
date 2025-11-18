class BatchModel {
  String? message;
  List<BatchModelData>? data;

  BatchModel({this.message, this.data});

  factory BatchModel.fromJson(Map<String, dynamic> json) => BatchModel(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<BatchModelData>.from(
            json["data"]!.map((x) => BatchModelData.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BatchModelData {
  int? id;
  String? batchKe;
  DateTime? startDate;
  DateTime? endDate;
  String? createdAt;
  String? updatedAt;
  List<Training>? trainings;

  BatchModelData({
    this.id,
    this.batchKe,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.trainings,
  });

  factory BatchModelData.fromJson(Map<String, dynamic> json) => BatchModelData(
    id: int.tryParse(json["id"].toString()),
    batchKe: json["batch_ke"]?.toString(),
    startDate: json["start_date"] != null
        ? DateTime.tryParse(json["start_date"])
        : null,
    endDate: json["end_date"] != null
        ? DateTime.tryParse(json["end_date"])
        : null,
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    trainings: json["trainings"] == null
        ? []
        : List<Training>.from(
            json["trainings"]!.map((x) => Training.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "batch_ke": batchKe,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "created_at": createdAt,
    "updated_at": updatedAt,
    "trainings": trainings == null
        ? []
        : List<dynamic>.from(trainings!.map((x) => x.toJson())),
  };
}

class Training {
  int? id;
  String? title;
  Pivot? pivot;

  Training({this.id, this.title, this.pivot});

  factory Training.fromJson(Map<String, dynamic> json) => Training(
    id: int.tryParse(json["id"].toString()),
    title: json["title"]?.toString(),
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "pivot": pivot?.toJson(),
  };
}

class Pivot {
  String? trainingBatchId;
  String? trainingId;

  Pivot({this.trainingBatchId, this.trainingId});

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    trainingBatchId: json["training_batch_id"]?.toString(),
    trainingId: json["training_id"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "training_batch_id": trainingBatchId,
    "training_id": trainingId,
  };
}
