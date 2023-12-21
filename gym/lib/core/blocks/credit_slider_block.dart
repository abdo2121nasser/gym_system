import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';



class CreditIndicatorBlock extends StatelessWidget {
 final double percent;


 CreditIndicatorBlock({required this.percent});

  @override
  Widget build(BuildContext context) {
    return  LinearPercentIndicator(
padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
    barRadius: const Radius.circular(5),
      lineHeight: 14.0,
      percent: percent,
      backgroundColor: Colors.teal.shade400,
      progressColor: Colors.yellow.shade400,
    );
  }
}
