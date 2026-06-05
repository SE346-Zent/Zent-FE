import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:zent_fe/domain/usecases/inventory/get_inventory_usecases.dart';
import 'package:zent_fe/domain/usecases/inventory/zent_inventory_usecases.dart';
import '../../../common/core/safe_change_notifier.dart';

class DetailRequestViewModel extends ChangeNotifier with SafeChangeNotifier {
  final AcceptPartUseCase acceptPartUseCase;
  final DenyPartUseCase denyPartUseCase;
  final GetNewPartFormByIdUseCase getNewPartFormByIdUseCase;
  final GetScmLutsUseCase getScmLutsUseCase;

  DetailRequestViewModel({
    required this.acceptPartUseCase,
    required this.denyPartUseCase,
    required this.getNewPartFormByIdUseCase,
    required this.getScmLutsUseCase,
  });

  String? currentPartId;

  final partNameController = TextEditingController();
  final mtmController = TextEditingController();
  final serialNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  final List<String> categories = [
    'Control Board',
    'Display Panel',
    'Battery',
    'Motor',
    'Other',
  ];
  String selectedCategory = 'Other';

  final List<String> photoUrls = [];

  bool _isApproving = false;
  bool get isApproving => _isApproving;

  bool _isDenying = false;
  bool get isDenying => _isDenying;

  bool get isProcessing => _isApproving || _isDenying;

  /// Whether the part has been approved/rejected already (hide approve/reject buttons).
  bool _isApproved = false;
  bool get isApproved => _isApproved;

  bool get isReviewed => _status.toLowerCase() != 'pending';

  String _status = 'Pending';
  String get status => _status;

  String? _reviewedBy;
  String? get reviewedBy => _reviewedBy;

  String? _reviewedAtFormatted;
  String? get reviewedAtFormatted => _reviewedAtFormatted;

  String? _denialReason;
  String? get denialReason => _denialReason;

  /// Loading state for initial API fetch — avoid placeholder flash.
  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;

  void init(String partId) {
    currentPartId = partId;
    _loadPartDetail(partId);
  }

  Future<void> _loadPartDetail(String partId) async {
    _isLoadingDetail = true;
    notifyListeners();
    try {
      // 1. Load categories dynamically from SCM
      try {
        final luts = await getScmLutsUseCase.execute();
        final data = luts['data'] as Map<String, dynamic>?;
        if (data != null) {
          final partTypes = data['part_types'] as List<dynamic>?;
          if (partTypes != null) {
            categories.clear();
            for (final item in partTypes) {
              final name = item['PartTypeName'] as String?;
              if (name != null && name.isNotEmpty) {
                categories.add(name);
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Error loading SCM categories for detail: $e');
      }

      // 2. Load the part request
      final part = await getNewPartFormByIdUseCase.execute(partId);

      partNameController.text = part.partNumber;
      mtmController.text = part.modelCode ?? '';
      serialNumberController.text = part.serialNumber;
      descriptionController.text = part.description ?? '';

      // Bind category
      selectedCategory = part.partTypeName.isNotEmpty
          ? part.partTypeName
          : 'Other';
      if (!categories.contains(selectedCategory)) {
        categories.add(selectedCategory);
      }

      // Bind photos
      photoUrls.clear();
      if (part.photoUrls.isNotEmpty) {
        final ociBase = dotenv.get("OCI_STORAGE_URL", fallback: "");
        for (final url in part.photoUrls) {
          if (url.startsWith('http')) {
            photoUrls.add(url);
          } else {
            String cleanedUrl = url;
            if (cleanedUrl.startsWith('media/images/work-orders/')) {
              cleanedUrl = cleanedUrl.substring(
                'media/images/work-orders/'.length,
              );
            }
            if (cleanedUrl.startsWith('/')) {
              cleanedUrl = cleanedUrl.substring(1);
            }
            photoUrls.add('$ociBase$cleanedUrl');
          }
        }
      }

      // Bind status with proper capitalization
      _status = part.status.isNotEmpty
          ? (part.status[0].toUpperCase() +
                part.status.substring(1).toLowerCase())
          : 'Pending';

      // If status is not Pending, we treat it as already processed/approved
      _isApproved = _status.toLowerCase() != 'pending';

      // Bind review info
      _reviewedBy = part.reviewedBy;
      if (part.reviewedAt != null) {
        _reviewedAtFormatted = DateFormat(
          "HH'h'mm, dd/MM/yyyy",
        ).format(part.reviewedAt!);
      }
      _denialReason = part.denialReason;
    } catch (e) {
      debugPrint('Error loading part detail: $e');
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  void setCategory(String? newCategory) {
    if (newCategory != null) {
      selectedCategory = newCategory;
      notifyListeners();
    }
  }

  Future<bool> acceptPart() async {
    if (currentPartId == null) return false;
    _isApproving = true;
    notifyListeners();

    try {
      await acceptPartUseCase.execute(currentPartId!);
      return true;
    } catch (e) {
      debugPrint('Error accepting part: $e');
      return false;
    } finally {
      _isApproving = false;
      notifyListeners();
    }
  }

  Future<bool> denyPart(String reason) async {
    if (currentPartId == null) return false;
    _isDenying = true;
    notifyListeners();

    try {
      await denyPartUseCase.execute(currentPartId!, reason);
      return true;
    } catch (e) {
      debugPrint('Error denying part: $e');
      return false;
    } finally {
      _isDenying = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    partNameController.dispose();
    mtmController.dispose();
    serialNumberController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
