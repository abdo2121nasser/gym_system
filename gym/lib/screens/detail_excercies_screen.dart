import 'package:flutter/material.dart';

import '../core/models/api_models/excercies_model.dart';




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
        },icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,),),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                    image: DecorationImage(
                        image: Image.network(
                            excercie.gifUrl!,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(color: Colors.blue,),
                                );
                              }
                            }
                        ).image
                    )
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
                           style: TextStyle(fontSize: 30),),
                       ),
                     ],
                   ),
                   Row(
                     children: [
                       Expanded(
                         child: Text("Target: ${excercie.target!}",
                           style: TextStyle(fontSize: 30),),
                       ),
                     ],
                   ),
                   Row(
                     children: [
                       Expanded(
                         child: Text("Equipment: ${excercie.equipment}",
                           style: TextStyle(fontSize: 30),),
                       ),
                     ],
                   ),
                 ],
               ),
             ),
              Center(
                child: Text("the Instructions",
                  style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
              ),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) => Text("${index+1}- ${excercie.instructions![index]}",
                    style: TextStyle(fontSize: 25),),
                    separatorBuilder: (context, index) => SizedBox(height: 10,),
                    itemCount: excercie.instructions!.length!),
              )
            ],
          ),
        ),
      ),
    );
  }
}
