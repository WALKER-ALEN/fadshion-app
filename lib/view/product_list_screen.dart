import 'package:fashn_app/view/product_detail_screen.dart';
import 'package:fashn_app/view/widgets/constants.dart';
import 'package:fashn_app/viewmodel/product_list_notifier.dart';
import 'package:flutter/foundation.dart';
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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _searchController = TextEditingController();
    final ScrollController _scrollController = ScrollController();
    final productsAsyncValue = ref.watch(productListProvider);
    final FocusNode _focusNode = FocusNode();

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

    // void initState() {

    //   _scrollController.addListener(() {

    //   });
    // }

    void _focusSearchBar() {
      if (_scrollController.hasClients) {
        _scrollController
            .animateTo(
          150.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
            .then((_) {
          Future.delayed(Duration(milliseconds: 300), () {
            FocusScope.of(context).requestFocus(_focusNode);
          });
        });
      } else {
        print('ScrollController is not attached to any scroll views.');
      }
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            centerTitle: true,
            titleSpacing: 30,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'FLiCshoP',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
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
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintTextDirection: TextDirection.ltr,
                      hintText: 'Search...',
                      filled: true,
                      fillColor: AppColors.SearchBarColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    autofocus: false, // Disable autofocus initially
                  ),
                ),
                titlePadding: EdgeInsets.all(0),
              ),
            ),
            backgroundColor: AppColors.appBarColor,

            // title: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     'CATELOG',
            //     style: TextStyle(fontSize: 25),
            //   ),
            // ),
            // pinned: true,
            // floating: true,
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.only(left: 8),
            //     child: IconButton(
            //         icon: Icon(
            //           Icons.favorite_border_outlined,
            //           size: 28,
            //           color: Colors.redAccent,
            //         ),
            //         onPressed: () {}),
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.only(right: 8),
            //     child: IconButton(
            //         icon: Icon(
            //           Ionicons.notifications_outline,
            //           size: 28,
            //         ),
            //         onPressed: () {}),
            //   ),
            // ],
            // expandedHeight: 150.0,
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${totalProducts} results',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      DropdownButton<String>(
                        value: selectedCategory,
                        hint: Text('Select a category'),
                        onChanged: onCategoryChanged,
                        items: categories.map((String category) {
                          return DropdownMenuItem(
                              child: Text(category), value: category);
                        }).toList(),
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.filter_list)),
                      IconButton(
                          onPressed: () {
                            _focusSearchBar();
                          },
                          icon: Icon(Ionicons.search))
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
                        margin: EdgeInsets.all(10.0),
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
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.GridCardTextColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '\$${product.price}',
                                  style: TextStyle(
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
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.GridCardTextColor),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.75,
                  ),
                )
              : SliverFillRemaining(
                  child: Center(child: Text('No products found')),
                ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.blueGrey[100],
              padding: EdgeInsets.all(16.0),
              child: Text('Additional Content Here'),
            ),
          ),
        ],
      ),
    );
  }
}
