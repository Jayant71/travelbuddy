import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travelbuddy/data/models/delivery_request.dart';
import 'package:travelbuddy/data/models/user.dart';
import 'package:travelbuddy/data/sources/firebase_auth_services.dart';
import 'package:travelbuddy/service_locator.dart';

class FirebaseFirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> createUser(User user) async {
    try {
      var uid = sl<FirebaseAuthServices>().currentUser!.uid;
      await _firestore.collection('users').doc(uid).set(user.toJson());
      return "Success";
    } catch (e) {
      debugPrint(e.toString());
      return 'Failed';
    }
  }

  Future<User?> getUser(String email) async {
    try {
      final user = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return user.docs.isNotEmpty
          ? User.fromJson(user.docs.first.data())
          : null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> updateUser({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection('users').doc(id).update(data);
      return "Success";
    } catch (e) {
      debugPrint(e.toString());
      return 'Failed';
    }
  }

  Future<String?> addDeliveryRequest({
    DeliveryRequest? deliveryRequest,
  }) async {
    try {
      await _firestore
          .collection('delivery_requests')
          .doc(deliveryRequest!.id)
          .set(deliveryRequest.toJson());
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<DeliveryRequest>> getDeliveryRequests() async {
    try {
      final deliveryRequests = await _firestore
          .collection('delivery_requests')
          .where(Filter.or(Filter('status', isEqualTo: "pending"),
              Filter('status', isEqualTo: "accepted")))
          .get();
      return deliveryRequests.docs
          .map((doc) => DeliveryRequest.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<String?> updateDeliveryRequest({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection('delivery_requests').doc(id).update(data);
      return "Success";
    } catch (e) {
      debugPrint(e.toString());
      return 'Failed';
    }
  }

  Future<List<DeliveryRequest>> getCompleteRequests(String email) async {
    try {
      final deliveryRequests = await _firestore
          .collection('delivery_requests')
          .where('status', isEqualTo: 'completed')
          .where(Filter.or(Filter('createdBy', isEqualTo: email),
              Filter('assignedTo', isEqualTo: email)))
          .get();
      return deliveryRequests.docs
          .map((doc) => DeliveryRequest.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
