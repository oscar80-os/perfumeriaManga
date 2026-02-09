import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PerfumeriaApp());
}

class PerfumeriaApp extends StatelessWidget {
  const PerfumeriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfumería Colombia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String whatsappUrl =
      'https://wa.me/573001234567?text=Hola,%20me%20interesan%20sus%20productos';

  final List<Map<String, String>> products = [
    {
      'name': 'Perfume Floral',
      'price': '\$89.900',
      'image': 'assets/images/products/perfume1.jpg',
    },
    {
      'name': 'Loción Corporal',
      'price': '\$45.900',
      'image': 'assets/images/products/locion1.jpg',
    },
    {
      'name': 'Set de Maquillaje',
      'price': '\$129.900',
      'image': 'assets/images/products/maquillaje1.jpg',
    },
  ];

  String searchText = '';

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
        .where((p) =>
            p['name']!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        onPressed: () => _openUrl(whatsappUrl),
        child: Image.asset(
          'assets/images/icons/whatsapp.png',
          height: 28,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/images/icons/logo.png',
                  height: 90,
                ),
              ),

              // Búsqueda
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (value) {
                    setState(() => searchText = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar perfume...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Categorías
              SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CategoryItem(name: 'Perfumes', icon: Icons.spa),
                    CategoryItem(name: 'Lociones', icon: Icons.liquor),
                    CategoryItem(name: 'Maquillaje', icon: Icons.brush),
                    CategoryItem(name: 'Facial', icon: Icons.face),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Productos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Productos destacados',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...filteredProducts.map(
                      (p) => ProductCard(
                        name: p['name']!,
                        price: p['price']!,
                        image: p['image']!,
                        onTap: () => _openUrl(whatsappUrl),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Redes sociales
              Column(
                children: [
                  const Text(
                    'Síguenos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon:
                            Image.asset('assets/images/icons/facebook.png'),
                        onPressed: () =>
                            _openUrl('https://facebook.com/tuperfumeria'),
                      ),
                      IconButton(
                        icon:
                            Image.asset('assets/images/icons/instagram.png'),
                        onPressed: () =>
                            _openUrl('https://instagram.com/tuperfumeria'),
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/icons/tiktok.png'),
                        onPressed: () =>
                            _openUrl('https://tiktok.com/@tuperfumeria'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String name;
  final IconData icon;

  const CategoryItem({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.pink.shade100,
            child: Icon(icon, color: Colors.pink),
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(image)),
        title: Text(name),
        subtitle: Text(price),
        trailing: IconButton(
          icon: const Icon(Icons.chat),
          onPressed: onTap,
        ),
      ),
    );
  }
}
