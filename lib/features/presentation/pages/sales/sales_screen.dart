import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_theme.dart';
import '../../providers/sales_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/sales_stats_widgets.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SalesProvider>(context, listen: false).loadSalesData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المبيعات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<SalesProvider>(context, listen: false).refreshData();
            },
            tooltip: 'تحديث',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printSalesReport,
            tooltip: 'طباعة التقرير',
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: ResponsiveHelper.shouldShowSidebar(context)
          ? null
          : const AppDrawer(currentRoute: '/sales'),
      body: ResponsiveHelper.isDesktop(context)
          ? _buildDesktopLayout(context)
          : _buildMobileLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // الشريط الجانبي
        if (ResponsiveHelper.shouldShowSidebar(context))
          SizedBox(
            width: ResponsiveHelper.getSidebarWidth(context),
            child: const AppDrawer(currentRoute: '/sales'),
          ),

        // المحتوى الرئيسي
        Expanded(
          child: _buildSalesContent(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return _buildSalesContent(context);
  }

  Widget _buildSalesContent(BuildContext context) {
    return Column(
      children: [
        _buildQuickStats(context),
        Expanded(
          child: _buildSalesList(context),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, salesProvider, child) {
        final statsCards = [
          StatsCard(
            title: 'مبيعات اليوم',
            value: salesProvider.formattedTodayTotal,
            subtitle: '${salesProvider.todayCount} فاتورة',
            icon: Icons.today,
            color: AppColors.primary, // ✅ تم التصحيح
          ),
          StatsCard(
            title: 'مبيعات الأسبوع',
            value: salesProvider.formattedWeekTotal,
            icon: Icons.date_range,
            color: AppColors.secondary, // ✅ تم التصحيح
          ),
          StatsCard(
            title: 'مبيعات الشهر',
            value: salesProvider.formattedMonthTotal,
            icon: Icons.calendar_month,
            color: AppColors.success, // ✅ تم التصحيح
          ),
          StatsCard(
            title: 'إجمالي المبيعات',
            value: '${salesProvider.totalSales}',
            subtitle: 'فاتورة',
            icon: Icons.receipt_long,
            color: Theme.of(context).colorScheme.secondary, // ✅ تم التصحيح (استخدم secondary من colorScheme)
          ),
        ];

        return SharedStatsBuilder.buildStatsContainer(
          context: context,
          cards: statsCards,
        );
      },
    );
  }

  Widget _buildSalesList(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, salesProvider, child) {
        if (salesProvider.sales.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: AppColors.textSecondary, // ✅ تم التصحيح
                ),
                SizedBox(height: 16),
                Text(
                  'لا توجد مبيعات',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary, // ✅ تم التصحيح
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: ResponsiveHelper.getResponsivePadding(context),
          itemCount: salesProvider.sales.length,
          itemBuilder: (context, index) {
            final sale = salesProvider.sales[index];
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: AppConstants.paddingM), // ✅ تم التصحيح
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1), // ✅ تم التصحيح
                  child: Text(
                    '${sale.id}',
                    style: const TextStyle(
                      color: AppColors.primary, // ✅ تم التصحيح
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  'فاتورة #${sale.id}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الكاشير: ${sale.cashierName ?? 'غير محدد'}'),
                    Text(
                      '${sale.formattedDate} - ${sale.formattedTime}',
                      style: const TextStyle(color: AppColors.textSecondary), // ✅ تم التصحيح
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      sale.formattedTotal,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary, // ✅ تم التصحيح
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (ResponsiveHelper.isDesktop(context))
                      IconButton(
                        icon: const Icon(Icons.visibility, size: 20),
                        onPressed: () => _showSaleDetails(context, sale, salesProvider),
                        tooltip: 'عرض التفاصيل',
                        style: IconButton.styleFrom(
                          foregroundColor: AppColors.primary, // ✅ تم التصحيح
                        ),
                      ),
                  ],
                ),
                onTap: ResponsiveHelper.isMobile(context)
                    ? () => _showSaleDetails(context, sale, salesProvider)
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  void _showSaleDetails(BuildContext context, sale, SalesProvider salesProvider) async {
    final saleItems = await salesProvider.getSaleItems(sale.id!);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('تفاصيل فاتورة #${sale.id}'),
          content: SizedBox(
            width: ResponsiveHelper.isMobile(context) ? double.maxFinite : 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات الفاتورة
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingM), // ✅ تم التصحيح
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface, // ✅ تم التصحيح (استخدم surface بدلًا من thirdColor)
                    borderRadius: BorderRadius.circular(AppConstants.radiusM), // ✅ تم التصحيح
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('التاريخ: ${sale.formattedDate}'),
                      Text('الوقت: ${sale.formattedTime}'),
                      Text('الكاشير: ${sale.cashierName ?? 'غير محدد'}'),
                      if (sale.notes != null && sale.notes!.isNotEmpty)
                        Text('ملاحظات: ${sale.notes}'),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.paddingM), // ✅ تم التصحيح

                // عناصر الفاتورة
                const Text(
                  'العناصر:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppConstants.paddingS), // ✅ تم التصحيح

                if (saleItems.isNotEmpty)
                  ...saleItems
                      .where((item) => item != null) // ✅ Remove nulls
                      .map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(item.productName)), // ✅ Safe to use !
                        Text('${item.quantity}x'),
                        const SizedBox(width: 8),
                        Text(item.formattedPrice),
                      ],
                    ),
                  ))
                else
                  const Text('لا توجد عناصر'),
                const Divider(),

                // الإجمالي
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الإجمالي:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      sale.formattedTotal,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary, // ✅ تم التصحيح
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: إعادة طباعة الفاتورة
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // ✅ تم التصحيح
              ),
              child: const Text('طباعة'),
            ),
          ],
        ),
      );
    }
  }

  void _printSalesReport() {
    // TODO: تنفيذ طباعة تقرير المبيعات
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة ميزة طباعة التقرير قريباً'),
        backgroundColor: AppColors.primary, // ✅ تم التصحيح
      ),
    );
  }
}