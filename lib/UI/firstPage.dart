import "package:flutter/material.dart";

class Firstpage extends StatelessWidget {
  const Firstpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding:const EdgeInsets.only(top: 50.0),
        child: Text("Drive Pay",style: TextStyle(fontFamily: 'Modak',fontSize: 30.0),)
        )
      ],),
    );
  }
}

