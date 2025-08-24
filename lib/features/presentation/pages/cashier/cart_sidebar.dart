import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../data/models/product.dart';
import '../../../data/services/print_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
class CartSidebar extends StatelessWidget {
  final ScrollController? scrollController;

  const CartSidebar({
    super.key,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: AppColors.divider), // ✅ تم التصحيح
            ),
          ),
          child: Column(
            children: [
              // رأس السلة
              _buildCartHeader(context, cartProvider),

              // قائمة العناصر
              Expanded(
                child: cartProvider.isEmpty
                    ? _buildEmptyCart(context)
                    : _buildCartItems(context, cartProvider),
              ),

              // ملخص السلة وأزرار الإجراءات
              if (!cartProvider.isEmpty)
                _buildCartSummary(context, cartProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartHeader(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider), // ✅ تم التصحيح
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shopping_cart,
            color: Theme.of(context).colorScheme.onSurface, // ✅ تم التصحيح
          ),
          const SizedBox(width: AppConstants.paddingS),
          Expanded(
            child: Text(
              'سلة التسوق',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (!cartProvider.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingS,
                vertical: AppConstants.paddingXS,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Text(
                '${cartProvider.itemCount}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface, // ✅ تم التصحيح
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            'السلة فارغة',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            'أضف منتجات لبدء عملية البيع',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, CartProvider cartProvider) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(AppConstants.paddingS),
      itemCount: cartProvider.cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartProvider.cartItems[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: AppConstants.paddingS),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المنتج والسعر
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cartItem.product.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      cartItem.product.formattedPrice,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.paddingS),

                // أزرار التحكم في الكمية
                Row(
                  children: [
                    // زر تقليل الكمية
                    IconButton(
                      onPressed: () =>
                          cartProvider.decreaseQuantity(cartItem.product),
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(32, 32),
                      ),
                    ),

                    // عرض الكمية
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingS),
                        padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.paddingS),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                        ),
                        child: Text(
                          '${cartItem.quantity}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // زر زيادة الكمية
                    IconButton(
                      onPressed: () =>
                          cartProvider.increaseQuantity(cartItem.product),
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(32, 32),
                      ),
                    ),

                    // زر الحذف
                    IconButton(
                      onPressed: () =>
                          cartProvider.removeFromCart(cartItem.product),
                      icon: const Icon(Icons.delete),
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.error,
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.paddingS),

                // الإجمالي للعنصر
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingM,
                    vertical: AppConstants.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: Text(
                    'الإجمالي: ${cartItem.formattedTotalPrice}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartSummary(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: const Border(
          top: BorderSide(color: AppColors.divider),
        ),
        boxShadow: [
          const BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ملخص الإجمالي
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الإجمالي الكلي:',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  cartProvider.formattedTotalPrice,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.paddingM),

          // أزرار الإجراءات
          Row(
            children: [
              // زر مسح السلة
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showClearCartDialog(context, cartProvider),
                  icon: const Icon(Icons.clear_all),
                  label: const Text('مسح الكل'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.paddingS),
              // زر إتمام البيع
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _completeSale(context, cartProvider),
                  icon: const Icon(Icons.payment),
                  label: const Text('إتمام البيع'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح السلة'),
        content:
        const Text('هل أنت متأكد من رغبتك في مسح جميع العناصر من السلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              cartProvider.clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم مسح السلة بنجاح'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  void _completeSale(BuildContext context, CartProvider cartProvider) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final cashierName = authProvider.currentUser?.username;

      // إتمام البيع
      final saleId = await cartProvider.completeSale(cashierName, null);

      if (saleId != null && context.mounted) {
        // طباعة الفاتورة
        await PrintService.printInvoice(
          cartProvider.cartItems,
          cartProvider.totalPrice,
          DateTime.now(),
          cashierName: cashierName,
          invoiceNumber: saleId,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إتمام البيع بنجاح وطباعة الفاتورة'),
            backgroundColor: AppColors.success,
          ),
        );

        // إغلاق الـ bottom sheet إذا كان مفتوحاً
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء إتمام البيع: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final bool showAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
    this.showAddToCart = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItem = cartProvider.getCartItem(product);
        final quantity = cartItem?.quantity ?? 0;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusL), // ✅ تم التصحيح
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppConstants.radiusL), // ✅ تم التصحيح
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // صورة المنتج
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.radiusL), // ✅ تم التصحيح
                        topRight: Radius.circular(AppConstants.radiusL), // ✅ تم التصحيح
                      ),
                      color: Color(0xFFF5F5F5), // ✅ تم التصحيح (استخدم surfaceLight أو surfaceDark حسب الثيم)
                    ),
                    child: product.image != null && product.image!.isNotEmpty
                        ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.radiusL), // ✅ تم التصحيح
                        topRight: Radius.circular(AppConstants.radiusL), // ✅ تم التصحيح
                      ),
                      child: Image.asset(
                        product.image!,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage(context); // ✅ أضفنا context
                        },
                        fit: BoxFit.cover,
                      ),
                    )
                        : _buildPlaceholderImage(context), // ✅ أضفنا context
                  ),
                ),

                // معلومات المنتج
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingM), // ✅ تم التصحيح
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // اسم المنتج
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: AppConstants.paddingXS), // ✅ تم التصحيح

                        // فئة المنتج
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingS, // ✅ تم التصحيح
                            vertical: AppConstants.paddingXS, // ✅ تم التصحيح
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppConstants.radiusS), // ✅ تم التصحيح
                          ),
                          child: Text(
                            product.category,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const Spacer(),
                        // السعر
                        Text(
                          product.formattedPrice,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // أزرار الإجراءات
                if (showActions || showAddToCart)
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingS), // ✅ تم التصحيح
                    decoration: const BoxDecoration( // ✅ تم التصحيح (استبدل const ب BoxDecoration)
                      border: Border(
                        top: BorderSide(color: AppColors.divider), // ✅ تم التصحيح
                      ),
                    ),
                    child: showActions
                        ? _buildActionButtons(context)
                        : _buildCartControls(context, cartProvider, quantity),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) { // ✅ أضفنا context
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // ✅ تم التصحيح
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusL), // ✅ تم التصحيح
          topRight: Radius.circular(AppConstants.radiusL), // ✅ تم التصحيح
        ),
      ),
      child: Icon(
        Icons.restaurant,
        size: 48,
        color: Theme.of(context).colorScheme.onSurface, // ✅ تم التصحيح
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('تعديل'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface, // ✅ تم التصحيح
              side: BorderSide(color: Theme.of(context).colorScheme.outline), // ✅ تم التصحيح
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.paddingS), // ✅ تم التصحيح
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, size: 16),
            label: const Text('حذف'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartControls(
      BuildContext context, CartProvider cartProvider, int quantity) {
    if (quantity == 0) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => cartProvider.addToCart(product),
          icon: const Icon(Icons.add_shopping_cart, size: 16),
          label: const Text('إضافة للسلة'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      );
    }

    return Row(
      children: [
        // زر تقليل الكمية
        IconButton(
          onPressed: () => cartProvider.decreaseQuantity(product),
          icon: const Icon(Icons.remove),
          style: IconButton.styleFrom(
            minimumSize: const Size(32, 32),
          ),
        ),

        // عرض الكمية
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface, // ✅ تم التصحيح
              borderRadius: BorderRadius.circular(AppConstants.radiusS), // ✅ تم التصحيح
            ),
            child: Text(
              '$quantity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // زر زيادة الكمية
        IconButton(
          onPressed: () => cartProvider.increaseQuantity(product),
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            minimumSize: const Size(32, 32),
          ),
        ),
      ],
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;
  final Widget? trailing;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary; // ✅ تم التصحيح (primary بدلًا من primaryColor)
    final isMobile = ResponsiveHelper.isMobile(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL), // ✅ تم التصحيح
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusL), // ✅ تم التصحيح
        child: Container(
          padding: EdgeInsets.all(
            isMobile ? AppConstants.paddingM : AppConstants.paddingL, // ✅ تم التصحيح
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusL), // ✅ تم التصحيح
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardColor.withOpacity(0.1),
                cardColor.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي - الأيقونة والعنوان
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingS), // ✅ تم التصحيح
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppConstants.radiusM), // ✅ تم التصحيح
                    ),
                    child: Icon(
                      icon,
                      color: cardColor,
                      size: ResponsiveHelper.getIconSize(context),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM), // ✅ تم التصحيح
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface, // ✅ تم التصحيح (onSurface بدلًا من textSecondary)
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),

              const SizedBox(height: AppConstants.paddingM), // ✅ تم التصحيح

              // القيمة الرئيسية
              Text(
                value,
                style: textTheme.displayMedium?.copyWith( // ✅ تم التصحيح (displayMedium بدلًا من headlineMedium)
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    28,
                  ),
                ),
              ),

              // النص الفرعي
              if (subtitle != null) ...[
                const SizedBox(height: AppConstants.paddingXS), // ✅ تم التصحيح
                Text(
                  subtitle!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface, // ✅ تم التصحيح
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// بطاقة إحصائيات مبسطة للشاشات الصغيرة
class CompactStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const CompactStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary; // ✅ تم التصحيح (primary بدلًا من primaryColor)
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM), // ✅ تم التصحيح
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusM), // ✅ تم التصحيح
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingM), // ✅ تم التصحيح
          child: Row(
            children: [
              // الأيقونة
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingS), // ✅ تم التصحيح
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS), // ✅ تم التصحيح
                ),
                child: Icon(
                  icon,
                  color: cardColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: AppConstants.paddingM), // ✅ تم التصحيح

              // النص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                    Text(
                      title,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface, // ✅ تم التصحيح (onSurface بدلًا من textSecondary)
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// بطاقة إحصائيات مع رسم بياني صغير
class ChartStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final Widget? chart;
  final VoidCallback? onTap;

  const ChartStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
    this.chart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary; // ✅ تم التصحيح (primary بدلًا من primaryColor)
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final iconSize = ResponsiveHelper.getIconSize(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL), // ✅ تم التصحيح
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusL), // ✅ تم التصحيح
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingL), // ✅ تم التصحيح
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي
              Row(
                children: [
                  Icon(
                    icon,
                    color: cardColor,
                    size: iconSize, // ✅ تم التصحيح
                  ),
                  const SizedBox(width: AppConstants.paddingS), // ✅ تم التصحيح
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface, // ✅ تم التصحيح (onSurface بدلًا من textSecondary)
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingM), // ✅ تم التصحيح

              // القيمة
              Text(
                value,
                style: textTheme.displayLarge?.copyWith( // ✅ تم التصحيح (displayLarge بدلًا من headlineLarge)
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: AppConstants.paddingXS), // ✅ تم التصحيح
                Text(
                  subtitle!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface, // ✅ تم التصحيح
                  ),
                ),
              ],

              // الرسم البياني
              if (chart != null) ...[
                const SizedBox(height: AppConstants.paddingM), // ✅ تم التصحيح
                SizedBox(
                  height: 60,
                  child: chart!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}