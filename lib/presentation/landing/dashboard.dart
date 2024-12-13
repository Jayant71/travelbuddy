import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelbuddy/data/models/user.dart';
import 'package:travelbuddy/data/sources/firebase_auth_services.dart';
import 'package:travelbuddy/data/sources/firebase_firestore_services.dart';
import 'package:travelbuddy/helpers/loading.dart';
import 'package:travelbuddy/presentation/auth/cubit/user_cubit.dart';
import 'package:travelbuddy/presentation/auth/login.dart';
import 'package:travelbuddy/presentation/landing/cubit/complete_requests_cubit.dart';
import 'package:travelbuddy/presentation/request/request_form.dart';
import 'package:travelbuddy/presentation/landing/cubit/delivery_requests_dart_cubit.dart';
import 'package:travelbuddy/presentation/profile/profile_page.dart';
import 'package:travelbuddy/presentation/widgets/delivery_card.dart';
import 'package:travelbuddy/service_locator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    context.read<DeliveryRequestsDartCubit>().getDeliveryRequests();
    context
        .read<CompleteRequestsCubit>()
        .getCompleteRequests(sl<FirebaseAuthServices>().currentUser!.email!);
    context
        .read<UserCubit>()
        .getUser(sl<FirebaseAuthServices>().currentUser!.email!);
  }

  Future<void> onRefreshPending() async {
    context.read<DeliveryRequestsDartCubit>().getDeliveryRequests();
  }

  Future<void> onRefreshCompleted() async {
    context
        .read<CompleteRequestsCubit>()
        .getCompleteRequests(sl<FirebaseAuthServices>().currentUser!.email!);
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _selectedIndex == 0 ? 'Delivery requests' : 'Completed Requests'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ProfilePage();
                }));
              },
              icon: const Icon(Icons.person)),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              context.showLoadingDialog();
              await sl<FirebaseAuthServices>().signOut();
              if (context.mounted) {
                context.hideLoadingDialog();

                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: 'Completed',
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: [
        RefreshIndicator(
            onRefresh: onRefreshPending,
            child: BlocBuilder<DeliveryRequestsDartCubit,
                DeliveryRequestsDartState>(
              builder: (context, state) {
                if (state is DeliveryRequestsDartLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DeliveryRequestsDartSuccess) {
                  if (state.deliveryRequests.isEmpty) {
                    return const Center(
                      child: Text(
                        'No delivery requests available at the moment',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.deliveryRequests.length,
                    itemBuilder: (context, index) {
                      final deliveryRequest = state.deliveryRequests[index];
                      return DeliveryCard(delivery: deliveryRequest);
                    },
                  );
                } else if (state is DeliveryRequestsDartFailed) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                return const SizedBox();
              },
            )),
        RefreshIndicator(
            onRefresh: onRefreshCompleted,
            child: BlocBuilder<CompleteRequestsCubit, CompleteRequestsState>(
              builder: (context, state) {
                if (state is CompleteRequestsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CompleteRequestsSuccess) {
                  if (state.completeRequests.isEmpty) {
                    return const Center(
                      child: Text(
                        'No completed delivery requests found.',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.completeRequests.length,
                    itemBuilder: (context, index) {
                      final deliveryRequest = state.completeRequests[index];
                      return DeliveryCard(delivery: deliveryRequest);
                    },
                  );
                } else if (state is CompleteRequestsFailed) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                return const SizedBox();
              },
            )),
      ]),
      floatingActionButton: IconButton.filled(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const DeliveryRequestForm();
          }));
        },
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('Request Delivery',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
