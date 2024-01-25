import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qutub/screen/sign_up.dart';
import 'package:qutub/utils/colors.dart';
import 'package:qutub/widget/language.dart';

import 'screen/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(


        children: [
          Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Container(
              height: 72,
              width: 253,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/logo.svg"),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "Find Sport",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 36),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding:  EdgeInsets.only(top: screenHeight * 0.15),
            child: Column(
              children: [
                const ParentScreen(),
                const SizedBox(height: 15,),
                CircleAvatar(
                  radius: 20,
                    backgroundColor: colorBlack,
                    child: IconButton(onPressed: (){
                      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUPPage(),
                                    ),
                                  );
                    }, icon: const Icon(Icons.arrow_forward,size: 25,color: colorWhite,))

                )

              ],
            ),
          ),

        ],
      ),
    );
  }
}
