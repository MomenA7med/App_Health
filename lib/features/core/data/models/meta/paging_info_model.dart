class PagingInfoModel {
  final int totalItems;
  final int currentLoadedItems;

  PagingInfoModel(this.totalItems, this.currentLoadedItems);

  bool get hasNext => totalItems > currentLoadedItems;

  bool get hasPrevious => currentLoadedItems > 0;

  static PagingInfoModel getEmptyOne() {
    return PagingInfoModel(0, 0);
  }
}
