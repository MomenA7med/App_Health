import 'package:equatable/equatable.dart';

class PagingListUiModel extends Equatable {
  final int pageNumber;
  final int pageSize;
  final String searchText;

  const PagingListUiModel({
    this.pageNumber = 0,
    this.pageSize = 15,
    this.searchText = "",
  });

  @override
  List<Object?> get props {
    return [pageNumber, pageSize, searchText];
  }
}
