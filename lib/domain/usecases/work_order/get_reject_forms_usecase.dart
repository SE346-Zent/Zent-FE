import '../../repositories/work_order_repository.dart';
import '../../entities/reject_form.dart';
import '../auth/get_current_user_usecase.dart';

class GetRejectFormsUseCase {
  final WorkOrderRepository repository;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  GetRejectFormsUseCase({
    required this.repository,
    required this.getCurrentUserUseCase,
  });

  Future<List<RejectForm>> execute() async {
    // Fetch admin's province to filter reject forms by province
    String? province;
    try {
      final user = await getCurrentUserUseCase.execute();
      province = user?.province;
    } catch (_) {
      // Ignore - will fetch without province filter
    }

    final forms = await repository.getRejectForms(province: province);
    // Only show forms that are not yet approved/denied (pending review)
    return forms.where((f) => !f.approved).toList();
  }
}
