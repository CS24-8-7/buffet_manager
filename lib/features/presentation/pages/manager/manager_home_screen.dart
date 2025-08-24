import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/utils/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/sales_stats_widgets.dart';


class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({super.key});

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    Provider.of<SalesProvider>(context, listen: false).loadSalesData();
    Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: ResponsiveHelper.shouldShowSidebar(context)
          ? null
          : const AppDrawer(currentRoute: '/manager_home'),
      body: ResponsiveHelper.isDesktop(context)
          ? _buildDesktopLayout(context)
          : _buildMobileLayout(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('لوحة التحكم'),
              Text(
                'مرحباً ${authProvider.currentUser?.username ?? ''}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.9), // ✅ تم التصحيح
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // TODO: إضافة الإشعارات
          },
          tooltip: 'الإشعارات',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        if (ResponsiveHelper.shouldShowSidebar(context))
          SizedBox(
            width: ResponsiveHelper.getSidebarWidth(context),
            child: const AppDrawer(currentRoute: '/manager_home'),
          ),
        Expanded(
          child: _buildDashboardContent(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return _buildDashboardContent(context);
  }

  Widget _buildDashboardContent(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقات الإحصائيات الرئيسية
          _buildStatsCards(context),

          SizedBox(height: AppConstants.paddingL), // ✅ تم التصحيح

          // الرسوم البيانية والتقارير
          if (ResponsiveHelper.isDesktop(context))
            _buildChartsSection(context)
          else
            _buildMobileChartsSection(context),

          SizedBox(height: AppConstants.paddingL), // ✅ تم التصحيح

          // الأنشطة الأخيرة
          _buildRecentActivities(context),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    return Consumer2<SalesProvider, ProductProvider>(
      builder: (context, salesProvider, productProvider, child) {
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
            title: 'إجمالي المنتجات',
            value: '${productProvider.products.length}',
            subtitle: 'منتج متاح',
            icon: Icons.inventory,
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

  Widget _buildChartsSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // رسم بياني للمبيعات اليومية
        Expanded(
          flex: 2,
          child: _buildSalesChart(context),
        ),

        SizedBox(width: AppConstants.paddingL), // ✅ تم التصحيح

        // رسم دائري للفئات
        Expanded(
          child: _buildCategoriesChart(context),
        ),
      ],
    );
  }

  Widget _buildMobileChartsSection(BuildContext context) {
    return Column(
      children: [
        _buildSalesChart(context),
        SizedBox(height: AppConstants.paddingL), // ✅ تم التصحيح
        _buildCategoriesChart(context),
      ],
    );
  }

  Widget _buildSalesChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingL), // ✅ تم التصحيح
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مبيعات آخر 7 أيام',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppConstants.paddingL), // ✅ تم التصحيح
            SizedBox(
              height: 200,
              child: Consumer<SalesProvider>(
                builder: (context, salesProvider, child) {
                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 1,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppColors.divider, // ✅ تم التصحيح
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: AppColors.divider, // ✅ تم التصحيح
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                color: AppColors.textSecondary, // ✅ تم التصحيح
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              );
                              Widget text;
                              switch (value.toInt()) {
                                case 0:
                                  text = const Text('السبت', style: style);
                                  break;
                                case 1:
                                  text = const Text('الأحد', style: style);
                                  break;
                                case 2:
                                  text = const Text('الاثنين', style: style);
                                  break;
                                case 3:
                                  text = const Text('الثلاثاء', style: style);
                                  break;
                                case 4:
                                  text = const Text('الأربعاء', style: style);
                                  break;
                                case 5:
                                  text = const Text('الخميس', style: style);
                                  break;
                                case 6:
                                  text = const Text('الجمعة', style: style);
                                  break;
                                default:
                                  text = const Text('', style: style);
                                  break;
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: text,
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: AppColors.textSecondary, // ✅ تم التصحيح
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              );
                            },
                            reservedSize: 42,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: AppColors.divider), // ✅ تم التصحيح
                      ),
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: 10,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _generateSampleData(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary, // ✅ تم التصحيح
                              AppColors.primary.withOpacity(0.3), // ✅ تم التصحيح
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: AppColors.primary, // ✅ تم التصحيح
                                strokeWidth: 2,
                                strokeColor: Theme.of(context).colorScheme.surface, // ✅ تم التصحيح (استخدم surface بدلًا من thirdColor)
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.3), // ✅ تم التصحيح
                                AppColors.primary.withOpacity(0.1), // ✅ تم التصحيح
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingL), // ✅ تم التصحيح
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المبيعات حسب الفئة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppConstants.paddingL), // ✅ تم التصحيح
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      // TODO: إضافة تفاعل مع الرسم الدائري
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _generatePieChartSections(),
                ),
              ),
            ),
            SizedBox(height: AppConstants.paddingM), // ✅ تم التصحيح
            _buildPieChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartLegend() {
    final categories = [
      {'name': 'مشروبات', 'color': AppColors.primary, 'percentage': '35%'}, // ✅ تم التصحيح
      {'name': 'وجبات', 'color': AppColors.secondary, 'percentage': '40%'}, // ✅ تم التصحيح
      {'name': 'حلويات', 'color': AppColors.success, 'percentage': '15%'}, // ✅ تم التصحيح
      {'name': 'أخرى', 'color': Theme.of(context).colorScheme.secondary, 'percentage': '10%'}, // ✅ تم التصحيح
    ];

    return Column(
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: category['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category['name'] as String,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                category['percentage'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingL), // ✅ تم التصحيح
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'الأنشطة الأخيرة',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/sales');
                  },
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            SizedBox(height: AppConstants.paddingM), // ✅ تم التصحيح
            Consumer<SalesProvider>(
              builder: (context, salesProvider, child) {
                final recentSales =
                salesProvider.getTodaySales().take(5).toList();

                if (recentSales.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppConstants.paddingL), // ✅ تم التصحيح
                      child: Text(
                        'لا توجد مبيعات اليوم',
                        style: TextStyle(color: AppColors.textSecondary), // ✅ تم التصحيح
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentSales.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final sale = recentSales[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1), // ✅ تم التصحيح
                        child: const Icon(
                          Icons.receipt,
                          color: AppColors.primary, // ✅ تم التصحيح
                        ),
                      ),
                      title: Text('فاتورة #${sale.id}'),
                      subtitle: Text(
                        'الكاشير: ${sale.cashierName ?? 'غير محدد'}',
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            sale.formattedTotal,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              color: AppColors.primary, // ✅ تم التصحيح
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            sale.formattedTime,
                            style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary, // ✅ تم التصحيح
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSampleData() {
    // بيانات تجريبية للرسم البياني
    return [
      const FlSpot(0, 3),
      const FlSpot(1, 5),
      const FlSpot(2, 4),
      const FlSpot(3, 7),
      const FlSpot(4, 6),
      const FlSpot(5, 8),
      const FlSpot(6, 5),
    ];
  }

  List<PieChartSectionData> _generatePieChartSections() {
    return [
      PieChartSectionData(
        color: AppColors.primary, // ✅ تم التصحيح
        value: 35,
        title: '35%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white, // ✅ تم التصحيح (استخدم white بدلًا من textLight)
        ),
      ),
      PieChartSectionData(
        color: AppColors.secondary, // ✅ تم التصحيح
        value: 40,
        title: '40%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white, // ✅ تم التصحيح
        ),
      ),
      PieChartSectionData(
        color: AppColors.success, // ✅ تم التصحيح
        value: 15,
        title: '15%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white, // ✅ تم التصحيح
        ),
      ),
      PieChartSectionData(
        color: Theme.of(context).colorScheme.secondary, // ✅ تم التصحيح
        value: 10,
        title: '10%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white, // ✅ تم التصحيح
        ),
      ),
    ];
  }
}
