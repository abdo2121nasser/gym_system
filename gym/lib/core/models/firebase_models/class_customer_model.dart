class ClassCustomerModel
{
  final String name;
  final bool attended;
  final String docId;
  final String imageUrl;

  ClassCustomerModel({
    required this.name,
    required this.attended,
    required this.docId,
  required this.imageUrl
  });
  factory ClassCustomerModel.fromJson({required Map<String,dynamic> json,required docId})
  {
    return ClassCustomerModel(
        name: json['user name'],
    attended: json['attended'],
     imageUrl: json['image url'] ,
      docId: docId
    );
  }
}