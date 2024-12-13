import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:travelbuddy/data/models/user.dart';
import 'package:travelbuddy/data/sources/firebase_firestore_services.dart';
import 'package:travelbuddy/service_locator.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void getUser(String email) {
    emit(UserLoading());
    sl<FirebaseFirestoreServices>().getUser(email).then((user) {
      emit(UserSuccess(user!));
    }).catchError((e) {
      emit(UserFailed(e.toString()));
    });
  }
}
