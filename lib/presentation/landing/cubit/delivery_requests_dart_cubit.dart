import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:travelbuddy/data/models/delivery_request.dart';
import 'package:travelbuddy/data/sources/firebase_firestore_services.dart';
import 'package:travelbuddy/service_locator.dart';

part 'delivery_requests_dart_state.dart';

class DeliveryRequestsDartCubit extends Cubit<DeliveryRequestsDartState> {
  DeliveryRequestsDartCubit() : super(DeliveryRequestsDartInitial());

  void getDeliveryRequests() {
    emit(DeliveryRequestsDartLoading());
    sl<FirebaseFirestoreServices>()
        .getDeliveryRequests()
        .then((deliveryRequests) {
      emit(DeliveryRequestsDartSuccess(deliveryRequests));
    }).catchError((e) {
      emit(DeliveryRequestsDartFailed(e.toString()));
    });
  }
}
