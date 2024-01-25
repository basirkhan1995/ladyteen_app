import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:ladyteen_app/Components/Colors/colors.dart';
import 'package:ladyteen_app/Components/Methods/button.dart';
import 'package:ladyteen_app/Components/Methods/text_field.dart';
import 'package:ladyteen_app/Components/Methods/under_line_field.dart';
import 'package:ladyteen_app/Json/account_category_json.dart';
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
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    handler = DatabaseHelper();
    accounts = handler.getAccounts();
    handler.initDB().whenComplete(() {
      setState(() {
        accounts = getAllAccount();
        _controller = ScrollController();
      });
    });
    super.initState();
  }

  Future<List<AccountJson>> getAllAccount() async {
    return await handler.getAccounts();
  }

  Future<List<AccountJson>> searchAccount() async {
    return await handler.searchAccounts(searchController.text);
  }


  Future<void> _onRefresh() async {
    setState(() {
      searchController.text.isEmpty
          ? accounts = getAllAccount()
          : accounts = searchAccount();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  double totalDebit = 0;
  double totalCredit = 0;
  double? balance = 0;

  final name = TextEditingController();
  final cardNumber = TextEditingController();
  final cardName = TextEditingController();
  final holder = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPass = TextEditingController();
  final nationalId = TextEditingController();
  final jobTitle = TextEditingController();
  final searchController = TextEditingController();

  var category = "";

  int selectedId = 1;

  final formKey = GlobalKey<FormState>();
  final controller = DatabaseHelper();

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
                        onChanged: (value) {
                          setState(() {
                            accounts = searchAccount();
                          });
                        },
                        hint: "search_accounts",
                        icon: Icons.search,
                        controller: searchController,
                        trailing: searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    _onRefresh();
                                  });
                                },
                                icon: const Icon(Icons.clear, size: 18),
                              ))),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 180,
                        child: XButton(
                          label: "create_account",
                          onTap: () => addAccount(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const ListTile(
              horizontalTitleGap: 65,
              leading: LocaleText(
                "id",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              title: LocaleText("name",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: LocaleText("balance",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(
              color: primaryColor,
              endIndent: 10,
              indent: 10,
            ),
            Expanded(
              child: FutureBuilder<List<AccountJson>>(
                future: accounts,
                builder: (BuildContext context,
                    AsyncSnapshot<List<AccountJson>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          child: Image.asset("assets/photos/no_data.gif")),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <AccountJson>[];

                    return Scrollbar(
                      controller: _controller,

                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                            shrinkWrap: true,
                            controller: _controller,
                            scrollDirection: Axis.vertical,
                            itemCount: items.length,
                            itemBuilder: (context, index) {

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AccountDetails(
                                                account: items[index],
                                              )));
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: index % 2 == 1
                                        ? primaryColor.withOpacity(.05)
                                        : Colors.transparent,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          width: 50,
                                          child: Text(
                                            items[index].accNumber.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      const SizedBox(width: 30),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Hero(
                                          tag: items[index].accNumber ?? 0,
                                          child: CircleAvatar(
                                            radius: 23,
                                            child: Text(
                                              items[index].accName![0],
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              items[index].accName ?? "",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              items[index].categoryName ?? "",
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: items[index].balance == 0
                                              ? null
                                              : Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      Env.currencyFormat(
                                                          items[index].balance ??
                                                              0,
                                                          "en_US"),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
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
        ));
  }

  void addAccount() {
    bool isLogin = false;
    showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: formKey,
            child: SizedBox(
              width: 400,
              child: AlertDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 400),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: const ListTile(
                  title: LocaleText("create_account"),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        ZField(
                          title: "full_name",
                          icon: Icons.person,
                          controller: name,
                          isRequire: true,
                          validator: (value){
                            if(value.isEmpty){
                              return "name_required";
                            }
                            return null;
                      },
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            width: 160,
                            height: 40,
                            child: DropdownSearch<AccountCategoryJson>(
                              asyncItems: (value) => handler.getCategoryType(),
                              itemAsString: (AccountCategoryJson u) => Locales.string(context, u.categoryName.toString()),
                              onChanged: (AccountCategoryJson? data){
                                setState(() {
                                  selectedId = data!.cId!.toInt();
                                  isLogin = selectedId == 4? true : false;
                                });
                              },

                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal:6,vertical: 2),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: primaryColor,
                                            width: 1
                                        )
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                        gapPadding: 5,
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            width: 1,
                                            color: Colors.grey
                                        )
                                    ),

                                    labelText: Locales.string(context, "category")),
                              ),
                            ),
                          ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: ZField(
                            title: "phone",
                            icon: Icons.phone,
                            controller: phone,
                          )),
                          Expanded(
                              child: ZField(
                            title: "national_id",
                            icon: Icons.important_devices_rounded,
                            controller: nationalId,
                          )),
                        ],
                      ),
                       ZField(
                        title: "email",
                        icon: Icons.email,
                        controller: email,
                      ),
                       ZField(
                          controller: jobTitle,
                          title: "job_title",
                          icon: Icons.work,
                          ),
                      Row(
                        children: [
                          Expanded(
                              child: ZField(
                            title: "card_number",
                            icon: Icons.add_card,
                            controller: cardNumber,
                          )),
                          Expanded(
                              child: ZField(
                            title: "card_name",
                            icon: Icons.person,
                            controller: cardName,
                          )),
                        ],
                      ),

                     isLogin? Column(
                       children: [
                         ZField(
                           title: "username",
                           icon: Icons.account_circle_rounded,
                           controller: username,
                           validator: (value) {
                             if (value.isEmpty) {
                               return "username_required";
                             }
                             return null;
                           },
                           isRequire: true,
                         ),
                         ZField(
                           isRequire: true,
                           title: "password",
                           icon: Icons.lock,
                           controller: password,
                           validator: (value) {
                             if (value.isEmpty) {
                               return "password_required";
                             } else if (confirmPass.text != password.text) {
                               return "passwords_not_match";
                             }
                             return null;
                           },
                         ),
                         ZField(
                           isRequire: true,
                           title: "confirm_password",
                           icon: Icons.lock,
                           controller: confirmPass,
                           validator: (value) {
                             if (value.isEmpty) {
                               return "password_required";
                             } else if (confirmPass.text != password.text) {
                               return "passwords_not_match";
                             }
                             return null;
                           },
                         ),
                       ],
                     ): const SizedBox()

                    ],
                  ),
                ),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                          child: XButton(
                              label: "create_account",
                              onTap: () async{
                                if (formKey.currentState!.validate()) {
                                  var res = await controller.addNewAccount(
                                      name.text,
                                      nationalId.text,
                                      jobTitle.text,
                                      phone.text,
                                      email.text,
                                      cardNumber.text,
                                      cardName.text,
                                      username.text,
                                      password.text,
                                      selectedId);
                                  if(res>0){
                                    if(!mounted)return;
                                    Navigator.pop(context);
                                    _onRefresh();
                                  }
                                }
                              })),
                      Expanded(
                        flex: 2,
                          child: XButton(
                              label: "cancel",
                              onTap: () => Navigator.pop(context))),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
