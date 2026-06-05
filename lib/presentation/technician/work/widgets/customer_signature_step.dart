import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:signature/signature.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/technician/work/widgets/dashed_border_container.dart';

class CustomerSignatureStep extends StatefulWidget {
  final String workOrderId;
  final String date;
  final String technicianName;
  final List<Map<String, dynamic>> initialPoints;
  final void Function(List<Map<String, dynamic>> points) onSignatureUpdated;
  final bool isReadOnly;

  const CustomerSignatureStep({
    super.key,
    required this.workOrderId,
    required this.date,
    required this.technicianName,
    required this.initialPoints,
    required this.onSignatureUpdated,
    this.isReadOnly = false,
  });

  @override
  State<CustomerSignatureStep> createState() => _CustomerSignatureStepState();
}

class _CustomerSignatureStepState extends State<CustomerSignatureStep> {
  late final SignatureController _signatureController;
  bool _hasSignature = false;

  @override
  void initState() {
    super.initState();

    // Restore saved signature points
    final restoredPoints = _deserializePoints(widget.initialPoints);

    _signatureController = SignatureController(
      penStrokeWidth: 2.5,
      penColor: AppColors.primary500,
      exportBackgroundColor: AppColors.surface50,
      points: restoredPoints.isNotEmpty ? restoredPoints : null,
    );

    _hasSignature = _signatureController.isNotEmpty;
    _signatureController.addListener(_onSignatureChanged);
  }

  @override
  void dispose() {
    // Save current points before disposing
    _persistCurrentPoints();
    _signatureController.removeListener(_onSignatureChanged);
    _signatureController.dispose();
    super.dispose();
  }

  void _onSignatureChanged() {
    final hasPoints = _signatureController.isNotEmpty;
    if (hasPoints != _hasSignature) {
      setState(() {
        _hasSignature = hasPoints;
      });
    }
  }

  void _onClearSignature() {
    _signatureController.clear();
    _persistCurrentPoints();
  }

  void _persistCurrentPoints() {
    final serialized = _serializePoints(_signatureController.points);
    widget.onSignatureUpdated(serialized);
  }

  /// Serialize signature Points to a list of maps for JSON storage.
  List<Map<String, dynamic>> _serializePoints(List<Point> points) {
    return points
        .map(
          (p) => {
            'x': p.offset.dx,
            'y': p.offset.dy,
            't': p.type == PointType.tap ? 0 : 1,
            'p': p.pressure,
          },
        )
        .toList();
  }

  /// Deserialize maps back to signature Points.
  List<Point> _deserializePoints(List<Map<String, dynamic>> data) {
    return data
        .map(
          (m) => Point(
            Offset((m['x'] as num).toDouble(), (m['y'] as num).toDouble()),
            (m['t'] as int) == 0 ? PointType.tap : PointType.move,
            (m['p'] as num?)?.toDouble() ?? 1.0,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAuthorizationText(),
        const SizedBox(height: AppDimens.spaceMd),
        _buildWorkOrderInfoCard(),
        const SizedBox(height: AppDimens.spaceLg),
        _buildSignatureSection(context),
      ],
    );
  }

  Widget _buildAuthorizationText() {
    return Text(
      "Please authorize the\ncompleted service.",
      style: TextStyles.display.copyWith(color: AppColors.primary500),
    );
  }

  Widget _buildWorkOrderInfoCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
        border: Border.all(color: AppColors.secondary300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        child: Row(
          children: [
            // Left accent bar
            Container(width: 6, color: AppColors.tertiary500),
            // Content area
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceSm,
                ),
                decoration: const BoxDecoration(color: AppColors.secondary50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "WORK ORDER ID",
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.secondary300,
                      ),
                    ),
                    Text(
                      widget.workOrderId,
                      style: TextStyles.title.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    Row(
                      children: [
                        Expanded(child: _buildInfoSubCard("DATE", widget.date)),
                        const SizedBox(width: AppDimens.spaceSm),
                        Expanded(
                          child: _buildInfoSubCard(
                            "TECHNICIAN",
                            widget.technicianName,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSubCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface50,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.subtle],
        border: Border.all(color: AppColors.secondary300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary300,
            ),
          ),
          Text(
            value,
            style: TextStyles.label.copyWith(color: AppColors.primary500),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "CUSTOMER SIGNATURE",
              style: TextStyles.middle.copyWith(color: AppColors.secondary500),
            ),
            if (_hasSignature && !widget.isReadOnly)
              ThrottledGestureDetector(
                onTap: _onClearSignature,
                child: Text(
                  "Clear",
                  style: TextStyles.label.copyWith(color: AppColors.error500),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceSm),
        _buildSignaturePad(context),
      ],
    );
  }

  Widget _buildSignaturePad(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padSize = screenWidth - (AppDimens.spaceMd * 4);

    return DashedBorderContainer(
      height: padSize,
      color: AppColors.secondary300,
      strokeWidth: 1.0,
      borderRadius: AppDimens.boraMd,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        child: SizedBox(
          width: double.infinity,
          height: padSize,
          child: Stack(
            children: [
              // Signature pad — always present, always interactive
              AbsorbPointer(
                absorbing: widget.isReadOnly,
                child: Signature(
                  controller: _signatureController,
                  width: double.infinity,
                  height: padSize,
                  backgroundColor: AppColors.surface50,
                ),
              ),
              // Placeholder overlay — hidden once user starts drawing
              if (!_hasSignature)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.isReadOnly
                                ? Icons.warning_amber_outlined
                                : Icons.edit_outlined,
                            size: 44,
                            color: AppColors.secondary300,
                          ),
                          const SizedBox(height: AppDimens.spaceXs),
                          Text(
                            widget.isReadOnly
                                ? "NO SIGNATURE RECORDED"
                                : "SIGN HERE",
                            style: TextStyles.title.copyWith(
                              color: AppColors.secondary300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
