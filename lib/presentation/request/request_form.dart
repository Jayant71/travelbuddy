import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelbuddy/data/models/delivery_request.dart';
import 'package:travelbuddy/data/sources/firebase_auth_services.dart';
import 'package:travelbuddy/data/sources/firebase_firestore_services.dart';
import 'package:travelbuddy/helpers/loading.dart';
import 'package:travelbuddy/presentation/landing/cubit/delivery_requests_dart_cubit.dart';
import 'package:travelbuddy/service_locator.dart';
import 'package:uuid/uuid.dart';

class DeliveryRequestForm extends StatefulWidget {
  const DeliveryRequestForm({super.key});

  @override
  DeliveryRequestFormState createState() => DeliveryRequestFormState();
}

class DeliveryRequestFormState extends State<DeliveryRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _pickupAddressController = TextEditingController();
  final _dropOffAddressController = TextEditingController();
  final _deliveryTimeFrameController = TextEditingController();
  final _rewardPointsController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newRequest = DeliveryRequest(
          id: const Uuid().v4(),
          itemName: _itemNameController.text.trim(),
          pickupAddress: _pickupAddressController.text.trim(),
          dropOffAddress: _dropOffAddressController.text.trim(),
          deliveryTimeFrame: _deliveryTimeFrameController.text.trim(),
          rewardPoints: int.parse(_rewardPointsController.text.trim()),
          createdBy: sl<FirebaseAuthServices>().currentUser!.email.toString(),
        );
        context.showLoadingDialog();
        final result = await sl<FirebaseFirestoreServices>()
            .addDeliveryRequest(deliveryRequest: newRequest);

        if (result == "Success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Delivery request created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating request: $result'),
              backgroundColor: Colors.red,
            ),
          );
        }

        _clearForm();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating request: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          context.hideLoadingDialog();
          context.read<DeliveryRequestsDartCubit>().getDeliveryRequests();
          Navigator.of(context).pop();
        }
      }
    }
  }

  void _clearForm() {
    _itemNameController.clear();
    _pickupAddressController.clear();
    _dropOffAddressController.clear();
    _deliveryTimeFrameController.clear();
    _rewardPointsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Delivery Request'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _itemNameController,
                        label: 'Item Name',
                        icon: Icons.shopping_bag,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter item name';
                          }
                          if (value!.length < 3) {
                            return 'Item name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _pickupAddressController,
                        label: 'Pickup Address',
                        icon: Icons.location_on,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter pickup address';
                          }
                          if (value!.length < 5) {
                            return 'Please enter a valid address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _dropOffAddressController,
                        label: 'Drop-off Address',
                        icon: Icons.location_off,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter drop-off address';
                          }
                          if (value!.length < 5) {
                            return 'Please enter a valid address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _deliveryTimeFrameController,
                        label: 'Delivery Time Frame',
                        icon: Icons.access_time,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter time frame';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _rewardPointsController,
                        label: 'Reward Points',
                        icon: Icons.stars,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter reward points';
                          }
                          final points = int.tryParse(value!);
                          if (points == null) {
                            return 'Please enter a valid number';
                          }
                          if (points < 1) {
                            return 'Reward points must be greater than 0';
                          }
                          if (points > 100) {
                            return 'Reward points cannot exceed 100';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await _submitForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _pickupAddressController.dispose();
    _dropOffAddressController.dispose();
    _deliveryTimeFrameController.dispose();
    _rewardPointsController.dispose();
    super.dispose();
  }
}
