import 'package:flutter/material.dart';
import '../../../common/core/themes/dimens.dart';
import 'company_input_field.dart';

class CompanyInputForm extends StatelessWidget {
  final String companyName;
  final String taxId;
  final String primaryAddress;
  final String contactPerson;

  const CompanyInputForm({
    super.key,
    required this.companyName,
    required this.taxId,
    required this.primaryAddress,
    required this.contactPerson,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CompanyInputField(
          label: 'Company Name',
          hintText: companyName,
          icon: Icons.business_outlined,
        ),
        const SizedBox(height: AppDimens.spaceLg),
        CompanyInputField(
          label: 'Business Tax ID',
          hintText: taxId,
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: AppDimens.spaceLg),
        CompanyInputField(
          label: 'Primary Address',
          hintText: primaryAddress,
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: AppDimens.spaceLg),
        CompanyInputField(
          label: 'Main Contact Person',
          hintText: contactPerson,
          icon: Icons.person_outline,
        ),
      ],
    );
  }
}
