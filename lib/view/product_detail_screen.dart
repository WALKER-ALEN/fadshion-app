import 'package:fashn_app/view/widgets/constants.dart';
import 'package:fashn_app/viewmodel/product_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsyncValue = ref.watch(productDetailProvider(productId));

    return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          title: Text(''),
        ),
        body: productAsyncValue.when(
          data: (product) => product == null
              ? Center(child: Text('Product not found'))
              : SingleChildScrollView(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(product.image),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  product.title,
                                  // style: TextStyle(
                                  //     fontSize: 22,
                                  //     fontStyle: FontStyle.italic,
                                  //     fontWeight: FontWeight.bold)
                                  // style: GoogleFonts.aBeeZee(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.bold)
                                  style: AppFonts.bold(fontSize: 25),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.share,
                                    color: AppColors.GridCardColor,
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "\$${product.price}",
                          style: AppFonts.bold(fontSize: 25),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Customer ratings :${product.rating.rate}",
                          style: AppFonts.italic(),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "Total reviews : ${product.rating.count}",
                          style: AppFonts.regular(),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Product Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),

                        SizedBox(height: 16.0),

                        Text(product.description),

                        // Image.network(product.image),
                        // SizedBox(height: 16.0),
                        // Text(product.title,
                        //     style: Theme.of(context).textTheme.headlineSmall),
                        // SizedBox(height: 8.0),
                        // Text('\$${product.price}',
                        //     style: Theme.of(context).textTheme.titleLarge),
                        // SizedBox(height: 8.0),
                        // Text('Category: ${product.category}'),
                        // SizedBox(height: 8.0),
                        // Text(
                        //     'Rating: ${product.rating.rate} (${product.rating.count} reviews)'),
                        // SizedBox(height: 16.0),
                        // Text(product.description),
                      ],
                    ),
                  ),
                ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: double.infinity,
                  child: TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.appBarColor),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {},
                    label: Text(
                      'Add to cart',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.GridCardColor),
                    ),
                    icon: Icon(
                      Icons.shopping_cart,
                      color: AppColors.SearchBarColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.GridCardColor),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {},
                    child: Text(
                      'Buy Now',
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.GridCardTextColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
