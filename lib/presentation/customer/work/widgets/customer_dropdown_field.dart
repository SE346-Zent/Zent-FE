import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
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
                    style: TextStyles.title.copyWith(color: AppColors.error500),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSearchable && !readOnly) {
      return _SearchableDropdownField<T>(
        label: label,
        value: value,
        items: items,
        onChanged: onChanged,
        isRequired: isRequired,
        readOnly: readOnly,
        hint: hint,
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

class _SearchableDropdownField<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isRequired;
  final bool readOnly;
  final String? hint;

  const _SearchableDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.isRequired,
    required this.readOnly,
    this.hint,
  });

  @override
  State<_SearchableDropdownField<T>> createState() =>
      _SearchableDropdownFieldState<T>();
}

class _SearchableDropdownFieldState<T>
    extends State<_SearchableDropdownField<T>> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<DropdownMenuItem<T>> _filteredItems = [];
  final GlobalKey _fieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _updateTextToSelectedValue();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant _SearchableDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value || widget.items != oldWidget.items) {
      if (!_focusNode.hasFocus) {
        _updateTextToSelectedValue();
      }
      _filteredItems = widget.items;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _searchController.clear();
      _filterItems('');
      _showOverlay();
    } else {
      _hideOverlay();
      _updateTextToSelectedValue();
    }
  }

  String _getDisplayValue(T? val) {
    if (val == null) return '';
    final matchedItem = widget.items.cast<DropdownMenuItem<T>?>().firstWhere(
      (item) => item?.value == val,
      orElse: () => null,
    );
    if (matchedItem != null && matchedItem.child is Text) {
      return (matchedItem.child as Text).data ?? '';
    }
    return val.toString();
  }

  void _updateTextToSelectedValue() {
    _searchController.text = _getDisplayValue(widget.value);
  }

  String _removeDiacritics(String str) {
    const vietnamese = 'aAeEoOuUiIdDyY';
    final vietnameseRegex = [
      RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'),
      RegExp(r'[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]'),
      RegExp(r'[èéẹẻẽêềếệểễ]'),
      RegExp(r'[ÈÉẸẺẼÊỀẾỆỂỄ]'),
      RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'),
      RegExp(r'[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]'),
      RegExp(r'[ùúụủũưừứựửữ]'),
      RegExp(r'[ÙÚỤỦŨƯỪỨỰỬỮ]'),
      RegExp(r'[ìíịỉĩ]'),
      RegExp(r'[ÌÍỊỈĨ]'),
      RegExp(r'[đ]'),
      RegExp(r'[Đ]'),
      RegExp(r'[ỳýỵỷỹ]'),
      RegExp(r'[ỲÝỴỶỸ]'),
    ];

    var result = str;
    for (var i = 0; i < vietnameseRegex.length; i++) {
      result = result.replaceAll(vietnameseRegex[i], vietnamese[i]);
    }
    return result;
  }

  void _filterItems(String query) {
    final cleanQuery = _removeDiacritics(query).toLowerCase();
    setState(() {
      _filteredItems = widget.items.where((item) {
        final text = _getMenuItemText(item);
        final cleanText = _removeDiacritics(text).toLowerCase();
        return cleanText.contains(cleanQuery);
      }).toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  String _getMenuItemText(DropdownMenuItem<T> item) {
    if (item.child is Text) {
      return (item.child as Text).data ?? '';
    }
    return item.value?.toString() ?? '';
  }

  void _showOverlay() {
    _hideOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 4),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(AppDimens.boraMd),
              color: AppColors.surface100,
              shadowColor: const Color(0x4D000000),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.boraMd),
                  border: Border.all(color: AppColors.secondary100),
                ),
                constraints: const BoxConstraints(maxHeight: 250),
                child: _filteredItems.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No matches found',
                          style: TextStyle(color: AppColors.secondary300),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final isSelected = item.value == widget.value;
                            return ThrottledInkWell(
                              onTap: () {
                                widget.onChanged(item.value);
                                _focusNode.unfocus();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.spaceSm,
                                  vertical: 12,
                                ),
                                color: isSelected
                                    ? AppColors.secondary50
                                    : null,
                                child: DefaultTextStyle(
                                  style: TextStyles.bodyLarge.copyWith(
                                    color: isSelected
                                        ? AppColors.tertiary500
                                        : AppColors.primary500,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                  child: item.child,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXs),
      child: RichText(
        text: TextSpan(
          text: widget.label,
          style: TextStyles.title.copyWith(color: AppColors.primary500),
          children: widget.isRequired
              ? [
                  TextSpan(
                    text: '*',
                    style: TextStyles.title.copyWith(color: AppColors.error500),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentSelectedLabel = _getDisplayValue(widget.value);
    final String currentHint = currentSelectedLabel.isNotEmpty
        ? currentSelectedLabel
        : (widget.hint ?? 'Search or select...');

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        key: _fieldKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: widget.readOnly
                  ? AppColors.secondary50
                  : AppColors.surface100,
              borderRadius: BorderRadius.circular(AppDimens.boraMd),
              border: Border.all(color: AppColors.secondary100, width: 1.0),
              boxShadow: [BoxShadowStyles.subtle],
            ),
            child: TextField(
              focusNode: _focusNode,
              controller: _searchController,
              readOnly: widget.readOnly,
              onChanged: _filterItems,
              style: TextStyles.bodyLarge.copyWith(color: AppColors.primary500),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceSm,
                  vertical: 12.0,
                ),
                hintText: currentHint,
                hintStyle: TextStyles.bodyLarge.copyWith(
                  color: currentSelectedLabel.isNotEmpty && _focusNode.hasFocus
                      ? AppColors.secondary300
                      : AppColors.secondary300,
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    if (value.text.isNotEmpty && _focusNode.hasFocus) {
                      return IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        color: AppColors.secondary300,
                        onPressed: () {
                          _searchController.clear();
                          _filterItems('');
                        },
                      );
                    }
                    return const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.secondary100,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
