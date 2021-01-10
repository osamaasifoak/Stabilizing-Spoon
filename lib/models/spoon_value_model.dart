// To parse this JSON data, do
//
//     final spoonValues = spoonValuesFromMap(jsonString);

import 'dart:convert';

class SpoonValues {
    SpoonValues({
        this.x,
        this.y,
    });

    String x;
    String y;

    factory SpoonValues.fromJson(String str) => SpoonValues.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SpoonValues.fromMap(Map<String, dynamic> json) => SpoonValues(
        x: json["x"] == null ? null : json["x"].toString(),
        y: json["y"] == null ? null : json["y"].toString(),
    );

    Map<String, dynamic> toMap() => {
        "x": x == null ? null : x,
        "y": y == null ? null : y,
    };
}
