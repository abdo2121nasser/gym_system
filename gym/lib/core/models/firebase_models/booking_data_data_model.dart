import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym/core/models/firebase_models/user_data_model.dart';

class BookingClassesModel {
  final String? className;
  final String? couchName;
  final String? docId;
  final int? startTimeHour;
  final int? startTimeMinute;
  final int? maxCustomerNumber;
  final int? customerNumber;
  final Timestamp? startDate;

  BookingClassesModel(
      {required this.docId,
        required this.maxCustomerNumber,
        required this.customerNumber,
        required this.couchName,
        required this.startTimeHour,
        required this.startTimeMinute,
        required this.startDate,
        required this.className});

  factory BookingClassesModel.fromJson({required Map<String, dynamic> snapshot,required String documentId}) {
    return BookingClassesModel(
        docId: documentId,
        maxCustomerNumber: snapshot['max customer number'],
        customerNumber: snapshot['customer number'],
        className: snapshot['class name'],
        couchName: snapshot['couch name'],
        startDate: snapshot['start date'],
        startTimeHour: snapshot['start time hour'],
        startTimeMinute: snapshot['start time minute']
    );
  }
  factory BookingClassesModel.fromUserDataModel({
    required BookingHistory bookingHistory,
  }) {
    return BookingClassesModel(
        docId: bookingHistory.subDocId,
        maxCustomerNumber: bookingHistory.maxCustomerNumber,
        customerNumber: bookingHistory.customerNumber,
        className: bookingHistory.className,
        couchName: bookingHistory.couchName,
        startDate: bookingHistory.startDate,
        startTimeHour: bookingHistory.startTimeHour,
        startTimeMinute: bookingHistory.startTimeMinute
    );
  }

}