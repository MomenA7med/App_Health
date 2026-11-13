import 'package:equatable/equatable.dart';

class CreateAddressSendModel extends Equatable {
  final String addressName;
  final String governorate;
  final String area;
  final String detailedAddress;
  final bool isCurrentLocation;

  const CreateAddressSendModel({
    required this.addressName,
    required this.governorate,
    required this.area,
    required this.detailedAddress,
    this.isCurrentLocation = true,
  });

  Map<String, dynamic> toJson() => {
        'addressName': addressName,
        'governorate': governorate,
        'area': area,
        'detailedAddress': detailedAddress,
        'isCurrentLocation': isCurrentLocation,
      };

  @override
  List<Object?> get props => [
        addressName,
        governorate,
        area,
        detailedAddress,
        isCurrentLocation,
      ];
}

