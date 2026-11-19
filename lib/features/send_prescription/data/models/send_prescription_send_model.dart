import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class SendPrescriptionSendModel extends Equatable {
  final List<String> prescriptionImages;
  final List<List<int>>? prescriptionImagesBytes;
  final List<String>? prescriptionImagesNames;
  final int locationStrategy;
  final String? savedAddressId;
  final String? governorateId;
  final String? areaId;
  final List<String> pharmacyIds;
  final String? orderDetails;

  SendPrescriptionSendModel({
    List<String>? prescriptionImages,
    String? imagePath,
    List<String>? imagePaths,
    this.prescriptionImagesBytes,
    List<int>? imageBytes,
    this.prescriptionImagesNames,
    String? imageName,
    required this.locationStrategy,
    this.savedAddressId,
    this.governorateId,
    this.areaId,
    this.pharmacyIds = const [],
    this.orderDetails,
  })  : prescriptionImages = prescriptionImages ??
            imagePaths ??
            (imagePath != null && imagePath.isNotEmpty ? [imagePath] : const []),
        _legacyImageBytes = imageBytes,
        _legacyImageName = imageName;

  final List<int>? _legacyImageBytes;
  final String? _legacyImageName;

  String? get imagePath =>
      prescriptionImages.isNotEmpty ? prescriptionImages.first : null;
  List<String> get imagePaths => prescriptionImages;

  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.add(
      MapEntry('LocationStrategy', locationStrategy.toString()),
    );

    if (savedAddressId != null && savedAddressId!.trim().isNotEmpty) {
      formData.fields.add(MapEntry('SavedAddressId', savedAddressId!.trim()));
    }

    if (governorateId != null && governorateId!.trim().isNotEmpty) {
      formData.fields.add(MapEntry('GovernorateId', governorateId!.trim()));
    }

    if (areaId != null && areaId!.trim().isNotEmpty) {
      formData.fields.add(MapEntry('AreaId', areaId!.trim()));
    }

    if (orderDetails != null && orderDetails!.trim().isNotEmpty) {
      formData.fields.add(MapEntry('OrderDetails', orderDetails!.trim()));
    }

    for (final pharmacyId in pharmacyIds) {
      formData.fields.add(MapEntry('PharmacyIds', pharmacyId));
    }

    // PrescriptionImages array<string> / multipart files
    if (prescriptionImages.isNotEmpty) {
      for (int i = 0; i < prescriptionImages.length; i++) {
        final path = prescriptionImages[i];
        if (path.trim().isNotEmpty) {
          final name = (prescriptionImagesNames != null &&
                  prescriptionImagesNames!.length > i)
              ? prescriptionImagesNames![i]
              : path.split('/').last;
          formData.files.add(
            MapEntry(
              'PrescriptionImages',
              await MultipartFile.fromFile(
                path,
                filename: name,
              ),
            ),
          );
        }
      }
    } else if (prescriptionImagesBytes != null &&
        prescriptionImagesBytes!.isNotEmpty) {
      for (int i = 0; i < prescriptionImagesBytes!.length; i++) {
        final bytes = prescriptionImagesBytes![i];
        final name = (prescriptionImagesNames != null &&
                prescriptionImagesNames!.length > i)
            ? prescriptionImagesNames![i]
            : 'prescription_$i.jpg';
        formData.files.add(
          MapEntry(
            'PrescriptionImages',
            MultipartFile.fromBytes(
              bytes,
              filename: name,
            ),
          ),
        );
      }
    } else if (_legacyImageBytes != null && _legacyImageBytes.isNotEmpty) {
      final name = _legacyImageName ?? 'prescription.jpg';
      formData.files.add(
        MapEntry(
          'PrescriptionImages',
          MultipartFile.fromBytes(
            _legacyImageBytes,
            filename: name,
          ),
        ),
      );
    }

    return formData;
  }

  @override
  List<Object?> get props => [
        prescriptionImages,
        prescriptionImagesBytes,
        prescriptionImagesNames,
        locationStrategy,
        savedAddressId,
        governorateId,
        areaId,
        pharmacyIds,
        orderDetails,
      ];
}

