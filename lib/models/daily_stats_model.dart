// To parse this JSON data, do
//
//     final DailyStatsModel = DailyStatsModelFromMap(jsonString);

import 'dart:convert';

class DailyStatsModel {
  DailyStatsModel(
      {this.x, this.y, this.date, this.month, this.dateTime, this.year});

  String x;
  String y;
  String month;
  String year;
  String date;
  String dateTime;

  factory DailyStatsModel.fromJson(String str) =>
      DailyStatsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailyStatsModel.fromMap(Map<String, dynamic> json) => DailyStatsModel(
        x: json["x"] == null ? null : json["x"].toString(),
        y: json["y"] == null ? null : json["y"].toString(),
        month: json["month"] == null ? null : json["month"].toString(),
        year: json["year"] == null ? null : json["year"].toString(),
        date: json["date"] == null ? null : json["date"].toString(),
        dateTime: json["dateTime"] == null ? null : json["dateTime"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "x": x == null ? null : x,
        "y": y == null ? null : y,
      };
}
