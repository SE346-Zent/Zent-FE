import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'view_models/part_search_viewmodel.dart';
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

class _PartSearchScreenContent extends StatelessWidget {
  const _PartSearchScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PartSearchViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        floatingActionButton: PartSearchAddButton(
          onPressed: () => viewModel.addPartPressed(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const AccountHeader(
                title: 'Part Search',
                showDivider: true,
              ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceMd,
                        ),
                        itemCount: viewModel.parts.length,
                        itemBuilder: (context, index) {
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
