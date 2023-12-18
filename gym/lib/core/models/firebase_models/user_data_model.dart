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


  UserDataModel({
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
    required List<Map<String, dynamic>> subCollection,

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
        imageUrl: snapshot[Constants.kUserImageUrl]
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
      required this.className});

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
      customerNumber: snapshot['customer number']
    );
  }
}
