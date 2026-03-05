import 'package:flutter/material.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/themes/dimens.dart';
import '../../common/core/themes/text_styles.dart';
import 'widgets/company_input_field.dart';

class CompanySettingsScreen extends StatelessWidget {
  const CompanySettingsScreen({super.key});

  void _onBackPressed() {
    debugPrint("action triggered: _onBackPressed");
  }

  void _onEditAvatarPressed() {
    debugPrint("action triggered: _onEditAvatarPressed");
  }

  void _onUpdatePressed() {
    debugPrint("action triggered: _onUpdatePressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAvatarBlock(),
                    const SizedBox(height: AppDimens.spaceLg),
                    _buildCompanyInfo(),
                    const SizedBox(height: AppDimens.spaceXl),
                    _buildInputForm(),
                    const SizedBox(height: 48.0), // Spacing before button
                  ],
                ),
              ),
            ),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarBlock() {
    return SizedBox(
      width: 118.0,
      height: 118.0,
      child: Stack(
        children: [
          Container(
            width: 118.0,
            height: 118.0,
            decoration: const BoxDecoration(
              color: AppColors.tertiary400,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                'https://picsum.photos/200',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _onEditAvatarPressed,
              child: Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: AppColors.tertiary500,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors
                        .background500, // matches background to create cutout separation illusion
                    width: 3.0,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.edit,
                  color: AppColors.surface100, // #FFFFFF
                  size:
                      14.0, // adjusted slightly to fit comfortably inside the expanded border
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Column(
      children: [
        Text(
          'Google',
          style: TextStyles.headline.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          '1600 Amphitheatre Parkway, Mountain View, CA 94043',
          style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInputForm() {
    return Column(
      children: const [
        CompanyInputField(
          label: 'Company Name',
          hintText: 'Hung dep zai',
          icon: Icons.business_outlined,
        ),
        SizedBox(height: AppDimens.spaceLg),
        CompanyInputField(
          label: 'Business Tax ID',
          hintText: 'ABC-123456',
          icon: Icons.badge_outlined,
        ),
        SizedBox(height: AppDimens.spaceLg),
        CompanyInputField(
          label: 'Primary Address',
          hintText: '7, Bui Thi Xuan, Phuong Sai Gon, TPHCM',
          icon: Icons.location_on_outlined,
        ),
        SizedBox(height: AppDimens.spaceLg),
        CompanyInputField(
          label: 'Main Contact Person',
          hintText: 'Hung dep zai',
          icon: Icons.person_outline,
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.spaceMd,
        right: AppDimens.spaceMd,
        bottom: AppDimens.spaceLg,
        top: AppDimens.spaceSm,
      ),
      child: SizedBox(
        width: 364.0,
        height: 49.0,
        child: ElevatedButton(
          onPressed: _onUpdatePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tertiary500,
            foregroundColor: AppColors.surface100, // #FFFFFF
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.boraMd),
            ),
            elevation: 0,
          ),
          child: Text(
            'Update Company Info',
            style: TextStyles.title.copyWith(color: AppColors.surface100),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceSm,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 32.0,
                height: 40.0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primary500,
                  ),
                  onPressed: _onBackPressed,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Company Settings',
                    style: TextStyles.headline.copyWith(
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32.0), // Balance the row
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 1.0,
          color: AppColors.secondary50,
        ),
      ],
    );
  }
}
