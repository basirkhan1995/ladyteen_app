import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:ladyteen_app/Components/Colors/colors.dart';
import 'package:ladyteen_app/Views/Menu/Components/menuDetails.dart';

class Start extends StatefulWidget {
  const Start({super.key});
  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  final controller = MenuItems();
  final pageController = PageController();

  bool selectedItem = false;
  bool isExpanded = true;
  int currentIndex = 0;

  double longWidth = 200;
  double shortWidth = 60;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Row(
        children: [
          menuList(),
          pageView(),
        ],
      ),
    );
  }
  
  Widget menuList(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      width: isExpanded? longWidth : shortWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.7)
          )
        ]
      ),
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 0,
                    color: Colors.grey.withOpacity(.6)
                  )
                ]
              ),
              child: Image.asset("assets/photos/ladyteen.png")),

          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.items.length,
                itemBuilder: (context,index){
                 selectedItem = currentIndex == index;
                  return Stack(
                    children: [
                     selectedItem? Container(
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        height: 45,
                        width: 5,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(4)
                        ),
                      ):const SizedBox(),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: selectedItem? primaryColor.withOpacity(.05) : Colors.transparent
                        ),
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          onTap: (){
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          
                          horizontalTitleGap: 10,
                          title: isExpanded? LocaleText(controller.items[index].title,
                            style: TextStyle(
                                fontSize: 14,
                                color: selectedItem ? primaryColor : Colors.black54,
                                fontWeight: selectedItem? FontWeight.bold : FontWeight.normal
                            ),
                          ) : const SizedBox(),
                          leading: Icon(controller.items[index].icon,color: selectedItem?primaryColor : Colors.black54,),
                        ),
                      ),
                    ],
                  );

            }),
          ),
        ],
      ),
    );
  }

  Widget pageView(){
    return Expanded(
      child: PageView.builder(
          onPageChanged: (index){
            setState(() {
              currentIndex = index;
            });
          },
          controller: pageController,
          itemCount: controller.items.length,
          itemBuilder: (context,index){
          return SizedBox(
            child: controller.items[currentIndex].page,
          );
      }),
    );
  }

  void addAccount(){
    showDialog(context: context, builder: (context){
      return const AlertDialog(
        title: LocaleText("created_account"),

      );
    });
  }
}
