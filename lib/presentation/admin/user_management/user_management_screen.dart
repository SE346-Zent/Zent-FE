import 'package:flutter/material.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/themes/dimens.dart';
import '../../common/core/themes/text_styles.dart';
import 'widgets/user_list_item.dart';
import 'widgets/user_role_tabs.dart';
import 'widgets/user_search_bar.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  int _activeTabIndex = 0;

  final List<Map<String, dynamic>> _techniciansData = [
    {
      'userName': 'John Doe (Tech)',
      'userRole': 'Senior Electrician',
      'avatarUrl': 'https://i.pravatar.cc/150?img=11',
      'status': UserStatus.active,
    },
    {
      'userName': 'Jane Smith (Tech)',
      'userRole': 'Junior Electrician',
      'avatarUrl': 'https://i.pravatar.cc/150?img=5',
      'status': UserStatus.away,
    },
  ];

  final List<Map<String, dynamic>> _adminsData = [
    {
      'userName': 'Alice Admin',
      'userRole': 'System Administrator',
      'avatarUrl': 'https://i.pravatar.cc/150?img=1',
      'status': UserStatus.active,
    },
    {
      'userName': 'Bob Manager',
      'userRole': 'Regional Manager',
      'avatarUrl': 'https://i.pravatar.cc/150?img=13',
      'status': UserStatus.inactive,
    },
  ];

  void _onBackPressed() {
    debugPrint("action triggered: _onBackPressed");
  }

  void _onTabChanged(int index) {
    setState(() {
      _activeTabIndex = index;
    });
    debugPrint("action triggered: _onTabChanged to $index");
  }

  void _onAddUserPressed() {
    debugPrint("action triggered: _onAddUserPressed");
  }

  void _onEditUserPressed(int index) {
    debugPrint("action triggered: _onEditUserPressed for user $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      floatingActionButton: _buildFab(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: AppDimens.spaceLg),
            _buildSearchBar(),
            const SizedBox(height: AppDimens.spaceMd),
            _buildRoleTabs(),
            const SizedBox(height: AppDimens.spaceLg),
            _buildUserList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Container(
      width: 61.0,
      height: 61.0,
      margin: const EdgeInsets.only(bottom: 24.0, right: 8.0),
      decoration: BoxDecoration(
        color: AppColors.tertiary400,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary800.withValues(alpha: 0.25),
            blurRadius: 10.0,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _onAddUserPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Text(
          '+',
          style: TextStyles.display.copyWith(
            color: AppColors.surface100,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: UserSearchBar(),
    );
  }

  Widget _buildRoleTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: UserRoleTabs(
        activeIndex: _activeTabIndex,
        onTabChanged: _onTabChanged,
      ),
    );
  }

  Widget _buildUserList() {
    return Expanded(
      child: Builder(
        builder: (context) {
          final activeData = _activeTabIndex == 0
              ? _techniciansData
              : _adminsData;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            itemCount: activeData.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppDimens.spaceMd),
            itemBuilder: (context, index) {
              final user = activeData[index];
              return UserListItem(
                userName: user['userName'],
                userRole: user['userRole'],
                avatarUrl: user['avatarUrl'],
                status: user['status'],
                onEditTap: () => _onEditUserPressed(index),
              );
            },
          );
        },
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
                    'Manage Account',
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
