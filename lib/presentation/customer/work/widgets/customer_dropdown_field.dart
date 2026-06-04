import 'package:flutter/material.dart';
import '../../../../presentation/common/core/themes/boxshadow.dart';
import '../../../../presentation/common/core/themes/colors.dart';
import '../../../../presentation/common/core/themes/dimens.dart';
import '../../../../presentation/common/core/themes/text_styles.dart';

class CustomerDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isRequired;
  final bool readOnly;
  final String? hint;
  final bool isSearchable;

  const CustomerDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.readOnly = false,
    this.hint,
    this.isSearchable = false,
  });

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXs),
      child: RichText(
        text: TextSpan(
          text: label,
          style: TextStyles.title.copyWith(color: AppColors.primary500),
          children: isRequired
              ? [
                  TextSpan(
                    text: '*',
                    style: TextStyles.title.copyWith(
                      color: AppColors.error500,
                    ),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _SearchDialog<T>(
          label: label,
          items: items,
          onSelected: onChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSearchable && !readOnly) {
      // Find the label matching the current value to display
      String displayValue = '';
      if (value != null) {
        final matchedItem = items.cast<DropdownMenuItem<T>?>().firstWhere(
              (item) => item?.value == value,
              orElse: () => null,
            );
        if (matchedItem != null && matchedItem.child is Text) {
          displayValue = (matchedItem.child as Text).data ?? '';
        } else {
          displayValue = value.toString();
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(),
          GestureDetector(
            onTap: () => _showSearchDialog(context),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceSm),
              decoration: BoxDecoration(
                color: AppColors.surface100,
                borderRadius: BorderRadius.circular(AppDimens.boraMd),
                border: Border.all(color: AppColors.secondary100, width: 1.0),
                boxShadow: [BoxShadowStyles.subtle],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayValue.isNotEmpty ? displayValue : (hint ?? 'Select...'),
                      style: TextStyles.bodyLarge.copyWith(
                        color: displayValue.isNotEmpty ? AppColors.primary500 : AppColors.secondary300,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.secondary100,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: readOnly ? AppColors.secondary50 : AppColors.surface100,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary100, width: 1.0),
            boxShadow: [BoxShadowStyles.subtle],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              hint: hint != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        hint!,
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
                    )
                  : null,
              items: items,
              onChanged: readOnly ? null : onChanged,
              icon: const Padding(
                padding: EdgeInsets.only(right: AppDimens.spaceSm),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.secondary100,
                ),
              ),
              dropdownColor: AppColors.surface100,
              style: TextStyles.bodyLarge.copyWith(color: AppColors.primary500),
              padding: const EdgeInsets.only(left: AppDimens.spaceSm),
              borderRadius: BorderRadius.circular(AppDimens.boraMd),
              elevation: 4,
              menuMaxHeight: 300,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchDialog<T> extends StatefulWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onSelected;

  const _SearchDialog({
    required this.label,
    required this.items,
    required this.onSelected,
  });

  @override
  State<_SearchDialog<T>> createState() => _SearchDialogState<T>();
}

class _SearchDialogState<T> extends State<_SearchDialog<T>> {
  final _searchCtrl = TextEditingController();
  List<DropdownMenuItem<T>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      _filteredItems = widget.items.where((item) {
        final text = _getMenuItemText(item).toLowerCase();
        return text.contains(query.toLowerCase());
      }).toList();
    });
  }

  String _getMenuItemText(DropdownMenuItem<T> item) {
    if (item.child is Text) {
      return (item.child as Text).data ?? '';
    }
    return item.value?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select ${widget.label}',
              style: TextStyles.title.copyWith(color: AppColors.primary500),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, color: AppColors.secondary300),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.secondary100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.tertiary500),
                ),
              ),
              onChanged: _filter,
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: _filteredItems.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No matches found',
                          style: TextStyle(color: AppColors.secondary300),
                        ),
                      ),
                    )
                  : Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return ListTile(
                            title: item.child,
                            onTap: () {
                              widget.onSelected(item.value);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
