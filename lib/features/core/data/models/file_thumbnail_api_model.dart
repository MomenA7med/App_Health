import 'package:equatable/equatable.dart';

class FileThumbnailApiModel extends Equatable {
  final String fileUrl;
  final String fileName;
  final String extension;
  final String uploadedFileName;

  const FileThumbnailApiModel({
    required this.fileUrl,
    required this.fileName,
    required this.extension,
    required this.uploadedFileName,
  });

  factory FileThumbnailApiModel.fromJson(Map<String, dynamic> json) =>
      FileThumbnailApiModel(
        fileUrl: json['fileUrl'] as String,
        fileName: json['fileName'] as String,
        extension: json['extension'] as String,
        uploadedFileName: json['uploadedFileName'] as String,
      );

  Map<String, dynamic> toJson() => {
    'fileUrl': fileUrl,
    'fileName': fileName,
    'extension': extension,
    'uploadedFileName': uploadedFileName,
  };

  @override
  List<Object> get props {
    return [fileUrl, fileName, extension, uploadedFileName];
  }
}
