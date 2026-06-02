class PaginationMeta {
  final int limit;
  final int page;
  final int totalPages;
  final int totalRows;

  PaginationMeta({
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.totalRows,
  });
}
