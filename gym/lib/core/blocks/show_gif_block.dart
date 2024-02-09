import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class ShowGifBlock extends StatelessWidget {
String gifUrl,name;

ShowGifBlock({required this.gifUrl,required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.maxFinite,height: 200,
      decoration: BoxDecoration(
        //color: Colors.red,
        border: Border.all(width: 3,color: Colors.teal.shade900),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10,top: 10),
           width: double.maxFinite,height: 140,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20),
           ),
            child:  Image.network(
                gifUrl,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress != null) {
                    // While the image is loading, show a CircularProgressIndicator
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    // Once the image is loaded, show the image
                    return child;
                  }
                },
              fit: BoxFit.contain,
            )
          ),
          Expanded(
            child: Center(
              child: Text(name,
              style: TextStyle(color: Colors.yellow.shade900,fontSize: 20,fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );
  }
}
