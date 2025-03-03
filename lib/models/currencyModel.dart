// ignore_for_file: file_names
import 'dart:convert';

List<CurrencyModel> currencyModelFromJson(String str) =>
    List<CurrencyModel>.from(
        json.decode(str).map((x) => CurrencyModel.fromJson(x)));

String currencyModelToJson(List<CurrencyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CurrencyModel {
  String id;
  String name;
  String amount;

  CurrencyModel({
    required this.id,
    required this.name,
    required this.amount,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        id: json["id"],
        name: json["name"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
      };
}
