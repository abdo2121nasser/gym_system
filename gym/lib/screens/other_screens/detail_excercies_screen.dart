import 'package:flutter/material.dart';

import '../../core/models/api_models/excercies_model.dart';




class DetailExcerciesScreen extends StatelessWidget {
   final Excercies excercie;

  const DetailExcerciesScreen({super.key, required this.excercie});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Expanded(
              child: Text(excercie.name!,
                style: const TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: const Icon(Icons.arrow_back,color: Colors.white,size: 30,),),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10,top: 10),
                width: double.maxFinite,height: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // image: DecorationImage(
                    //     image: Image.network(
                    //         excercie.gifUrl!,
                    //         loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    //           if (loadingProgress == null) {
                    //             return child;
                    //           } else {
                    //             return const Center(
                    //               child: CircularProgressIndicator(color: Colors.blue,),
                    //             );
                    //           }
                    //         }
                    //     ).image
                    // )
                ),
                child: Image.network(
                          excercie.gifUrl!,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(color: Colors.blue,),
                              );
                            }
                          }
                      ),
              ),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10),
               child: Column(
                 children: [
                   Row(
                     children: [
                       Expanded(
                         child: Text("BodyPart: ${excercie.bodyPart!}",
                           style: const TextStyle(fontSize: 30),),
                       ),
                     ],
                   ),
                   Row(
                     children: [
                       Expanded(
                         child: Text("Target: ${excercie.target!}",
                           style: const TextStyle(fontSize: 30),),
                       ),
                     ],
                   ),
                   Row(
                     children: [
                       Expanded(
                         child: Text("Equipment: ${excercie.equipment}",
                           style: const TextStyle(fontSize: 30),),
                       ),
                     ],
                   ),
                 ],
               ),
             ),
              const Center(
                child: Text("the Instructions",
                  style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
              ),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) => Text("${index+1}- ${excercie.instructions![index]}",
                    style: const TextStyle(fontSize: 25),),
                    separatorBuilder: (context, index) => const SizedBox(height: 10,),
                    itemCount: excercie.instructions!.length!),
              )
            ],
          ),
        ),
      ),
    );
  }
}
