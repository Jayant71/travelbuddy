import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelbuddy/data/models/delivery_request.dart';
import 'package:travelbuddy/data/sources/firebase_firestore_services.dart';
import 'package:travelbuddy/service_locator.dart';

part 'complete_requests_state.dart';

class CompleteRequestsCubit extends Cubit<CompleteRequestsState> {
  CompleteRequestsCubit() : super(CompleteRequestsInitial());

  void getCompleteRequests(String email) {
    emit(CompleteRequestsLoading());
    sl<FirebaseFirestoreServices>()
        .getCompleteRequests(email)
        .then((completedRequests) {
      emit(CompleteRequestsSuccess(completedRequests));
    }).catchError((e) {
      emit(CompleteRequestsFailed(e.toString()));
    });
  }
}
