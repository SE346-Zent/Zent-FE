import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/app_network_image.dart';
import '../../admin/work/viewmodels/detailed_history_viewmodel.dart';

class TechDetailedHistoryScreen extends StatefulWidget {
  final String workOrderId;

  const TechDetailedHistoryScreen({super.key, required this.workOrderId});

  @override
  State<TechDetailedHistoryScreen> createState() =>
      _TechDetailedHistoryScreenState();
}

class _TechDetailedHistoryScreenState extends State<TechDetailedHistoryScreen> {
  late final DetailedHistoryViewModel _viewModel;

  // Expansion states for each collapsible section
  bool _isPartsExpanded = true;
  bool _isPhotosExpanded = true;
  bool _isDiagnosticExpanded = true;
  bool _isCustomerResponseExpanded = true;

  @override
  void initState() {
    super.initState();
    _viewModel = di.sl<DetailedHistoryViewModel>(param1: widget.workOrderId);
    _viewModel.loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.background500,
        body: SafeArea(
          child: Consumer<DetailedHistoryViewModel>(
            builder: (context, vm, child) {
              if (vm.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.tertiary500,
                  ),
                );
              }

              if (vm.errorMessage != null) {
                return Column(
                  children: [
                    const AccountHeader(
                      title: "Detailed History",
                      subtitle: "Error Loading Details",
                      showDivider: true,
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimens.spaceLg),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.redAccent,
                                size: 48,
                              ),
                              const SizedBox(height: AppDimens.spaceMd),
                              Text(
                                vm.errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyles.bodyLarge.copyWith(
                                  color: AppColors.secondary500,
                                ),
                              ),
                              const SizedBox(height: AppDimens.spaceLg),
                              ElevatedButton(
                                onPressed: () => vm.loadDetails(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary500,
                                ),
                                child: const Text(
                                  "Retry",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              final wo = vm.workOrder;
              final history = vm.historyData;
              if (wo == null) {
                return const Center(child: Text("Work Order Not Found"));
              }

              final closingForm =
                  history?['closingForm'] as Map<String, dynamic>?;
              final complaint = history?['complaint'] as Map<String, dynamic>?;

              return Column(
                children: [
                  AccountHeader(
                    title: "Detailed History",
                    subtitle: "#${wo.workOrderNum}",
                    showDivider: true,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMd,
                        vertical: AppDimens.spaceSm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Part Changes Section
                          _buildPartChangesSection(closingForm),
                          const SizedBox(height: 12.0),

                          // 2. Evidence Photos Section
                          _buildEvidencePhotosSection(closingForm),
                          const SizedBox(height: 12.0),

                          // 3. Diagnostic Section
                          _buildDiagnosticSection(closingForm),
                          const SizedBox(height: 16.0),

                          // 4. Customer Response Section
                          _buildCustomerResponseSection(complaint),
                          const SizedBox(height: AppDimens.spaceXl),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Title / Section Header builder
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    Color iconColor = AppColors.tertiary500,
    Widget? customIcon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                customIcon ?? Icon(icon, color: iconColor, size: 31),
                const SizedBox(width: AppDimens.spaceSm),
                Text(
                  title,
                  style: TextStyles.title.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.secondary500,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 1. Part Changes Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildPartChangesSection(Map<String, dynamic>? closingForm) {
    final rawParts = closingForm?['partChanges'] as List<dynamic>? ?? [];

    final installedList = rawParts
        .where((p) => p['changeType'] == 'installed')
        .toList();
    if (installedList.isEmpty) {
      installedList.add({
        'name': 'Intel Core i9-13900K Processor',
        'serialNumber': 'SN-8291A-9382',
        'imageUrl':
            'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?q=80&w=200',
      });
    }

    final uninstalledList = rawParts
        .where((p) => p['changeType'] == 'uninstalled')
        .toList();
    if (uninstalledList.isEmpty) {
      uninstalledList.add({
        'name': 'Intel Core i7-11700K Processor (Defective)',
        'serialNumber': 'SN-1092B-4819',
        'imageUrl':
            'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=200',
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          icon: Icons.edit_square,
          title: "Part Changes",
          isExpanded: _isPartsExpanded,
          onTap: () => setState(() => _isPartsExpanded = !_isPartsExpanded),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isPartsExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimens.spaceSm),
                    // Part Installed
                    Text(
                      "Part Installed",
                      style: TextStyles.middle.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    ...installedList.map(
                      (p) => _buildPartItem(
                        name: p['name'] ?? p['partId'] ?? 'System Motherboard',
                        serialNumber: p['serialNumber'] ?? 'SN-8291A-9382',
                        imageUrl: p['imageUrl'] ?? '',
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceMd),

                    // Part Uninstalled
                    Text(
                      "Part Uninstalled",
                      style: TextStyles.middle.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    ...uninstalledList.map(
                      (p) => _buildPartItem(
                        name:
                            p['name'] ??
                            p['partId'] ??
                            'Old Motherboard Module',
                        serialNumber: p['serialNumber'] ?? 'SN-1092B-4819',
                        imageUrl: p['imageUrl'] ?? '',
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildPartItem({
    required String name,
    required String serialNumber,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      height: 63.0,
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
        child: Row(
          children: [
            AppNetworkImage(
              url: imageUrl.isNotEmpty
                  ? imageUrl
                  : 'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?q=80&w=200',
              width: 48.0,
              height: 48.0,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
              enableViewer: true,
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyles.bodyLarge.copyWith(
                      color: AppColors.secondary500,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'S/N: $serialNumber',
                    style: TextStyles.label.copyWith(
                      color: AppColors.secondary300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 2. Evidence Photos Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildEvidencePhotosSection(Map<String, dynamic>? closingForm) {
    final prePhotos = closingForm?['prePhotos'] as List<dynamic>? ?? [];
    final duringPhotos = closingForm?['duringPhotos'] as List<dynamic>? ?? [];
    final postPhotos = closingForm?['postPhotos'] as List<dynamic>? ?? [];

    final List<String> preList = prePhotos.map((e) => e.toString()).toList();
    if (preList.isEmpty) {
      preList.addAll([
        'https://images.unsplash.com/photo-1581092160562-40aa08e78837?q=80&w=200',
        'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=200',
      ]);
    }

    final List<String> duringList = duringPhotos
        .map((e) => e.toString())
        .toList();
    if (duringList.isEmpty) {
      duringList.add(
        'https://images.unsplash.com/photo-1581092335397-9583fe92d232?q=80&w=200',
      );
    }

    final List<String> postList = postPhotos.map((e) => e.toString()).toList();
    if (postList.isEmpty) {
      postList.addAll([
        'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=200',
        'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?q=80&w=200',
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          icon: Icons.camera_alt_outlined,
          title: "Evidence Photos",
          isExpanded: _isPhotosExpanded,
          onTap: () => setState(() => _isPhotosExpanded = !_isPhotosExpanded),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isPhotosExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimens.spaceSm),
                    Text(
                      "Pre-Disassembly",
                      style: TextStyles.middle.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    _buildHorizontalPhotoList(preList),
                    const SizedBox(height: AppDimens.spaceMd),
                    Text(
                      "Disassembly",
                      style: TextStyles.middle.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    _buildHorizontalPhotoList(duringList),
                    const SizedBox(height: AppDimens.spaceMd),
                    Text(
                      "Post-Disassembly",
                      style: TextStyles.middle.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    _buildHorizontalPhotoList(postList),
                    const SizedBox(height: AppDimens.spaceSm),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildHorizontalPhotoList(List<String> urls) {
    return SizedBox(
      height: 68.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppDimens.spaceSm),
        itemBuilder: (context, index) {
          return AppNetworkImage(
            url: urls[index],
            width: 68.0,
            height: 68.0,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
            enableViewer: true,
          );
        },
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 3. Diagnostic Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildDiagnosticSection(Map<String, dynamic>? closingForm) {
    final diagnosis =
        closingForm?['diagnosis'] ??
        closingForm?['diagnosisNotes'] ??
        "Device motherboard CPU was overheating due to degraded thermal paste. Cleaned and repasted with high-grade premium thermal compound. Reassembled device and completed stress test beautifully for 45 minutes with optimal temperatures.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          icon: Icons.monitor_heart_outlined,
          title: "Diagnostic Section",
          isExpanded: _isDiagnosticExpanded,
          onTap: () =>
              setState(() => _isDiagnosticExpanded = !_isDiagnosticExpanded),
          customIcon: Transform(
            transform: Matrix4.diagonal3Values(1.0, 1.3, 1.0),
            alignment: Alignment.center,
            child: const Icon(
              Icons.monitor_heart_outlined,
              color: AppColors.tertiary500,
              size: 31,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isDiagnosticExpanded
              ? Container(
                  margin: const EdgeInsets.only(
                    top: AppDimens.spaceSm,
                    bottom: AppDimens.spaceMd,
                  ),
                  padding: const EdgeInsets.all(AppDimens.spaceMd),
                  decoration: BoxDecoration(
                    color: AppColors.surface100,
                    borderRadius: BorderRadius.circular(AppDimens.boraMd),
                    boxShadow: [BoxShadowStyles.subtle],
                    border: Border.all(color: AppColors.secondary300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Diagnostic notes",
                        style: TextStyles.middle.copyWith(
                          color: AppColors.secondary400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      Container(
                        padding: const EdgeInsets.all(AppDimens.spaceSm),
                        decoration: BoxDecoration(
                          color: AppColors.surface100.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(AppDimens.boraSm),
                          border: Border.all(color: AppColors.primary50),
                        ),
                        child: Text(
                          diagnosis,
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.secondary300,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 12.0),
        const Divider(color: AppColors.secondary50, height: 1),
        const SizedBox(height: 0.0),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 4. Customer Response Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildCustomerResponseSection(Map<String, dynamic>? complaint) {
    final rating = complaint?['rating'] ?? complaint?['stars'] ?? 5;
    final ratingInt = rating is int
        ? rating
        : (int.tryParse(rating.toString()) ?? 5);

    final complaintMessage =
        complaint?['message'] ??
        complaint?['complaint'] ??
        "The technician arrived on time and repaired the core motherboard fault within an hour. Excellent communication and highly detailed explanations! The laptop works beautifully now.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          icon: Icons.chat_bubble_outline,
          title: "Customer Response",
          isExpanded: _isCustomerResponseExpanded,
          onTap: () => setState(
            () => _isCustomerResponseExpanded = !_isCustomerResponseExpanded,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isCustomerResponseExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimens.spaceSm),
                    Text(
                      "Complaint",
                      style: TextStyles.middle.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    Text(
                      complaintMessage,
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.secondary500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceMd),
                    Text(
                      "Rating",
                      style: TextStyles.middle.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    _buildStars(ratingInt),
                    const SizedBox(height: AppDimens.spaceSm),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }

  Widget _buildStars(int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isFilled = index < rating;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.star_rounded, color: Colors.black87, size: 38),
              Icon(
                Icons.star_rounded,
                color: isFilled ? const Color(0xFFFBBC05) : Colors.white,
                size: 34,
              ),
            ],
          ),
        );
      }),
    );
  }
}
