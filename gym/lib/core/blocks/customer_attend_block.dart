import 'package:flutter/material.dart';
import 'package:gym/core/constants/constants.dart';



class CustomerAttendBlock extends StatelessWidget {
  final String name;
  final String image;
  final bool isAttended;
  final bool isClassPassed;
  final VoidCallback absentFunction,attendedFunction;
  CustomerAttendBlock({
    required this.name,
    required this.image,
    required this.absentFunction,
    required this.attendedFunction,
    required this.isAttended,
    required this.isClassPassed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color:isAttended? Colors.green:Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
        image!=null|| image.isNotEmpty?
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 50,height: 50,
            decoration: BoxDecoration(
              border: Border.all(width: 2,color: Colors.white),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: Image.network(image).image
              )
            ),
          ):
          const CircularProgressIndicator(color: Colors.blue,),
         SizedBox(
           height: 40,
           width: 200,
           child: Row(
             children: [
               Expanded(
                   child: Text(name,
                   style: TextStyle(fontSize: 20),))
             ],
           ),
         ),
             !isClassPassed?
             isAttended?
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
            ),
            child: IconButton(onPressed:absentFunction,
                icon: Icon(Icons.close,color: Colors.red,)),
          ):
             Container(
               margin: EdgeInsets.symmetric(horizontal: 10),
               width: 40,
               decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: Colors.white
               ),
               child: IconButton(onPressed:attendedFunction,
                   icon: Icon(Icons.check,color: Colors.green,)),
             ):
             const SizedBox(),
        ],
      ),
    );
  }
}
