import 'dart:convert';

AccountCategoryJson accountsJsonFromMap(String str) => AccountCategoryJson.fromMap(json.decode(str));

String accountsJsonToMap(AccountCategoryJson data) => json.encode(data.toMap());

class AccountCategoryJson {
  final int? cId;
  final String? categoryName;
  AccountCategoryJson({
    this.cId,
    this.categoryName,
  });

  factory AccountCategoryJson.fromMap(Map<String, dynamic> json) => AccountCategoryJson(
      cId: json["accCategoryId"],
      categoryName: json["categoryName"],
  );

  Map<String, dynamic> toMap() => {
    "accCategoryId": cId,
    "accNumber": categoryName,
  };
}
