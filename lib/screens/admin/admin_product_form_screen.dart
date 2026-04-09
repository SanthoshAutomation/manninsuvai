import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/products_provider.dart';
import '../../theme/app_theme.dart';

/// Add a new product or edit an existing one.
class AdminProductFormScreen extends StatefulWidget {
  final Product? product; // null → add mode

  const AdminProductFormScreen({super.key, this.product});

  @override
  State<AdminProductFormScreen> createState() => _AdminProductFormScreenState();
}

class _AdminProductFormScreenState extends State<AdminProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Basic info controllers
  late final TextEditingController _nameCtrl;
  late final TextEditingController _subtitleCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _emojiCtrl;
  late final TextEditingController _badgeCtrl;

  ProductCategory _category = ProductCategory.healthMix;
  bool _inStock = true;
  bool _isPreBooking = false;

  // Variants
  late List<_VariantRow> _variants;

  // Highlights / Ingredients (one per line)
  late final TextEditingController _highlightsCtrl;
  late final TextEditingController _ingredientsCtrl;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _subtitleCtrl = TextEditingController(text: p?.subtitle ?? '');
    _descriptionCtrl = TextEditingController(text: p?.description ?? '');
    _emojiCtrl = TextEditingController(text: p?.imageEmoji ?? '📦');
    _badgeCtrl = TextEditingController(text: p?.badge ?? '');
    _category = p?.category ?? ProductCategory.healthMix;
    _inStock = p?.inStock ?? true;
    _isPreBooking = p?.isPreBooking ?? false;
    _variants = (p?.variants ?? [
      ProductVariant(weight: '500 g', price: 0),
    ]).map((v) => _VariantRow.fromVariant(v)).toList();
    _highlightsCtrl = TextEditingController(text: (p?.highlights ?? []).join('\n'));
    _ingredientsCtrl = TextEditingController(text: (p?.ingredients ?? []).join('\n'));
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _subtitleCtrl, _descriptionCtrl, _emojiCtrl,
      _badgeCtrl, _highlightsCtrl, _ingredientsCtrl,
    ]) {
      c.dispose();
    }
    for (final v in _variants) v.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Text(
          _isEditing ? 'Edit Product' : 'Add Product',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'SAVE',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Basic Information'),
            _buildBasicInfoSection(),
            const SizedBox(height: 20),
            _sectionTitle('Category & Status'),
            _buildCategorySection(),
            const SizedBox(height: 20),
            _sectionTitle('Variants (Size & Price)'),
            _buildVariantsSection(),
            const SizedBox(height: 20),
            _sectionTitle('Highlights (one per line)'),
            _buildTextArea(_highlightsCtrl, 'e.g. Rich in Antioxidants\nNo Preservatives'),
            const SizedBox(height: 20),
            _sectionTitle('Ingredients (one per line)'),
            _buildTextArea(_ingredientsCtrl, 'e.g. Cashew Nuts\nAlmonds'),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.secondary,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                // Emoji picker
                GestureDetector(
                  onTap: _pickEmoji,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLighter,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _emojiCtrl.text.isEmpty ? '📦' : _emojiCtrl.text,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Product Name *'),
                    style: GoogleFonts.poppins(fontSize: 14),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _subtitleCtrl,
              decoration: const InputDecoration(labelText: 'Subtitle / Short Description'),
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(labelText: 'Full Description'),
              style: GoogleFonts.poppins(fontSize: 13),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _badgeCtrl,
              decoration: const InputDecoration(
                labelText: 'Badge (optional)',
                hintText: 'e.g. Bestseller, New, Popular',
              ),
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<ProductCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textDark),
              items: ProductCategory.values.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text('${cat.emoji} ${cat.displayName}'),
                );
              }).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text('In Stock', style: GoogleFonts.poppins(fontSize: 14)),
              subtitle: Text(
                _inStock ? 'Visible & available to buy' : 'Shown as out of stock',
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLight),
              ),
              value: _inStock,
              activeColor: AppColors.secondary,
              onChanged: (v) => setState(() => _inStock = v),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text('Pre-booking only', style: GoogleFonts.poppins(fontSize: 14)),
              value: _isPreBooking,
              activeColor: AppColors.preBook,
              onChanged: (v) => setState(() => _isPreBooking = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            ..._variants.asMap().entries.map((entry) {
              final i = entry.key;
              final row = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildVariantRow(i, row),
              );
            }),
            OutlinedButton.icon(
              onPressed: () => setState(() => _variants.add(_VariantRow())),
              icon: const Icon(Icons.add),
              label: Text('Add Size Variant', style: GoogleFonts.poppins()),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side: const BorderSide(color: AppColors.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantRow(int index, _VariantRow row) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.secondaryLighter,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: row.weight,
                  decoration: const InputDecoration(
                    labelText: 'Size / Weight',
                    hintText: '350 g',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: row.price,
                  decoration: const InputDecoration(
                    labelText: 'Price ₹',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: _variants.length > 1
                    ? () => setState(() {
                          row.dispose();
                          _variants.removeAt(index);
                        })
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: row.discount,
                  decoration: const InputDecoration(
                    labelText: 'Discount %',
                    hintText: '0',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text('In Stock', style: GoogleFonts.poppins(fontSize: 12)),
                  value: row.inStock,
                  activeColor: AppColors.secondary,
                  onChanged: (v) => setState(() => row.inStock = v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea(TextEditingController ctrl, String hint) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: TextFormField(
          controller: ctrl,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            hintStyle: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 13),
          ),
          style: GoogleFonts.poppins(fontSize: 13),
        ),
      ),
    );
  }

  void _pickEmoji() {
    showDialog(
      context: context,
      builder: (ctx) {
        final emojis = [
          '🍚', '🌾', '🫘', '🫓', '🌑', '🌿', '☕', '🍃',
          '🫖', '🌱', '🍯', '🎁', '🌸', '💛', '🌼', '🌹',
          '🌵', '🌺', '🎨', '👶', '✨', '🧒', '💐', '🌟',
          '📦', '🥗', '🫚', '🌻', '🍋', '🫑', '🥜', '🌰',
        ];
        return AlertDialog(
          title: Text('Pick an Emoji', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: emojis.map((e) => GestureDetector(
              onTap: () {
                setState(() => _emojiCtrl.text = e);
                Navigator.pop(ctx);
              },
              child: Text(e, style: const TextStyle(fontSize: 32)),
            )).toList(),
          ),
        );
      },
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final variants = _variants.map((row) {
      return ProductVariant(
        weight: row.weight.text.trim(),
        price: double.tryParse(row.price.text) ?? 0,
        discountPercent: double.tryParse(row.discount.text) ?? 0,
        inStock: row.inStock,
      );
    }).toList();

    final highlights = _highlightsCtrl.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final ingredients = _ingredientsCtrl.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final product = Product(
      id: widget.product?.id ??
          'p_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      subtitle: _subtitleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      category: _category,
      imageEmoji: _emojiCtrl.text.isEmpty ? '📦' : _emojiCtrl.text,
      badge: _badgeCtrl.text.trim().isEmpty ? null : _badgeCtrl.text.trim(),
      isPreBooking: _isPreBooking,
      inStock: _inStock,
      variants: variants,
      highlights: highlights,
      ingredients: ingredients,
    );

    final provider = context.read<ProductsProvider>();
    if (_isEditing) {
      provider.updateProduct(product);
    } else {
      provider.addProduct(product);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        _isEditing ? 'Product updated!' : 'Product added!',
        style: GoogleFonts.poppins(),
      ),
      backgroundColor: AppColors.secondary,
      behavior: SnackBarBehavior.floating,
    ));
  }
}

class _VariantRow {
  final TextEditingController weight;
  final TextEditingController price;
  final TextEditingController discount;
  bool inStock;

  _VariantRow({
    String? w,
    String? p,
    String? d,
    bool? stock,
  })  : weight = TextEditingController(text: w ?? ''),
        price = TextEditingController(text: p ?? ''),
        discount = TextEditingController(text: d ?? '0'),
        inStock = stock ?? true;

  factory _VariantRow.fromVariant(ProductVariant v) => _VariantRow(
        w: v.weight,
        p: v.price.toStringAsFixed(0),
        d: v.discountPercent.toStringAsFixed(0),
        stock: v.inStock,
      );

  void dispose() {
    weight.dispose();
    price.dispose();
    discount.dispose();
  }
}
