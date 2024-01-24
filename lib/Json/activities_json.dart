import 'dart:convert';

ActivitiesJson accountsJsonFromMap(String str) => ActivitiesJson.fromMap(json.decode(str));

String accountsJsonToMap(ActivitiesJson data) => json.encode(data.toMap());

class ActivitiesJson {
  final int? accId;
  final int? accNumber;
  final int? trnId;
  final double? debit;
  final double? credit;
  final String? indFullName;
  ActivitiesJson({
    this.debit,
    this.credit,
    this.accId,
    this.accNumber,
    this.trnId,
    this.indFullName
  });

  factory ActivitiesJson.fromMap(Map<String, dynamic> json) => ActivitiesJson(
      accId: json["accId"],
      accNumber: json["accNumber"],
      trnId: json["trnId"],
      debit: json["totalDebit"],
      credit: json["totalCredit"],
      indFullName: json["indFullName"]
  );

  Map<String, dynamic> toMap() => {
    "accId": accId,
    "accNumber": accNumber,
    "trnId": trnId,
    "totalDebit":debit,
    "totalCredit":credit,
    "indFullName":indFullName

  };
}
