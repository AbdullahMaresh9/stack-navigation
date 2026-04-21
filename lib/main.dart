import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: ProductListScreen(),
    );
  }
}

// void main() {
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//         scaffoldBackgroundColor: Colors.grey[100],
//       ),
//       home: ProductListScreen(),
//     ),
//   );
// }

// ================= 1. شاشة قائمة المنتجات =================
class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // قائمة وهمية للمنتجات
  final List<Map<String, String>> products = [
    {"name": "حاسوب محمول Pro", "icon": "laptop_mac", "price": "1200\$"},
    {"name": "سماعات لاسلكية", "icon": "headphones", "price": "150\$"},
    {"name": "ساعة ذكية", "icon": "watch", "price": "200\$"},
    {"name": "هاتف ذكي Ultra", "icon": "smartphone", "price": "999\$"},
  ];

  // دالة مخصصة لفتح شاشة التفاصيل وانتظار النتيجة
  Future<void> _openProductDetails(
    BuildContext context,
    String productName,
  ) async {
    // 1. الانتقال وتمرير اسم المنتج (Push + Data)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productName: productName),
      ),
    );

    // 2. التحقق من أن الشاشة الحالية لا تزال موجودة (لتفادي أخطاء الـ Async)
    if (!context.mounted) return;

    // 3. عرض النتيجة إذا لم تكن فارغة (Pop + Result)
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(result.toString(), style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating, // لجعل الإشعار يطفو بشكل جميل
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "متجر الإلكترونيات",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.teal.withOpacity(0.2),
                child: Icon(Icons.shopping_bag, color: Colors.teal),
              ),
              title: Text(
                product["name"]!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("السعر: ${product["price"]}"),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Colors.teal,
                ),
                child: Text(
                  "عرض التفاصيل",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  // استدعاء الدالة وتمرير اسم المنتج
                  _openProductDetails(context, product["name"]!);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================= 2. شاشة تفاصيل المنتج =================
class ProductDetailScreen extends StatelessWidget {
  final String productName;

  // استقبال البيانات عبر الـ Constructor
  const ProductDetailScreen({Key? key, required this.productName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تفاصيل المنتج")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_border_purple500, size: 100, color: Colors.amber),
              SizedBox(height: 20),
              Text(
                productName, // عرض اسم المنتج المُمرر
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "هذا المنتج من أفضل المبيعات لدينا، يتميز بجودة عالية وضمان شامل.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 40),
              // زر الإضافة للمفضلة
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.favorite),
                  label: Text(
                    "إضافة إلى المفضلة",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // إغلاق الشاشة وإرجاع النتيجة (Pop + Result)
                    Navigator.pop(
                      context,
                      "تمت إضافة '$productName' إلى المفضلة بنجاح! 💖",
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
