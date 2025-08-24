import '../../../../core/imports/all_imports.dart';

class CashierHomeScreen extends StatefulWidget {
  const CashierHomeScreen({super.key});

  @override
  State<CashierHomeScreen> createState() => _CashierHomeScreenState();
}

class _CashierHomeScreenState extends State<CashierHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: ResponsiveHelper.shouldShowSidebar(context)
          ? null
          : const CashierDashboard(currentRoute: '/cashier_home'),
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
              const Text('نقطة البيع'),
              Text(
                'مرحباً ${authProvider.currentUser?.username ?? ''}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.9), // ✅ تم التصحيح
                    ),
              ),
            ],
          );
        },
      ),
      actions: [
        Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => _showCartBottomSheet(context),
                ),
                if (cartProvider.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.error, // ✅ تم التصحيح
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cartProvider.itemCount}',
                        style: const TextStyle(
                          color: Colors
                              .white, // ✅ تم التصحيح (استخدم white بدلًا من textLight)
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
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
            child: const CashierDashboard(currentRoute: '/cashier_home'),
          ),

        // المحتوى الرئيسي
        Expanded(
          flex: 2,
          child: _buildProductsGrid(context),
        ),

        // سلة التسوق الجانبية
        const SizedBox(
          width: 350,
          child: CartSidebar(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return _buildProductsGrid(context);
  }

  Widget _buildProductsGrid(BuildContext context) {
    return Column(
      children: [
        // شريط البحث والفلترة
        _buildSearchAndFilter(context),
        Expanded(
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.products.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: AppColors.textSecondary, // ✅ تم التصحيح
                      ),
                      SizedBox(height: 16),
                      Text(
                        'لا توجد منتجات متاحة',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondary, // ✅ تم التصحيح
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: ResponsiveHelper.getResponsivePadding(context),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.getGridColumns(context),
                  crossAxisSpacing: ResponsiveHelper.getSpacing(context),
                  mainAxisSpacing: ResponsiveHelper.getSpacing(context),
                  childAspectRatio:
                      ResponsiveHelper.getCardAspectRatio(context),
                ),
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  return ProductCard(
                    product: product,
                    showAddToCart: true,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM), // ✅ تم التصحيح
      decoration: BoxDecoration(
        // ✅ تم التصحيح (استبدل const ب BoxDecoration)
        color: Theme.of(context)
            .colorScheme
            .surface, // ✅ تم التصحيح (استخدم surface بدلًا من thirdColor)
        border: const Border(
          bottom: BorderSide(color: AppColors.divider), // ✅ تم التصحيح
        ),
      ),
      child: Column(
        children: [
          // شريط البحث
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'البحث عن منتج...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        Provider.of<ProductProvider>(context, listen: false)
                            .searchProducts('');
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              Provider.of<ProductProvider>(context, listen: false)
                  .searchProducts(value);
            },
          ),
          const SizedBox(height: AppConstants.paddingM), // ✅ تم التصحيح
          // فلتر الفئات
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = productProvider.categories[index];
                    final isSelected =
                        productProvider.selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: AppConstants.paddingS), // ✅ تم التصحيح
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          productProvider.filterByCategory(category);
                        },
                        selectedColor:
                            AppColors.primary.withOpacity(0.2), // ✅ تم التصحيح
                        checkmarkColor: AppColors.primary, // ✅ تم التصحيح
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            // ✅ تم التصحيح (استبدل const ب BoxDecoration)
            color: Theme.of(context).colorScheme.surface, // ✅ تم التصحيح
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.radiusL), // ✅ تم التصحيح
              topRight: Radius.circular(AppConstants.radiusL), // ✅ تم التصحيح
            ),
          ),
          child: Column(
            children: [
              // مقبض السحب
              Container(
                margin: const EdgeInsets.only(
                    top: AppConstants.paddingS), // ✅ تم التصحيح
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      AppColors.textSecondary.withOpacity(0.3), // ✅ تم التصحيح
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // عنوان السلة
              Padding(
                padding:
                    const EdgeInsets.all(AppConstants.paddingM), // ✅ تم التصحيح
                child: Text(
                  'سلة التسوق',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              // محتوى السلة
              Expanded(
                child: CartSidebar(
                  scrollController: scrollController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
