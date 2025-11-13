import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  static const BiodataProfile _initialProfile = BiodataProfile(
    name: 'Aulia Nur Arifa',
    nickname: 'Aul',
    gender: 'Perempuan',
    birthPlace: 'Cimahi',
    birthDate: '17 Juni 2004',
    education: 'Mahasiswa Informatika',
    email: 'aulianurarifa@email.com',
    phone: '+62 813-7788-4411',
    address: 'Cimahi',
    hobbies: <String>[
      'Merangkai scrapbook',
      'Membuat cookies',
      'Merangkai bunga',
    ],
    quote: 'Let every sunshine day feel like cotton candy skies. \u2661',
  );

  BiodataProfile _profile = _initialProfile;

  Future<void> _openEditSheet() async {
    final BiodataProfile? updatedProfile =
        await showModalBottomSheet<BiodataProfile>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) =>
              _BiodataEditSheet(profile: _profile),
        );

    if (!mounted || updatedProfile == null) {
      return;
    }

    setState(() => _profile = updatedProfile);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Biodata disimpan! \u2728',
          style: GoogleFonts.vt323(fontSize: 18),
        ),
        backgroundColor: const Color(0xFF8EDBFF),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headerStyle = GoogleFonts.fredoka(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF574374),
    );
    final TextStyle subtitleStyle = GoogleFonts.vt323(
      fontSize: 18,
      letterSpacing: 1.3,
      color: const Color(0xFF756FA0),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFCEAFF),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 6, bottom: 12),
        child: FloatingActionButton.extended(
          onPressed: _openEditSheet,
          backgroundColor: const Color(0xFF8EDBFF),
          foregroundColor: const Color(0xFF2F2640),
          icon: const Icon(Icons.edit_rounded),
          label: Text('Edit', style: GoogleFonts.vt323(fontSize: 18)),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFFFCEAFF),
                Color(0xFFF9F6FF),
                Color(0xFFFFEFFE),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(
                  painter: _PixelGridPainter(
                    color: Colors.grey.withValues(alpha: 0.12),
                  ),
                ),
              ),
              const _StickerBadge(
                asset: 'assets/images/stiker1.png',
                top: 12,
                right: 12,
                width: 98,
                opacity: 0.88,
              ),
              const _StickerBadge(
                asset: 'assets/images/stiker2.png',
                bottom: 26,
                left: -8,
                width: 142,
                opacity: 0.8,
              ),
              const _StickerBadge(
                asset: 'assets/images/stiker3.png',
                bottom: 8,
                left: 9,
                width: 110,
                opacity: 0.55,
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Biodata ', style: headerStyle),
                    const SizedBox(height: 6),
                    Text('My Profile ', style: subtitleStyle),
                    const SizedBox(height: 20),
                    _IdentityCard(profile: _profile),
                    const SizedBox(height: 24),
                    _InfoSection(
                      title: 'Detail Pribadi \u2661',
                      children: <Widget>[
                        _InfoRow(
                          icon: Icons.cake_rounded,
                          label: 'Tempat, Tanggal Lahir',
                          value:
                              '${_profile.birthPlace} \u00B7 ${_profile.birthDate}',
                        ),
                        const SizedBox(height: 14),
                        _InfoRow(
                          icon: Icons.female,
                          label: 'Jenis Kelamin',
                          value: _profile.gender,
                        ),
                        const SizedBox(height: 14),
                        _InfoRow(
                          icon: Icons.school_rounded,
                          label: 'Pendidikan',
                          value: _profile.education,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _InfoSection(
                      title: 'Kontak & Domisili \u2661',
                      children: <Widget>[
                        _InfoRow(
                          icon: Icons.email_rounded,
                          label: 'Email',
                          value: _profile.email,
                        ),
                        const SizedBox(height: 14),
                        _InfoRow(
                          icon: Icons.phone_rounded,
                          label: 'Telepon',
                          value: _profile.phone,
                        ),
                        const SizedBox(height: 14),
                        _InfoRow(
                          icon: Icons.home_rounded,
                          label: 'Alamat',
                          value: _profile.address,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _InfoSection(
                      title: 'Kesukaan Manis \u273F',
                      children: <Widget>[
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _profile.hobbies
                              .map((String hobby) => _TagChip(label: hobby))
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _QuoteCard(quote: _profile.quote),
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

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.profile});

  final BiodataProfile profile;

  @override
  Widget build(BuildContext context) {
    final TextStyle nameStyle = GoogleFonts.fredoka(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF4F4B8C),
    );
    final TextStyle taglineStyle = GoogleFonts.vt323(
      fontSize: 18,
      letterSpacing: 1.2,
      color: const Color(0xFF6F6DB6),
    );
    final TextStyle badgeStyle = GoogleFonts.fredoka(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF5E73D4),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFB9B4D8), width: 1.6),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF8A83C2).withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFFFD8F1), Color(0xFFAED7FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: Image.asset(
              'assets/images/profile.jpeg',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            child: Column(
              children: <Widget>[
                Text(
                  profile.name,
                  style: nameStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Panggil aku ${profile.nickname} ya \u2729',
                  style: taglineStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFB9B4D8),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    'Dreamy student ID  \u2661',
                    style: badgeStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BiodataEditSheet extends StatefulWidget {
  const _BiodataEditSheet({required this.profile});

  final BiodataProfile profile;

  @override
  State<_BiodataEditSheet> createState() => _BiodataEditSheetState();
}

class _BiodataEditSheetState extends State<_BiodataEditSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController = TextEditingController(
    text: widget.profile.name,
  );
  late final TextEditingController _nicknameController = TextEditingController(
    text: widget.profile.nickname,
  );
  late final TextEditingController _genderController = TextEditingController(
    text: widget.profile.gender,
  );
  late final TextEditingController _birthPlaceController =
      TextEditingController(text: widget.profile.birthPlace);
  late final TextEditingController _birthDateController = TextEditingController(
    text: widget.profile.birthDate,
  );
  late final TextEditingController _educationController = TextEditingController(
    text: widget.profile.education,
  );
  late final TextEditingController _emailController = TextEditingController(
    text: widget.profile.email,
  );
  late final TextEditingController _phoneController = TextEditingController(
    text: widget.profile.phone,
  );
  late final TextEditingController _addressController = TextEditingController(
    text: widget.profile.address,
  );
  late final TextEditingController _hobbiesController = TextEditingController(
    text: widget.profile.hobbies.join(', '),
  );
  late final TextEditingController _quoteController = TextEditingController(
    text: widget.profile.quote,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _genderController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _educationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _hobbiesController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.vt323(
        fontSize: 18,
        color: const Color(0xFF4F4B8C),
      ),
      hintStyle: GoogleFonts.vt323(
        fontSize: 16,
        color: const Color(0xFF8A86B0),
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.92),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFB9B4D8), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF6E78DA), width: 1.4),
      ),
    );
  }

  void _handleSave() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final List<String> hobbies = _hobbiesController.text
        .split(',')
        .map((String value) => value.trim())
        .where((String value) => value.isNotEmpty)
        .toList();

    final BiodataProfile updated = widget.profile.copyWith(
      name: _nameController.text.trim(),
      nickname: _nicknameController.text.trim(),
      gender: _genderController.text.trim(),
      birthPlace: _birthPlaceController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      education: _educationController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      hobbies: hobbies,
      quote: _quoteController.text.trim(),
    );

    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = GoogleFonts.fredoka(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF4F4B8C),
    );
    final TextStyle helperStyle = GoogleFonts.vt323(
      fontSize: 14,
      color: const Color(0xFF756FA0),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFFFFD8F1), Color(0xFFAED7FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0xFFB9B4D8), width: 1.4),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: const Color(0xFF8A83C2).withValues(alpha: 0.22),
                blurRadius: 26,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Edit Biodata', style: titleStyle),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration('Nama lengkap'),
                    validator: (String? value) =>
                        value == null || value.trim().isEmpty
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _nicknameController,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration('Nama panggilan'),
                    validator: (String? value) =>
                        value == null || value.trim().isEmpty
                        ? 'Nama panggilan harus diisi'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _genderController,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration('Jenis kelamin'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _birthPlaceController,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration('Tempat lahir'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _birthDateController,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration('Tanggal lahir'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _educationController,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration('Pendidikan'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration('Email'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration('Nomor telepon'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _addressController,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration('Alamat'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _hobbiesController,
                    maxLines: 2,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration(
                      'Hobi',
                      hint: 'Pisahkan dengan koma (misal: membaca, menari)',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hobi akan ditampilkan sebagai list manis.',
                      style: helperStyle,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _quoteController,
                    maxLines: 2,
                    style: GoogleFonts.vt323(fontSize: 18, letterSpacing: 1),
                    decoration: _inputDecoration('Quote favorit'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4F4B8C),
                            side: const BorderSide(
                              color: Color(0xFF4F4B8C),
                              width: 1.2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: GoogleFonts.vt323(fontSize: 18),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleSave,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFF6E78DA),
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.vt323(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text('Simpan'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = GoogleFonts.fredoka(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF5E73D4),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFD7D3EC), width: 1.2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF8A83C2).withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: titleStyle),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = GoogleFonts.fredoka(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF6F6DB6),
    );
    final TextStyle valueStyle = GoogleFonts.vt323(
      fontSize: 20,
      letterSpacing: 1.1,
      color: const Color(0xFF3A3251),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFFFFD8F1), Color(0xFFAED7FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFB9B4D8), width: 1.1),
          ),
          child: Icon(icon, color: const Color(0xFF4E4D88), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: labelStyle),
              const SizedBox(height: 4),
              Text(value, style: valueStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final TextStyle chipStyle = GoogleFonts.vt323(
      fontSize: 18,
      letterSpacing: 1.1,
      color: const Color(0xFF3A3251),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFFFD8F1), Color(0xFFAED7FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB9B4D8), width: 1.1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF8A83C2).withValues(alpha: 0.16),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(label, style: chipStyle),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote});

  final String quote;

  @override
  Widget build(BuildContext context) {
    final TextStyle quoteStyle = GoogleFonts.vt323(
      fontSize: 20,
      letterSpacing: 1.2,
      color: const Color(0xFF3A3251),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD7D3EC), width: 1.2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF8A83C2).withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFB9B4D8), width: 1.1),
              color: const Color(0xFFFFD8F1).withValues(alpha: 0.75),
            ),
            child: const Icon(
              Icons.format_quote_rounded,
              color: Color(0xFF5E73D4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(quote, style: quoteStyle)),
        ],
      ),
    );
  }
}

class BiodataProfile {
  const BiodataProfile({
    required this.name,
    required this.nickname,
    required this.gender,
    required this.birthPlace,
    required this.birthDate,
    required this.education,
    required this.email,
    required this.phone,
    required this.address,
    required this.hobbies,
    required this.quote,
  });

  final String name;
  final String nickname;
  final String gender;
  final String birthPlace;
  final String birthDate;
  final String education;
  final String email;
  final String phone;
  final String address;
  final List<String> hobbies;
  final String quote;

  BiodataProfile copyWith({
    String? name,
    String? nickname,
    String? gender,
    String? birthPlace,
    String? birthDate,
    String? education,
    String? email,
    String? phone,
    String? address,
    List<String>? hobbies,
    String? quote,
  }) {
    final List<String> resolvedHobbies = hobbies ?? this.hobbies;

    return BiodataProfile(
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      birthPlace: birthPlace ?? this.birthPlace,
      birthDate: birthDate ?? this.birthDate,
      education: education ?? this.education,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      hobbies: List<String>.from(resolvedHobbies),
      quote: quote ?? this.quote,
    );
  }
}

class _StickerBadge extends StatelessWidget {
  const _StickerBadge({
    required this.asset,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.width,
    this.opacity = 1.0,
  });

  final String asset;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? width;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        ignoring: true,
        child: Opacity(
          opacity: opacity,
          child: Image.asset(asset, width: width),
        ),
      ),
    );
  }
}

class _PixelGridPainter extends CustomPainter {
  const _PixelGridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double cell = 20;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    for (double x = 0; x <= size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PixelGridPainter oldDelegate) =>
      oldDelegate.color != color;
}
