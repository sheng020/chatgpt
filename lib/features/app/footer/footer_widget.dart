


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text("OpenAI © 2015–2022",style: TextStyle(fontSize: 18,),),
              Text(" Privacy Policy",style: TextStyle(fontSize: 18,),),
              Text(" Terms of Use",style: TextStyle(fontSize: 18,),),
            ],
          ),
          Row(
            children: [
              Icon(FontAwesomeIcons.twitter,size: 20),
              SizedBox(width: 30,),
              Icon(FontAwesomeIcons.youtube,size: 20,),
              SizedBox(width: 30,),
              Icon(FontAwesomeIcons.github,size: 20,),
              SizedBox(width: 30,),
              Icon(FontAwesomeIcons.facebookF,size: 20,),
              SizedBox(width: 30,),
              Icon(FontAwesomeIcons.linkedin,size: 20),
              SizedBox(width: 30,),
              Icon(FontAwesomeIcons.instagram,size: 20),
              SizedBox(width: 30,),
            ],
          )
        ],
      ),
    );
  }
}
