import 'dart:convert';

AccountJson accountsJsonFromMap(String str) => AccountJson.fromMap(json.decode(str));

String accountsJsonToMap(AccountJson data) => json.encode(data.toMap());

class AccountJson {
  final int? accId;
  final int? accNumber;
  final String? accName;
  final String? accDescription;
  final String? accCreatedAt;
  final String? accUpdatedAt;

  final String? categoryName;

  final int? indId;
  final String? indName;
  final String? indEmail;
  final String? indPhone;
  final String? nationalId;
  final String? jobTitle;
  final String? indCardNumber;
  final String? indCardName;

  final int? trnId;
  final String? trnCreatedAt;
  final String? trnUpdatedAt;
  final double? debit;
  final double? credit;

  AccountJson({

    this.accId,
    this.accNumber,
    this.accName,
    this.accDescription,
    this.accCreatedAt,
    this.accUpdatedAt,

    this.categoryName,

    this.indId,
    this.indEmail,
    this.indPhone,
    this.indName,
    this.nationalId,
    this.jobTitle,
    this.indCardNumber,
    this.indCardName,

    this.trnId,
    this.trnCreatedAt,
    this.trnUpdatedAt,
    this.debit,
    this.credit,


  });

  factory AccountJson.fromMap(Map<String, dynamic> json) => AccountJson(
      accId: json["accId"],
      accName: json["accName"],
      accNumber: json["accNumber"],
      accDescription: json["accDescription"],
      accCreatedAt: json["accCreatedAt"],
      accUpdatedAt: json["accUpdatedAt"],

      trnId: json["trnId"],
      debit: json["totalDebit"],
      credit: json["totalCredit"],
      trnCreatedAt: json["trnCreatedAt"],
      trnUpdatedAt: json["trnUpdatedAt"],

      indId: json["indId"],
      indName: json["indFullName"],
      nationalId: json["nationalId"],
      indEmail: json["indEmail"],
      indPhone: json["indPhone"],
      jobTitle: json["jobTitle"],
      indCardNumber: json["indCardNumber"],
      indCardName: json["indCardName"],

      categoryName: json["categoryName"]

  );

  Map<String, dynamic> toMap() => {
    "accId": accId,
    "accNumber": accNumber,
    "accName": accName,
    "trnId": trnId,
    "totalDebit":debit,
    "totalCredit":credit,
    "indFullName":indName,
    "nationalId":nationalId,
  };
}
