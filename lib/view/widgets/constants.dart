// productsAsyncValue.when(
//   data: (products) => SliverList(
//     delegate: SliverChildBuilderDelegate(
//       (context, index) {
//         final product = products[index];
//         return Column(
//           children: [
//             // ListTile(
//             //   leading: Image.network(product.image),
//             //   title: Text(product.title),
//             //   subtitle:
//             //       Text('\$${product.price} - ${product.category}'),
//             //   trailing: Text(
//             //       '${product.rating.rate} (${product.rating.count} reviews)'),
//             //   onTap: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (context) =>
//             //             ProductDetailScreen(productId: product.id),
//             //       ),
//             //     );
//             //   },
//             // ),

//           ],
//         );
//       },
//       childCount: products.length,
//     ),
//   ),
//   loading: () => SliverFillRemaining(
//     child: Center(child: CircularProgressIndicator()),
//   ),
//   error: (error, stack) => SliverFillRemaining(
//     child: Center(child: Text('Error: $error')),Color(0XFFFBCF84)
//   ),Color(0xFFB2C8ED)
// ),Color(0xFFF2F8FC)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Define static color variables
  static const Color primaryBackground = Color(0XFFFFFFFF);
  static const Color appBarColor = Color(0XFFA7ED10);
  static const Color GridCardColor = Color(0XFF000000);
  static const Color SearchBarColor = Color(0XFFB5B5B5);
  static const Color GridCardTextColor = Color(0XFFFFFFFF);
  // Add more colors as needed
}

class AppFonts {
  static TextStyle regular({
    double fontSize = 16.0,
    Color color = Colors.black,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle bold({
    double fontSize = 16.0,
    Color color = Colors.black,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle italic({
    double fontSize = 16.0,
    Color color = Colors.black,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      color: color,
      fontStyle: FontStyle.italic,
    );
  }
}
