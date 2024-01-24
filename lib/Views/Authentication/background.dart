import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget? child;
  const Background({super.key,this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          height: 500,
          width: 450,
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 0,
                  color: Colors.grey,
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)
          ),
          child: child,
        ),
      ),
    );
  }
}
