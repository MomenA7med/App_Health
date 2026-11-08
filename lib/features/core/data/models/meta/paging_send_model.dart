import 'package:equatable/equatable.dart';
import 'package:app_health/features/core/domain/entities/meta/paging_ui_model.dart';
import 'package:app_health/utils/extensions/extension_string.dart';

// ignore: must_be_immutable
class PagingListSendModel extends Equatable {
  int pageNumber;
  int pageSize;
  String searchText;

  PagingListSendModel({
    this.pageNumber = 0,
    this.pageSize = 10,
    this.searchText = "",
  });

  Map<String, dynamic> toJson() => {
    'pageSize': pageSize,
    'pageIndex': pageNumber,
    if (searchText.isNotNullOrNotEmpty) 'search': searchText,
  };

  factory PagingListSendModel.fromPagingListUiModel(
    PagingListUiModel uiModel,
  ) => PagingListSendModel(
    searchText: uiModel.searchText,
    pageNumber: uiModel.pageNumber,
    pageSize: uiModel.pageSize,
  );

  @override
  List<Object?> get props {
    return [pageNumber, pageSize, searchText];
  }
}
