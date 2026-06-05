import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'viewmodels/part_search_viewmodel.dart';
import 'widgets/part_search_item.dart';
import 'widgets/part_search_bar.dart';
import 'widgets/part_search_add_button.dart';

class PartSearchScreen extends StatelessWidget {
  const PartSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<PartSearchViewModel>(),
      child: const _PartSearchScreenContent(),
    );
  }
}

class _PartSearchScreenContent extends StatefulWidget {
  const _PartSearchScreenContent();

  @override
  State<_PartSearchScreenContent> createState() =>
      _PartSearchScreenContentState();
}

class _PartSearchScreenContentState extends State<_PartSearchScreenContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PartSearchViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PartSearchViewModel>();

    return ThrottledGestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        floatingActionButton: PartSearchAddButton(
          onPressed: () => viewModel.addPartPressed(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const AccountHeader(title: 'Part Search', showDivider: true),
              const SizedBox(height: AppDimens.spaceLg),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                ),
                child: PartSearchBar(
                  onChanged: (value) => viewModel.searchTextChanged(value),
                  onFilterTapped: () => viewModel.filterPressed(),
                ),
              ),
              const SizedBox(height: AppDimens.spaceLg),
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceMd,
                        ),
                        itemCount:
                            viewModel.parts.length +
                            (viewModel.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == viewModel.parts.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimens.spaceMd,
                              ),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final part = viewModel.parts[index];
                          return PartSearchItem(
                            part: part,
                            onTap: () => viewModel.partTapped(part),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
