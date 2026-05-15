import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import '../account/widgets/customer_app_bar.dart';
import 'viewmodels/request_service_viewmodel.dart';
import 'viewmodels/products_viewmodel.dart';
import 'request_service_discovery_screen.dart';
import 'request_service_info_screen.dart';
import 'request_service_contact_screen.dart';
import 'request_service_review_screen.dart';
import 'request_service_success_screen.dart';

class RequestServiceScreen extends StatefulWidget {
  const RequestServiceScreen({super.key});

  @override
  State<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  late RequestServiceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<RequestServiceViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _viewModel),
        ChangeNotifierProvider(
          create: (_) => sl<ProductsViewModel>()..fetchProducts(),
        ),
      ],
      child: const _RequestServiceView(),
    );
  }
}

class _RequestServiceView extends StatelessWidget {
  const _RequestServiceView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestServiceViewModel>();

    return PopScope(
      canPop: viewModel.currentStep <= 1,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (!didPop && viewModel.currentStep > 1) {
          viewModel.previousStep();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.background500,
          appBar: const CustomerAppBar(
            title: 'Request Services',
            showBackButton: true,
            showBottomDivider: true,
          ),
          body: SafeArea(
            child: IndexedStack(
              index: viewModel.currentStep - 1,
              children: const [
                RequestServiceDiscoveryScreen(),
                RequestServiceInfoScreen(),
                RequestServiceContactScreen(),
                RequestServiceReviewScreen(),
                RequestServiceSuccessScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
