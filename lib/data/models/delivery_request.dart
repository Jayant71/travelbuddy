class DeliveryRequest {
  final String id;
  final String itemName;
  final String pickupAddress;
  final String dropOffAddress;
  final String deliveryTimeFrame;
  final int rewardPoints;
  String status = 'pending';
  String createdBy = '';
  String assignedTo = '';

  DeliveryRequest({
    required this.id,
    required this.itemName,
    required this.pickupAddress,
    required this.dropOffAddress,
    required this.deliveryTimeFrame,
    required this.rewardPoints,
    this.status = 'pending',
    this.createdBy = '',
    this.assignedTo = '',
  });

  factory DeliveryRequest.fromJson(Map<String, dynamic> map) {
    return DeliveryRequest(
      id: map['id'],
      itemName: map['itemName'],
      pickupAddress: map['pickupAddress'],
      dropOffAddress: map['dropOffAddress'],
      deliveryTimeFrame: map['deliveryTimeFrame'],
      rewardPoints: map['rewardPoints'],
      status: map['status'],
      createdBy: map['createdBy'],
      assignedTo: map['assignedTo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'pickupAddress': pickupAddress,
      'dropOffAddress': dropOffAddress,
      'deliveryTimeFrame': deliveryTimeFrame,
      'rewardPoints': rewardPoints,
      'status': status,
      'createdBy': createdBy,
      'assignedTo': assignedTo,
    };
  }
}
