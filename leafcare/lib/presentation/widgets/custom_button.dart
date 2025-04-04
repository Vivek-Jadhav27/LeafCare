import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final void Function() onPressed;
  final int currentPage;

  const CustomButton(
      {super.key, required this.onPressed, required this.currentPage});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  String get _buttonText {
   return widget.currentPage == 2 ? 'Get Started' : 'Next';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          margin:  EdgeInsets.only(top: 20),
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child:  Center(
            child: Text(
               _buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}
