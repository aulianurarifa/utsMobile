import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Contact {
  const Contact({
    required this.name,
    required this.phone,
    required this.status,
    required this.gradient,
  });

  final String name;
  final String phone;
  final String status;
  final List<Color> gradient;
}

class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  static const List<Contact> _contacts = <Contact>[
    Contact(
      name: 'Arunala',
      phone: '+62 812-3456-7890',
      status: 'Partner kampus',
      gradient: <Color>[Color(0xFFFFD8F1), Color(0xFFAED7FF)],
    ),
    Contact(
      name: 'Amara',
      phone: '+62 813-4567-8901',
      status: 'Bestie kampus',
      gradient: <Color>[Color(0xFFFFE0EC), Color(0xFFB4F0FF)],
    ),
    Contact(
      name: 'Yessi',
      phone: '+62 814-5678-9012',
      status: 'Temen kampus',
      gradient: <Color>[Color(0xFFFFF0D9), Color(0xFFD4C9FF)],
    ),
    Contact(
      name: 'Kuluela',
      phone: '+62 815-6789-0123',
      status: 'Temen projek desain UI',
      gradient: <Color>[Color(0xFFE0D3FF), Color(0xFFFFD0E5)],
    ),
    Contact(
      name: 'Nadyline',
      phone: '+62 816-7890-1234',
      status: 'Partner kampus',
      gradient: <Color>[Color(0xFFFFE9F6), Color(0xFFC9E7FF)],
    ),
    Contact(
      name: 'Haruna',
      phone: '+62 817-8901-2345',
      status: 'Sepupu',
      gradient: <Color>[Color(0xFFFFDBEB), Color(0xFFCFD6FF)],
    ),
    Contact(
      name: 'Mommy',
      phone: '+62 818-9012-3456',
      status: 'lOVELY MOMS',
      gradient: <Color>[Color(0xFFFFE5D9), Color(0xFFCAE4FF)],
    ),
    Contact(
      name: 'Audine',
      phone: '+62 819-0123-4567',
      status: 'Florist AMORA STUDIO',
      gradient: <Color>[Color(0xFFEDE7FF), Color(0xFFFFD7F3)],
    ),
    Contact(
      name: 'Milan',
      phone: '+62 821-1234-5678',
      status: 'temen kampus',
      gradient: <Color>[Color(0xFFFFE3EA), Color(0xFFCCF1FF)],
    ),
    Contact(
      name: 'Una',
      phone: '+62 822-2345-6789',
      status: 'temen kampus',
      gradient: <Color>[Color(0xFFFFF0D9), Color(0xFFCEDBFF)],
    ),
    Contact(
      name: 'Inay',
      phone: '+62 823-3456-7890',
      status: 'Teman SMA',
      gradient: <Color>[Color(0xFFFEE4FF), Color(0xFFBFDFFF)],
    ),
    Contact(
      name: 'Nazu',
      phone: '+62 824-4567-8901',
      status: 'temen SMA',
      gradient: <Color>[Color(0xFFE4F3FF), Color(0xFFFFE0F2)],
    ),
    Contact(
      name: 'Alesukacakes',
      phone: '+62 825-5678-9012',
      status: 'Ownwerkamar merona',
      gradient: <Color>[Color(0xFFFFE7F8), Color(0xFFCBE4FF)],
    ),
    Contact(
      name: 'Helga',
      phone: '+62 826-6789-0123',
      status: 'Fotografer',
      gradient: <Color>[Color(0xFFFFF2DC), Color(0xFFD5D2FF)],
    ),
    Contact(
      name: 'Olivia',
      phone: '+62 827-7890-1234',
      status: 'PO Dimsum',
      gradient: <Color>[Color(0xFFFFEDF5), Color(0xFFBFE6FF)],
    ),
  ];

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
                    color: Colors.grey.withValues(alpha: 0.1),
                  ),
                ),
              ),
              const _StickerBadge(
                asset: 'assets/images/stiker3.png',
                top: 16,
                right: 12,
                width: 108,
                opacity: 0.8,
              ),
              const _StickerBadge(
                asset: 'assets/images/stiker2.png',
                bottom: 20,
                left: -6,
                width: 138,
                opacity: 0.8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Kontak Sweety', style: headerStyle),
                        const SizedBox(height: 6),
                        Text('Semua sahabat ', style: subtitleStyle),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      itemBuilder: (BuildContext context, int index) {
                        final Contact contact = _contacts[index];
                        return _ContactCard(
                          contact: contact,
                          onCall: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: const Color(
                                  0xFF574374,
                                ).withValues(alpha: 0.92),
                                content: Text(
                                  'Memanggil ${contact.name}  \u2661',
                                  style: GoogleFonts.vt323(
                                    fontSize: 18,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                            );
                          },
                          onMessage: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: const Color(
                                  0xFF574374,
                                ).withValues(alpha: 0.92),
                                content: Text(
                                  'Mengirim pesan manis ke ${contact.name}',
                                  style: GoogleFonts.vt323(
                                    fontSize: 18,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 16),
                      itemCount: _contacts.length,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.contact,
    required this.onCall,
    required this.onMessage,
  });

  final Contact contact;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    final TextStyle nameStyle = GoogleFonts.fredoka(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF40386A),
    );
    final TextStyle statusStyle = GoogleFonts.vt323(
      fontSize: 16,
      letterSpacing: 1.1,
      color: const Color(0xFF5B5A92),
    );
    final TextStyle phoneStyle = GoogleFonts.vt323(
      fontSize: 18,
      letterSpacing: 1.1,
      color: const Color(0xFF2E2542),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: contact.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFB9B4D8), width: 1.2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF8A83C2).withValues(alpha: 0.18),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 12,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFB9B4D8), width: 1.0),
              ),
              child: Text(
                'kontak',
                style: GoogleFonts.vt323(
                  fontSize: 16,
                  letterSpacing: 1.1,
                  color: const Color(0xFF51509B),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withValues(alpha: 0.85),
                        border: Border.all(
                          color: const Color(0xFFB9B4D8),
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          contact.name[0].toUpperCase(),
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF5E73D4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(contact.name, style: nameStyle),
                          const SizedBox(height: 4),
                          Text(contact.status, style: statusStyle),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFB9B4D8),
                      width: 1.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.phone_rounded,
                        color: Color(0xFF5E73D4),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(contact.phone, style: phoneStyle)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    _ContactActionButton(
                      icon: Icons.call_made_rounded,
                      label: 'Call',
                      onTap: onCall,
                      colors: const <Color>[
                        Color(0xFF5E73D4),
                        Color(0xFF9A8CFF),
                      ],
                    ),
                    const SizedBox(width: 12),
                    _ContactActionButton(
                      icon: Icons.chat_bubble_rounded,
                      label: 'Chat',
                      onTap: onMessage,
                      colors: const <Color>[
                        Color(0xFFFF78B5),
                        Color(0xFFFFB3D8),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactActionButton extends StatelessWidget {
  const _ContactActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = GoogleFonts.vt323(
      fontSize: 16,
      letterSpacing: 1.1,
      color: Colors.white,
    );

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.last.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1.1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(label, style: labelStyle),
            ],
          ),
        ),
      ),
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
