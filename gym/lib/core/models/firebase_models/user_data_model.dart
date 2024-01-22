import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';

class UserDataModel {
  final String? name;
  final String? email;
  final String? address;
  final String? phone;
  final String? kind;
  final String? priority;
  final String? imageUrl;
  final String? docId;
  final String? password;
  final int? currentCredit;
  final int? packageSize;
  final Timestamp? startCreditDate;
  final Timestamp? endCreditDate;


  UserDataModel({
    required this.endCreditDate,
    required this.startCreditDate,
    required this.currentCredit,
    required this.packageSize,
    required this.password,
    required this.docId,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.kind,
    required this.priority,
    required this.imageUrl,
  });

  factory UserDataModel.fromJson({
    required Map<String, dynamic> snapshot,
    required String mainDocId,
     List<Map<String, dynamic>> subCollection=const [{}],

  }) {
    return UserDataModel(
        // bookingHistory: subCollection
        //     .map((subSnapshot) => BookingHistory.fromJson(snapshot: subSnapshot['data'],cSubDocId: subSnapshot['subDocId']))
        //     .toList(),
        password: snapshot['user password'],
        docId: mainDocId,
        name: snapshot['user name'],
        email: snapshot['email'],
        address: snapshot['address'],
        phone: snapshot['phone'],
        kind: snapshot['users kind'],
        priority: snapshot['user priority'],
        imageUrl: snapshot[Constants.kUserImageUrl],
      currentCredit: snapshot['current credit'],
      packageSize: snapshot['package size'],
      startCreditDate: snapshot['start credit date'],
      endCreditDate: snapshot['end credit date']
    );
  }
}

class BookingHistory {
  final String currentSubDocId;
  final String className;
  final String couchName;
  final String subDocId;
  final int startTimeHour;
  final int startTimeMinute;
  final int maxCustomerNumber;
  final int? customerNumber;
  final Timestamp startDate;
  final bool isAttended;

  BookingHistory(
      {
        required this.currentSubDocId,
        required this.subDocId,
        required this.couchName,
      required this.startTimeHour,
      required this.startTimeMinute,
        required this.maxCustomerNumber,
        required this.customerNumber,
      required this.startDate,
      required this.className,
        required this.isAttended
      });

  factory BookingHistory.fromJson({required Map<String, dynamic> snapshot,required String cSubDocId}) {
    return BookingHistory(
      currentSubDocId: cSubDocId,
      subDocId: snapshot['document id'],
        className: snapshot['class name'],
      couchName: snapshot['couch name'],
      startDate: snapshot['start date'],
      startTimeHour: snapshot['start time hour'],
      startTimeMinute: snapshot['start time minute'],
      maxCustomerNumber: snapshot['max customer number'],
      customerNumber: snapshot['customer number'],
      isAttended: snapshot['attended'],
    );
  }
}
