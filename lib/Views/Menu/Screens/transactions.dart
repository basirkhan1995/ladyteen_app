import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:ladyteen_app/SQLite/database_helper.dart';

import '../../../Json/activities_json.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late DatabaseHelper handler;
  late Future<List<ActivitiesJson>> activities;
  final db = DatabaseHelper();
  @override
  void initState() {
    handler = db;
    activities = handler.getActivities();
    handler.initDB().whenComplete((){
      activities = getAllActivities();
    });
    super.initState();
  }

  Future<List<ActivitiesJson>> getAllActivities()async{
    return await handler.getActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocaleText("activities"),
      ),

      body: FutureBuilder(
        future: activities, builder: (BuildContext context, AsyncSnapshot<List<ActivitiesJson>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasData && snapshot.data!.isEmpty){
            return const Text("No activities found");
          }else if (snapshot.hasError){
            return Text(snapshot.error.toString());
          }else{
            final items = snapshot.data?? <ActivitiesJson>[];
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context,index){
              return  ListTile(
                leading: Text(items[index].accNumber.toString()),
                title: Text(items[index].credit.toString(), style: const TextStyle(color: Colors.green)),
                subtitle: Text(items[index].debit.toString(),style: const TextStyle(color: Colors.red)),
                trailing: Text(items[index].accNumber.toString()),
              );
            });
          }
      },

      ),
    );
  }
}
