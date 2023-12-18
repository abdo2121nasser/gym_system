import 'package:flutter/material.dart';


class GeneralButtonBlock extends StatelessWidget {
final String lable;
final VoidCallback function;
final double width,hight,borderRadius;
final Color textColor,backgroundColor;

GeneralButtonBlock({required this.lable,
  required this.function, required this.width,
  required this.hight, required this.textColor,
  required this.backgroundColor, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: function,

        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
          ),
          backgroundColor: backgroundColor,
          fixedSize: Size(width, hight),
        ),
        child:Text(lable,
        style: TextStyle(fontSize: 20,color: textColor),));
  }
}
