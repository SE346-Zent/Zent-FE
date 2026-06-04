import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;
import 'package:zent_fe/presentation/common/core/ui/app_network_image.dart';
import '../account/widgets/customer_app_bar.dart';
import 'viewmodels/parts_viewmodel.dart';

class PartsScreen extends StatefulWidget {
  final String serialNumber;
  final String modelCode;
  const PartsScreen({
    super.key,
    required this.serialNumber,
    this.modelCode = '',
  });

  @override
  State<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {
  late PartsViewModel _viewModel;
  final GlobalKey _searchBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _viewModel = sl<PartsViewModel>();
    _viewModel.init(widget.serialNumber, modelCode: widget.modelCode);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: _PartsView(
        searchBarKey: _searchBarKey,
        serialNumber: widget.serialNumber,
        modelCode: widget.modelCode,
      ),
    );
  }
}

class _PartsView extends StatelessWidget {
  final GlobalKey searchBarKey;
  final String serialNumber;
  final String modelCode;
  const _PartsView({
    required this.searchBarKey,
    required this.serialNumber,
    this.modelCode = '',
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PartsViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface100,
        appBar: const CustomerAppBar(
          title: 'Parts',
          showBackButton: true,
          showBottomDivider: true,
        ),
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. PRODUCT CARD ---
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimens.boraMd),
                        boxShadow: [BoxShadowStyles.raised],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppNetworkImage(
                            url:
                                viewModel.product?.productImageUrl != null &&
                                    (viewModel.product!.productImageUrl!
                                            .startsWith('http') ||
                                        viewModel.product!.productImageUrl!
                                            .startsWith('https'))
                                ? viewModel.product!.productImageUrl!
                                : null,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppDimens.boraMd),
                              topRight: Radius.circular(AppDimens.boraMd),
                            ),
                            enableViewer: true,
                            errorWidget: Image.asset(
                              AppAssets.laptopA,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppDimens.spaceMd),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewModel.product?.name ?? 'Product Details',
                                  style: TextStyles.headline.copyWith(
                                    color: AppColors.primary500,
                                  ),
                                ),
                                const SizedBox(height: AppDimens.spaceMd),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'S/N: $serialNumber',
                                        style: TextStyles.bodyLarge.copyWith(
                                          color: AppColors.secondary500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: AppDimens.spaceSm),
                                    Expanded(
                                      child: Text(
                                        'MTM: ${viewModel.product?.model ?? (modelCode.isNotEmpty ? modelCode : 'NA')}',
                                        textAlign: TextAlign.right,
                                        style: TextStyles.bodyLarge.copyWith(
                                          color: AppColors.secondary500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXl),

                    // --- 2. LIST PARTS HEADER & SEARCH ---
                    Text('List Parts', style: TextStyles.headline),
                    const SizedBox(height: AppDimens.spaceMd),
                    Container(
                      key: searchBarKey,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                        boxShadow: [BoxShadowStyles.subtle],
                      ),
                      child: TextField(
                        controller: viewModel.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search parts',
                          hintStyle: TextStyles.bodyLarge.copyWith(
                            color: AppColors.secondary300,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraSm,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.secondary200,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraSm,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.secondary200,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.secondary400,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.filter_list,
                              color: AppColors.secondary600,
                            ),
                            onPressed: () {
                              _showFilterMenu(context, viewModel);
                            },
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceLg),

                    // --- 3. PARTS LIST ---
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.filteredParts.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppDimens.spaceMd),
                      itemBuilder: (context, index) {
                        final part = viewModel.filteredParts[index];

                        return Container(
                          padding: const EdgeInsets.all(AppDimens.spaceMd),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraMd,
                            ),
                            boxShadow: [BoxShadowStyles.raised],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary100,
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.boraSm,
                                  ),
                                ),
                                child:
                                    part.imageUrl != null &&
                                        part.imageUrl!.isNotEmpty
                                    ? AppNetworkImage(
                                        url: part.imageUrl!.startsWith('http')
                                            ? part.imageUrl!
                                            : null,
                                        fit: BoxFit.cover,
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.boraSm,
                                        ),
                                        enableViewer: true,
                                        errorWidget:
                                            !part.imageUrl!.startsWith('http')
                                            ? Image.asset(
                                                part.imageUrl!,
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      )
                                    : const Icon(
                                        Icons.dns_outlined,
                                        color: AppColors.secondary500,
                                        size: 28,
                                      ),
                              ),
                              const SizedBox(width: AppDimens.spaceMd),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(part.title, style: TextStyles.title),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Part No: ${part.partNo}',
                                      style: TextStyles.label.copyWith(
                                        color: AppColors.secondary500,
                                      ),
                                    ),
                                    Text(
                                      'Commodity: ${part.commodity}',
                                      style: TextStyles.label.copyWith(
                                        color: AppColors.secondary500,
                                      ),
                                    ),
                                    Text(
                                      'MTM: ${part.modelCode}',
                                      style: TextStyles.label.copyWith(
                                        color: AppColors.secondary500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                part.status,
                                style: TextStyles.bodyLarge.copyWith(
                                  color:
                                      part.status.toLowerCase().contains(
                                            'new',
                                          ) ||
                                          part.status.toLowerCase().contains(
                                            'available',
                                          )
                                      ? AppColors.success500
                                      : AppColors.secondary500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // --- Popup Menu Filter ---
  void _showFilterMenu(BuildContext context, PartsViewModel viewModel) {
    // Lấy đối tượng render và tọa độ từ search bar
    final RenderBox renderBox =
        searchBarKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: offset.dy + renderBox.size.height + 4,
              right:
                  MediaQuery.of(context).size.width -
                  offset.dx -
                  renderBox.size.width,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.boraMd),
                    boxShadow: [BoxShadowStyles.overlay],
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: AppDimens.spaceMd,
                              top: AppDimens.spaceMd,
                              right: AppDimens.spaceMd,
                              bottom: 8,
                            ),
                            child: Text(
                              'Filtering',
                              style: TextStyles.headline.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            color: AppColors.secondary100,
                          ),
                          const SizedBox(height: AppDimens.spaceSm),
                          _buildFilterRow(
                            'Alphabet',
                            viewModel.sortAlphabet,
                            ['None', 'A-Z', 'Z-A'],
                            (val) {
                              setState(() => viewModel.setSortAlphabet(val!));
                            },
                          ),
                          _buildFilterRow(
                            'Status',
                            viewModel.filterStatus,
                            ['None', 'Available', 'Unavailable'],
                            (val) {
                              setState(() => viewModel.setFilterStatus(val!));
                            },
                          ),
                          const SizedBox(height: AppDimens.spaceSm),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Helper ---
  Widget _buildFilterRow(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.bodyLarge),
          PopupMenuButton<String>(
            offset: const Offset(0, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
            ),
            onSelected: onChanged,
            itemBuilder: (context) {
              return options
                  .map(
                    (e) => PopupMenuItem<String>(
                      value: e,
                      height: 36,
                      child: Text(
                        e,
                        style: TextStyles.label.copyWith(color: Colors.black),
                      ),
                    ),
                  )
                  .toList();
            },
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondary400),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: TextStyles.label.copyWith(color: Colors.black),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.secondary500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
