import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:myapp/services/bin_lookup_service.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formas de pago'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _PaymentCard(
            brand: 'Visa',
            lastDigits: '1234',
            holder: 'Juan Pérez',
            expiry: '08/26',
            gradient: LinearGradient(colors: [Color(0xFF5F0A87), Color(0xFFA4508B)]),
          ),
          SizedBox(height: 24),
          _PaymentCard(
            brand: 'Cuenta DNI',
            lastDigits: '9087',
            holder: 'Juan Pérez',
            expiry: 'Cuenta digital',
            gradient: LinearGradient(colors: [Color(0xFF1CB5E0), Color(0xFF000851)]),
          ),
          SizedBox(height: 24),
          _AddPaymentButton(),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.brand,
    required this.lastDigits,
    required this.holder,
    required this.expiry,
    required this.gradient,
  });

  final String brand;
  final String lastDigits;
  final String holder;
  final String expiry;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: gradient,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 28, offset: Offset(0, 18)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  brand,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.more_horiz, color: Colors.white70),
              ],
            ),
            const Spacer(),
            Text(
              '•••• $lastDigits',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Titular', style: TextStyle(color: Colors.white60)),
                      const SizedBox(height: 4),
                      Text(
                        holder,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Vence', style: TextStyle(color: Colors.white60)),
                    const SizedBox(height: 4),
                    Text(
                      expiry,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPaymentButton extends StatelessWidget {
  const _AddPaymentButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => const _AddCardSheet(),
        );
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Agregar nuevo método de pago'),
    );
  }
}

class _AddCardSheet extends StatefulWidget {
  const _AddCardSheet();

  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _numberCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _expiryCtrl;
  late final TextEditingController _cvvCtrl;
  late final FocusNode _cvvFocus;
  late final AnimationController _flipController;

  String? _pendingBin;
  CardBinInfo? _binInfo;
  _CardStyle _cardStyle = _CardStyleResolver.unknown;

  bool _isActivated = false;
  String _formattedNumber = '**** **** **** ****';
  String _holderDisplay = 'NOMBRE Y APELLIDO';
  String _formattedExpiry = 'MM/AA';
  String _cvvDisplay = '***';

  @override
  void initState() {
    super.initState();
    _numberCtrl = TextEditingController();
    _nameCtrl = TextEditingController();
    _expiryCtrl = TextEditingController();
    _cvvCtrl = TextEditingController();
    _cvvFocus = FocusNode();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _numberCtrl.addListener(_handleNumberChanged);
    _nameCtrl.addListener(_handleNameChanged);
    _expiryCtrl.addListener(_handleExpiryChanged);
    _cvvCtrl.addListener(_handleCvvChanged);
    _cvvFocus.addListener(_handleCvvFocus);
  }

  @override
  void dispose() {
    _flipController.dispose();
    _numberCtrl.dispose();
    _nameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _cvvFocus.dispose();
    super.dispose();
  }

  void _handleNumberChanged() {
    final rawDigits = _numberCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    final formatted = _formatCardNumber(rawDigits);
    if (_numberCtrl.text != formatted) {
      final cursor = formatted.length;
      _numberCtrl
        ..text = formatted
        ..selection = TextSelection.collapsed(offset: cursor);
    }

    final fallbackStyle = _CardStyleResolver.fromDigits(rawDigits);

    setState(() {
      _cardStyle = fallbackStyle;
      _isActivated = rawDigits.length >= 6;
      _formattedNumber = formatted.isEmpty
          ? '**** **** **** ****'
          : formatted.padRight(fallbackStyle.isAmex ? 17 : 19, '•');
      if (rawDigits.length < 6) {
        _binInfo = null;
        _pendingBin = null;
      }
      if (_cvvCtrl.text.isEmpty) {
        _cvvDisplay = fallbackStyle.isAmex ? '****' : '***';
      }
    });

    if (rawDigits.length >= 6) {
      final bin = rawDigits.substring(0, 6);
      _pendingBin = bin;
      BinLookupService.instance.lookup(rawDigits).then((info) {
        if (!mounted || _pendingBin != bin) return;
        setState(() {
          _binInfo = info;
          if (info != null) {
            _cardStyle = _CardStyleResolver.fromBinInfo(info, fallback: fallbackStyle);
            if (_cardStyle.isAmex) {
              _flipController.reverse();
            }
            if (_cvvCtrl.text.isEmpty) {
              _cvvDisplay = _cardStyle.isAmex ? '****' : '***';
            }
          }
        });
      });
    }
  }

  void _handleNameChanged() {
    setState(() {
      _holderDisplay = _nameCtrl.text.isEmpty
          ? 'NOMBRE Y APELLIDO'
          : _nameCtrl.text.toUpperCase();
    });
  }

  void _handleExpiryChanged() {
    final digits = _expiryCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted = digits;
    if (digits.length > 2) {
      formatted = '${digits.substring(0, 2)}/${digits.substring(2, digits.length.clamp(2, 4))}';
    }
    if (_expiryCtrl.text != formatted) {
      _expiryCtrl
        ..text = formatted
        ..selection = TextSelection.collapsed(offset: formatted.length);
    }
    setState(() {
      _formattedExpiry = formatted.isEmpty ? 'MM/AA' : formatted;
    });
  }

  void _handleCvvChanged() {
    final maxLength = _cardStyle.isAmex ? 4 : 3;
    var digits = _cvvCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > maxLength) {
      digits = digits.substring(0, maxLength);
      _cvvCtrl
        ..text = digits
        ..selection = TextSelection.collapsed(offset: digits.length);
    }
    setState(() {
      _cvvDisplay = digits.isEmpty
          ? (_cardStyle.isAmex ? '****' : '***')
          : digits.padRight(maxLength, '•');
    });
  }

  void _handleCvvFocus() {
    if (_cardStyle.isAmex) {
      _flipController.reverse();
      return;
    }
    if (_cvvFocus.hasFocus) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  String _formatCardNumber(String digits) {
    if (digits.isEmpty) return '';
    final buffer = StringBuffer();
    final groupPattern = _cardStyle.isAmex ? [4, 6, 5] : [4, 4, 4, 4];
    var index = 0;
    for (var group in groupPattern) {
      if (index >= digits.length) break;
      final end = (index + group).clamp(0, digits.length);
      buffer.write(digits.substring(index, end));
      if (end < digits.length) buffer.write(' ');
      index = end;
    }
    if (index < digits.length) {
      buffer.write(digits.substring(index));
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: viewInsets),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, controller) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                children: [
                  Container(
                    height: 4,
                    width: 48,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Text('Agregar tarjeta', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  _LiveCardPreview(
                    controller: _flipController,
                    style: _cardStyle,
                    number: _formattedNumber,
                    holder: _holderDisplay,
                    expiry: _formattedExpiry,
                    cvv: _cvvDisplay,
                  ),
                  const SizedBox(height: 24),
                  if (_binInfo != null) _BinMetadata(info: _binInfo!),
                  if (_binInfo != null) const SizedBox(height: 24),
                  _InputField(
                    label: 'Nombre y apellido',
                    hint: 'Juan Pérez',
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 18),
                  _InputField(
                    label: 'Número de tarjeta',
                    hint: _cardStyle.isAmex ? '0000 000000 00000' : '0000 0000 0000 0000',
                    controller: _numberCtrl,
                    keyboardType: TextInputType.number,
                    prefix: _BrandBadge(style: _cardStyle),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _InputField(
                          label: 'Vencimiento',
                          hint: 'MM/AA',
                          controller: _expiryCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _InputField(
                          label: 'CVV',
                          hint: _cardStyle.isAmex ? '1234' : '123',
                          controller: _cvvCtrl,
                          keyboardType: TextInputType.number,
                          focusNode: _cvvFocus,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isActivated && _numberCtrl.text.replaceAll(' ', '').length >= 12
                        ? () {}
                        : null,
                    child: const Text('Guardar tarjeta'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BrandBadge extends StatelessWidget {
  const _BrandBadge({required this.style});

  final _CardStyle style;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: style.accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, color: style.accentColor, size: 18),
          const SizedBox(width: 6),
          Text(
            style.label,
            style: TextStyle(color: style.accentColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _BinMetadata extends StatelessWidget {
  const _BinMetadata({required this.info});

  final CardBinInfo info;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final infoChips = <Widget>[];
    if (info.brand.isNotEmpty) infoChips.add(_metaChip(Icons.credit_card, info.brand));
    if (info.type.isNotEmpty) infoChips.add(_metaChip(Icons.category, info.type));
    if (info.category.isNotEmpty) infoChips.add(_metaChip(Icons.layers, info.category));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Detalles detectados', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...infoChips,
            if (info.issuer.isNotEmpty) _metaChip(Icons.apartment, info.issuer),
            if (info.countryName.isNotEmpty)
              _metaChip(Icons.flag, info.countryName),
          ],
        ),
      ],
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

class _LiveCardPreview extends StatelessWidget {
  const _LiveCardPreview({
    required this.controller,
    required this.style,
    required this.number,
    required this.holder,
    required this.expiry,
    required this.cvv,
  });

  final AnimationController controller;
  final _CardStyle style;
  final String number;
  final String holder;
  final String expiry;
  final String cvv;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.58,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * math.pi;
          final isFront = angle <= (math.pi / 2);
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? _CardFaceFront(
                    gradient: style.gradient,
                    style: style,
                    number: number,
                    holder: holder,
                    expiry: expiry,
                  )
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: _CardFaceBack(
                      gradient: style.gradient,
                      style: style,
                      cvv: cvv,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _CardFaceFront extends StatelessWidget {
  const _CardFaceFront({
    required this.gradient,
    required this.style,
    required this.number,
    required this.holder,
    required this.expiry,
  });

  final List<Color> gradient;
  final _CardStyle style;
  final String number;
  final String holder;
  final String expiry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(blurRadius: 28, offset: Offset(0, 18), color: Colors.black26),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CardChip(accent: gradient.last),
              Row(
                children: [
                  Icon(style.icon, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    style.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2.2,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Titular',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      holder,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vencimiento',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expiry,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardFaceBack extends StatelessWidget {
  const _CardFaceBack({
    required this.gradient,
    required this.style,
    required this.cvv,
  });

  final List<Color> gradient;
  final _CardStyle style;
  final String cvv;

  @override
  Widget build(BuildContext context) {
    final accent = gradient.last.withValues(alpha: 0.8);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(blurRadius: 28, offset: Offset(0, 18), color: Colors.black26),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerRight,
            child: Text(
              cvv,
              style: const TextStyle(
                letterSpacing: 4,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(style.icon, color: accent, size: 18),
                const SizedBox(width: 8),
                Text(style.label, style: TextStyle(color: accent, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardChip extends StatelessWidget {
  const _CardChip({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [accent.withValues(alpha: 0.6), Colors.white.withValues(alpha: 0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              width: 8,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.prefix,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final Widget? prefix;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: cs.onSurface.withValues(alpha: 0.72),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: prefix,
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(minHeight: 48, minWidth: 0),
            filled: true,
            fillColor: cs.surface.withValues(alpha: 0.9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: cs.primary, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardStyle {
  const _CardStyle({
    required this.label,
    required this.gradient,
    required this.icon,
    required this.accentColor,
    required this.isAmex,
  });

  final String label;
  final List<Color> gradient;
  final IconData icon;
  final Color accentColor;
  final bool isAmex;
}

class _CardStyleResolver {
  static const _CardStyle unknown = _CardStyle(
    label: 'Tarjeta',
    gradient: [Color(0xFF4B4B5C), Color(0xFF313143)],
    icon: Icons.credit_card,
    accentColor: Color(0xFF9CA3AF),
    isAmex: false,
  );

  static final Map<String, _CardStyle> _brandStyles = {
    'VISA': _CardStyle(
      label: 'Visa',
      gradient: [const Color(0xFF0F4C81), const Color(0xFF42A5F5)],
      icon: Icons.credit_card,
      accentColor: const Color(0xFF42A5F5),
      isAmex: false,
    ),
    'MASTERCARD': _CardStyle(
      label: 'Mastercard',
      gradient: [const Color(0xFFFF6F00), const Color(0xFFFF3D00)],
      icon: Icons.credit_card,
      accentColor: const Color(0xFFFF6F00),
      isAmex: false,
    ),
    'AMERICAN EXPRESS': _CardStyle(
      label: 'American Express',
      gradient: [const Color(0xFF2AB7CA), const Color(0xFF0B4F6C)],
      icon: Icons.credit_card,
      accentColor: const Color(0xFF2AB7CA),
      isAmex: true,
    ),
    'DISCOVER': _CardStyle(
      label: 'Discover',
      gradient: [const Color(0xFFFF8C42), const Color(0xFFCC2A36)],
      icon: Icons.travel_explore,
      accentColor: const Color(0xFFFF8C42),
      isAmex: false,
    ),
    'JCB': _CardStyle(
      label: 'JCB',
      gradient: [const Color(0xFF00A6FF), const Color(0xFF00FFCE)],
      icon: Icons.credit_card,
      accentColor: const Color(0xFF00A6FF),
      isAmex: false,
    ),
    'MAESTRO': _CardStyle(
      label: 'Maestro',
      gradient: [const Color(0xFF0061A8), const Color(0xFFFF2C55)],
      icon: Icons.credit_card,
      accentColor: const Color(0xFF0061A8),
      isAmex: false,
    ),
    'UNIONPAY': _CardStyle(
      label: 'UnionPay',
      gradient: [const Color(0xFF0AA344), const Color(0xFF0078D7)],
      icon: Icons.language,
      accentColor: const Color(0xFF0AA344),
      isAmex: false,
    ),
    'MIR': _CardStyle(
      label: 'Mir',
      gradient: [const Color(0xFF1E4B87), const Color(0xFF2AB27B)],
      icon: Icons.credit_card,
      accentColor: const Color(0xFF2AB27B),
      isAmex: false,
    ),
  };

  static _CardStyle fromDigits(String digits) {
    if (digits.startsWith('34') || digits.startsWith('37')) {
      return _brandStyles['AMERICAN EXPRESS']!;
    }
    if (digits.startsWith('4')) {
      return _brandStyles['VISA']!;
    }
    if (RegExp(r'^(5[1-5]|2[2-7])').hasMatch(digits)) {
      return _brandStyles['MASTERCARD']!;
    }
    if (digits.startsWith('6011') || digits.startsWith('65')) {
      return _brandStyles['DISCOVER']!;
    }
    if (digits.startsWith('2700')) {
      return _CardStyle(
        label: 'ID Bank',
        gradient: [const Color(0xFF8D43FF), const Color(0xFF24C6DC)],
        icon: Icons.account_balance,
        accentColor: const Color(0xFF8D43FF),
        isAmex: false,
      );
    }
    return unknown;
  }

  static _CardStyle fromBinInfo(CardBinInfo info, {required _CardStyle fallback}) {
    final key = info.brand.toUpperCase();
    final style = _brandStyles[key];
    if (style != null) return style;
    if (info.brand.toUpperCase().contains('AMERICAN EXPRESS')) {
      return _brandStyles['AMERICAN EXPRESS']!;
    }
    if (info.brand.toUpperCase().contains('VISA')) {
      return _brandStyles['VISA']!;
    }
    if (info.brand.toUpperCase().contains('MASTERCARD')) {
      return _brandStyles['MASTERCARD']!;
    }
    if (info.brand.toUpperCase().contains('UNIONPAY')) {
      return _brandStyles['UNIONPAY']!;
    }
    return fallback;
  }
}
