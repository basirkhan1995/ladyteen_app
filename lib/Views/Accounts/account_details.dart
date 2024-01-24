import 'package:flutter/material.dart';
import 'package:ladyteen_app/Json/account_json.dart';

class AccountDetails extends StatelessWidget {
  final AccountJson? account;
  const AccountDetails({super.key, this.account});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(account?.accName??""),
      ),

      body: Hero(
        tag: account?.accNumber??0,
        child: CircleAvatar(
          radius: 35,
          child: Text(account?.accName?[0]??""),
        ),
      ),
    );
  }
}
