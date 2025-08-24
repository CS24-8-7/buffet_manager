import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_theme.dart';
import '../../providers/auth_provider.dart';
import 'change_password.dart';
import 'custom_logout.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CashierDashboard extends StatelessWidget {
  final String currentRoute;
  const CashierDashboard({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final shouldShowSidebar = ResponsiveHelper.shouldShowSidebar(context);
        if (shouldShowSidebar) {
          return _buildSidebar(context, authProvider);
        } else {
          return _buildDrawer(context, authProvider);
        }
      },
    );
  }

  Widget _buildSidebar(BuildContext context, AuthProvider authProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowOpacity = ResponsiveHelper.getShadowOpacity(context);
    final shadowBlurRadius = ResponsiveHelper.getShadowBlurRadius(context);
    final shadowOffset = ResponsiveHelper.getShadowOffset(context);

    return Container(
      width: ResponsiveHelper.getSidebarWidth(context),
      height: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface, // ✅ تم التصحيح
        border: Border(
          right: BorderSide(
            color: AppColors.divider, // ✅ تم التصحيح
            width: ResponsiveHelper.getBorderWidth(context),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(shadowOpacity),
            blurRadius: shadowBlurRadius,
            offset: Offset(shadowOffset, 0),
          ),
        ],
      ),
      child: _buildDrawerContent(context, authProvider, isDesktop: true),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      width: _getDrawerWidth(context),
      child: _buildDrawerContent(context, authProvider, isDesktop: false),
    );
  }

  Widget _buildDrawerContent(BuildContext context, AuthProvider authProvider,
      {required bool isDesktop}) {
    final isManager = authProvider.isManager;
    return Column(
      children: [
        _buildHeader(context, authProvider, isDesktop: isDesktop),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: ResponsiveHelper.getSpacing(context) / 2),
              _buildDrawerItem(
                context,
                icon: Icons.dashboard,
                label: 'الصفحة الرئيسية',
                route: isManager ? '/manager_home' : '/cashier_home',
                selected: currentRoute == '/manager_home' ||
                    currentRoute == '/cashier_home',
                isDesktop: isDesktop,
              ),
              Divider(
                height: ResponsiveHelper.getSpacing(context),
                indent: ResponsiveHelper.getSpacing(context),
                endIndent: ResponsiveHelper.getSpacing(context),
                thickness: ResponsiveHelper.getDividerThickness(context),
              ),
              _buildSectionTitle('الإعدادات', context),
              _buildDrawerItem(
                context,
                icon: Icons.lock,
                label: 'تغيير كلمة المرور',
                onTap: () {
                  if (!isDesktop) {
                    Navigator.of(context).pop();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
                isDesktop: isDesktop,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.info,
                label: 'حول التطبيق',
                onTap: () => _showAboutDialog(context),
                isDesktop: isDesktop,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.logout,
                label: 'تسجيل الخروج',
                onTap: () => _logout(context, isDesktop: isDesktop),
                isDesktop: isDesktop,
              ),
              SizedBox(height: ResponsiveHelper.getBottomSpacing(context)),
            ],
          ),
        ),
      ],
    );
  }

  double _getDrawerWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (ResponsiveHelper.isLargePhone(context)) {
      return width * 0.85;
    } else if (ResponsiveHelper.isTablet(context)) {
      return 320;
    } else {
      return width * 0.9;
    }
  }

  Widget _buildHeader(BuildContext context, AuthProvider authProvider,
      {required bool isDesktop}) {
    final headerHeight = ResponsiveHelper.getHeaderHeight(context, isDesktop);
    final avatarRadius = ResponsiveHelper.getAvatarRadius(context, isDesktop);
    final iconSize = ResponsiveHelper.getHeaderIconSize(context, isDesktop);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: headerHeight,
      width: double.infinity,
      padding: ResponsiveHelper.getHeaderPadding(context, isDesktop),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF121212), Color(0xFF000000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isDesktop
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: colorScheme.onSurface.withOpacity(0.2),
                  child: Icon(
                    authProvider.isManager
                        ? Icons.admin_panel_settings
                        : Icons.person,
                    size: iconSize,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getHeaderSpacing(context)),
                Text(
                  authProvider.currentUser?.username ?? 'مستخدم',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.getHeaderTitleFontSize(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                    height: ResponsiveHelper.getHeaderSpacing(context) / 2),
                Container(
                  padding: ResponsiveHelper.getRoleBadgePadding(context),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getRoleBadgeRadius(context)),
                  ),
                  child: Text(
                    authProvider.currentUser?.roleDisplayName ?? '',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: ResponsiveHelper.getRoleFontSize(context),
                    ),
                  ),
                ),
              ],
            )
          : SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: colorScheme.onSurface.withOpacity(0.2),
                    child: Icon(
                      authProvider.isManager
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      size: iconSize,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getHeaderSpacing(context)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authProvider.currentUser?.username ?? 'مستخدم',
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.getHeaderTitleFontSize(
                                context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                            height:
                                ResponsiveHelper.getHeaderSpacing(context) / 2),
                        Container(
                          padding:
                              ResponsiveHelper.getRoleBadgePadding(context),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(
                                ResponsiveHelper.getRoleBadgeRadius(context)),
                          ),
                          child: Text(
                            authProvider.currentUser?.roleDisplayName ?? '',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  ResponsiveHelper.getRoleFontSize(context),
                            ),
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

  Widget _buildSectionTitle(String title, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ResponsiveHelper.getSpacing(context),
        ResponsiveHelper.getSpacing(context) / 2,
        ResponsiveHelper.getSpacing(context),
        ResponsiveHelper.getSectionTitleBottomSpacing(context),
      ),
      child: Text(
        title,
        style: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
          fontSize: ResponsiveHelper.getSectionTitleFontSize(context),
          letterSpacing: ResponsiveHelper.getLetterSpacing(context),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? route,
    VoidCallback? onTap,
    bool selected = false,
    required bool isDesktop,
  }) {
    final iconSize = ResponsiveHelper.getIconSize(context);
    final fontSize = ResponsiveHelper.getDrawerItemFontSize(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: ResponsiveHelper.getDrawerItemMargin(context),
      child: ListTile(
        contentPadding:
            ResponsiveHelper.getDrawerItemPadding(context, isDesktop),
        leading: Icon(
          icon,
          color: selected ? AppColors.primary : colorScheme.onSurface,
          size: iconSize,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.primary : colorScheme.onSurface,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
        selected: selected,
        selectedTileColor: AppColors.primary.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              ResponsiveHelper.getDrawerItemBorderRadius(context)),
        ),
        onTap: onTap ??
            () {
              if (!isDesktop) {
                Navigator.of(context).pop();
              }
              if (route != null && !selected) {
                Navigator.of(context).pushReplacementNamed(route);
              }
            },
      ),
    );
  }

  void _logout(BuildContext context, {required bool isDesktop}) {
    showDialog(
      context: context,
      builder: (ctx) => CustomLogoutDialog(
        context,
        onCancel: () {
          Navigator.of(ctx).pop();
        },
        onLogout: () {
          Navigator.of(ctx).pop(); // إغلاق الدايالوج
          Provider.of<AuthProvider>(context, listen: false)
              .logout(); // تسجيل الخروج
          if (kIsWeb) {
            Navigator.of(context).pushReplacementNamed('/login');
          } else if (Platform.isAndroid || Platform.isIOS) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              ResponsiveHelper.getDialogBorderRadius(context)),
        ),
        title: Text(
          'حول التطبيق',
          style: TextStyle(
            fontSize: ResponsiveHelper.getDialogTitleFontSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: ResponsiveHelper.getDialogWidth(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نظام إدارة المبيعات',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getDialogContentFontSize(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                  height: ResponsiveHelper.getFormFieldSpacing(context) / 2),
              Text(
                'الإصدار: 1.0.0',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getDialogContentFontSize(context),
                ),
              ),
              SizedBox(
                  height: ResponsiveHelper.getFormFieldSpacing(context) / 2),
              Text(
                'تطبيق شامل لإدارة المبيعات والمنتجات والمستخدمين مع واجهة متجاوبة لجميع الأجهزة.',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getDialogContentFontSize(context),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                ResponsiveHelper.getDialogButtonMinWidth(context),
                ResponsiveHelper.getDialogButtonHeight(context),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getButtonBorderRadius(context)),
              ),
              backgroundColor: AppColors.primary,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'موافق',
              style: TextStyle(
                fontSize: ResponsiveHelper.getDialogButtonFontSize(context),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
