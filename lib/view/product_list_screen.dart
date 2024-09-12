import 'package:fashn_app/view/product_detail_screen.dart';
import 'package:fashn_app/view/widgets/constants.dart';
import 'package:fashn_app/viewmodel/product_list_notifier.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';

const List<String> categories = [
  'All',
  'Electronics',
  'Clothing',
  'Home Appliances',
  'Books',
  'Sports',
];

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController searchController = TextEditingController();
    final ScrollController scrollController = ScrollController();
    final productsAsyncValue = ref.watch(productListProvider);
    final FocusNode focusNode = FocusNode();

    final selectedCategory = ref.watch(selectedCategoryProvider);

    void onCategoryChanged(String? newCategory) {
      if (newCategory != null) {
        ref.read(selectedCategoryProvider.notifier).state = newCategory;
      }
    }

    final totalProducts = productsAsyncValue.when(
      data: (products) => products.length,
      loading: () => 0,
      error: (error, stack) => 0,
    );

    final filteredProducts = productsAsyncValue.when(
      data: (products) {
        if (selectedCategory == 'All') return products;
        return products
            .where((product) => product.category == selectedCategory)
            .toList();
      },
      loading: () => [],
      error: (error, stack) => [],
    );

    Future<void> onRefresh() async {
      // Logic to refresh the product list. This will trigger a new fetch of the product list.
      await ref.refresh(productListProvider);
    }

    void focusSearchBar() {
      if (scrollController.hasClients) {
        scrollController
            .animateTo(
          150.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
            .then((_) {
          Future.delayed(const Duration(milliseconds: 300), () {
            FocusScope.of(context).requestFocus(focusNode);
          });
        });
      } else {
        print('ScrollController is not attached to any scroll views.');
      }
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              centerTitle: true,
              titleSpacing: 30,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'FLiCshoP',
                  // style: TextStyle(
                  //     fontSize: 25,
                  //     fontWeight: FontWeight.bold,
                  //     fontStyle: FontStyle.italic),
                  style: AppFonts.bold(),
                ),
              ),
              pinned: true,
              expandedHeight: 200.0,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 40, left: 10, right: 10),
                child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  title: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      focusNode: focusNode,
                      controller: searchController,
                      decoration: InputDecoration(
                        hintStyle: AppFonts.regular(),
                        hintTextDirection: TextDirection.ltr,
                        hintText: 'Search...',
                        filled: true,
                        fillColor: AppColors.SearchBarColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      autofocus: false, // Disable autofocus initially
                    ),
                  ),
                  titlePadding: const EdgeInsets.all(0),
                ),
              ),
              backgroundColor: AppColors.appBarColor,
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('$totalProducts results',
                        style: AppFonts.bold(fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        DropdownButton<String>(
                          value: selectedCategory,
                          hint: const Text('Select a category'),
                          onChanged: onCategoryChanged,
                          items: categories.map((String category) {
                            return DropdownMenuItem(
                                value: category, child: Text(category));
                          }).toList(),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_list)),
                        IconButton(
                            onPressed: () {
                              focusSearchBar();
                            },
                            icon: const Icon(Ionicons.search))
                      ],
                    ),
                  )
                ],
              ),
            ),
            filteredProducts.isNotEmpty
                ? SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = filteredProducts[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: AppColors.GridCardColor,
                          margin: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                        productId: product.id)),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product.title,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.GridCardTextColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    '\$${product.price}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.GridCardTextColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${product.rating.rate} (${product.rating.count} reviews)',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.GridCardTextColor),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: AppColors.GridCardTextColor,
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: filteredProducts.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.75,
                    ),
                  )
                : const SliverFillRemaining(
                    child: Center(child: Text('No products found')),
                  ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.blueGrey[100],
                padding: const EdgeInsets.all(16.0),
                child: const Center(child: Text('...T&C Apply...')),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: AppColors.GridCardColor,
        padding: EdgeInsetsDirectional.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.home_filled,
                  color: AppColors.GridCardTextColor,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.explore,
                  color: AppColors.GridCardTextColor,
                )),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Ionicons.cart,
                  color: AppColors.GridCardTextColor,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.account_circle,
                  color: AppColors.GridCardTextColor,
                )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.GridCardColor,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {},
        child: Text(
          'F',
          style: AppFonts.italic(
            color: AppColors.GridCardTextColor,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
