import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:ladyteen_app/Components/Colors/colors.dart';
import 'package:ladyteen_app/Components/Methods/button.dart';
import 'package:ladyteen_app/Components/Methods/text_field.dart';
import 'package:ladyteen_app/Components/Methods/under_line_field.dart';
import 'package:ladyteen_app/SQLite/database_helper.dart';
import 'package:ladyteen_app/Views/Accounts/account_details.dart';
import '../../../Components/Env/env.dart';
import '../../../Json/account_json.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  late DatabaseHelper handler;
  late Future<List<AccountJson>> accounts;

  @override
  void initState() {
     handler = DatabaseHelper();
     accounts = handler.getAccounts();
     handler.initDB().whenComplete((){
       setState(() {
         accounts = getAllAccount();
       });
     });
    super.initState();
  }

  Future<List<AccountJson>> getAllAccount()async{
    return await handler.getAccounts();
  }

  Future <List<AccountJson>> searchAccount()async{
    return await handler.searchAccounts(searchController.text);
  }

  Future<void> _onRefresh()async{
    setState(() {
      searchController.text.isEmpty? accounts = getAllAccount() : accounts = searchAccount();
    });
  }

  double totalDebit = 0;
  double totalCredit = 0;
  double? balance = 0;

  final holder = TextEditingController();
  final category = TextEditingController();
  final details = TextEditingController();
  final controller = DatabaseHelper();
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const LocaleText("accounts"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 340,
                  child: InputField(
                      onChanged: (value){
                        setState(() {
                          accounts = searchAccount();
                        });
                      },
                      hint: "search_accounts",
                      icon: Icons.search,
                      controller: searchController,
                      trailing: searchController.text.isEmpty? null : IconButton(
                        onPressed: (){
                          setState(() {
                            searchController.clear();
                            _onRefresh();
                          });
                        },
                        icon: const Icon(Icons.clear,size: 18),
                      ))),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 180,
                      child: XButton(
                        label: "create_account",
                        onTap: ()=>addAccount(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),

          const ListTile(
            horizontalTitleGap: 65,
            leading: LocaleText("id",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            title: LocaleText("name",style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: LocaleText("balance",style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          const Divider(
            color: primaryColor,
            endIndent: 10,
            indent: 10,
          ),

          Expanded(
            child: FutureBuilder<List<AccountJson>>(
              future: accounts, builder: (
                BuildContext context, AsyncSnapshot<List<AccountJson>> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }else if(snapshot.hasData && snapshot.data!.isEmpty){
                  return Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width *.2,
                        child: Image.asset("assets/photos/no_data.gif")),
                  );
                }else if(snapshot.hasError){
                  return Text(snapshot.error.toString());

                }else{
                  final items = snapshot.data ?? <AccountJson>[];

                  return Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context,index){

                            totalCredit = items[index].credit!.toDouble();
                            totalDebit = items[index].debit!.toDouble();
                            balance = totalCredit - totalDebit;

                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountDetails(account: items[index],)));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                decoration: BoxDecoration(
                                  color: index%2 ==1? primaryColor.withOpacity(.05) : Colors.transparent,
                                ),
                                child: Row(
                                  children: [

                                  Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 6),

                                      width: 50,
                                      child: Text(items[index].accNumber.toString(),style: const TextStyle(fontWeight: FontWeight.bold),)),

                                    const SizedBox(width: 30),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Hero(
                                        tag: items[index].accNumber??0,
                                        child: CircleAvatar(
                                          radius: 23,
                                          child: Text(items[index].accName![0],
                                            style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(items[index].accName??"",style: const TextStyle(fontWeight: FontWeight.bold),),
                                          Text(items[index].categoryName??"",style: const TextStyle(color: Colors.black54),),
                                        ],
                                      ),
                                    ),

                                      Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                        child: balance == 0? null : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [

                                            Text(Env.currencyFormat(balance?.toDouble()??0, "en_US"),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                      }),
                    ),
                  );
                }
            },

            ),
          ),
        ],
      )
    );
  }

  void addAccount(){
    showDialog(context: context, builder: (context){
      return SizedBox(
        height: double.infinity,
        child: AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 520,vertical: 0),
          title: const LocaleText("create_account"),

          content: const SingleChildScrollView(
            child: Column(
              children: [

                ZField(title: "full_name", icon: Icons.person,isRequire: true),

                Row(
                  children: [
                    Expanded(child: ZField(title: "phone", icon: Icons.phone)),
                    Expanded(child: ZField(title: "national_id", icon: Icons.important_devices_rounded)),
                  ],
                ),

                ZField(title: "email", icon: Icons.email),

                ZField(title: "job_title", icon: Icons.work,isRequire: true),
                Row(
                  children: [
                    Expanded(child: ZField(title: "card_number", icon: Icons.add_card)),
                    Expanded(child: ZField(title: "card_name", icon: Icons.person)),
                  ],
                ),

              ],
            ),
          ),
        ),
      );
    });
  }

}
