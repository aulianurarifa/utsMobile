import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class News {
  const News({
    required this.title,
    required this.source,
    required this.time,
    required this.icon,
    required this.imageUrl,
  });

  final String title;
  final String source;
  final String time;
  final IconData icon;
  final String imageUrl;
}

const LinearGradient _newsCardGradient = LinearGradient(
  colors: <Color>[Color(0xFFFFD8F1), Color(0xFFAED7FF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class BeritaPage extends StatelessWidget {
  const BeritaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<News> newsList = <News>[
      const News(
        title: 'OpenAI announces platform for making custom AI assistants',
        source: 'The Verge',
        time: '2023-11-06T09:15:00Z',
        icon: Icons.smart_toy_outlined,
        imageUrl: 'https://picsum.photos/seed/ai/640/360',
      ),
      const News(
        title:
            'The National Zoological Gardens pandas program is ending after three pandas',
        source: 'CNN',
        time: '2023-11-06T12:20:00Z',
        icon: Icons.pets_outlined,
        imageUrl: 'https://picsum.photos/seed/panda/640/360',
      ),
      const News(
        title: 'New breakthrough in quantum computing announced by tech giants',
        source: 'TechCrunch',
        time: '2023-11-06T08:30:00Z',
        icon: Icons.memory_outlined,
        imageUrl: 'https://picsum.photos/seed/quantum/640/360',
      ),
      const News(
        title: 'Climate summit reaches historic agreement on emissions',
        source: 'BBC News',
        time: '2023-11-05T20:45:00Z',
        icon: Icons.public_outlined,
        imageUrl: 'https://picsum.photos/seed/climate/640/360',
      ),
      const News(
        title: 'Major sports tournament finals draw record viewership',
        source: 'ESPN',
        time: '2023-11-05T18:00:00Z',
        icon: Icons.emoji_events_outlined,
        imageUrl: 'https://picsum.photos/seed/sports/640/360',
      ),
      const News(
        title: 'Stock markets hit new highs amid economic optimism',
        source: 'Bloomberg',
        time: '2023-11-05T14:20:00Z',
        icon: Icons.trending_up,
        imageUrl: 'https://picsum.photos/seed/stocks/640/360',
      ),
      const News(
        title: 'Revolutionary medical treatment shows promising results',
        source: 'Medical News',
        time: '2023-11-05T10:15:00Z',
        icon: Icons.healing_outlined,
        imageUrl: 'https://picsum.photos/seed/medical/640/360',
      ),
      const News(
        title: 'Space agency announces plans for Mars mission',
        source: 'Space News',
        time: '2023-11-04T22:30:00Z',
        icon: Icons.rocket_launch_outlined,
        imageUrl: 'https://picsum.photos/seed/space/640/360',
      ),
      const News(
        title: 'Electric vehicle sales surge in global markets',
        source: 'Auto News',
        time: '2023-11-04T16:45:00Z',
        icon: Icons.ev_station_outlined,
        imageUrl: 'https://picsum.photos/seed/ev/640/360',
      ),
      const News(
        title: 'New smartphone with innovative features launched',
        source: 'Tech Review',
        time: '2023-11-04T13:00:00Z',
        icon: Icons.phone_android_outlined,
        imageUrl: 'https://picsum.photos/seed/smartphone/640/360',
      ),
    ];

    final TextStyle headerStyle = GoogleFonts.fredoka(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF574374),
    );
    final TextStyle subtitleStyle = GoogleFonts.vt323(
      fontSize: 18,
      letterSpacing: 1.2,
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
                    color: Colors.grey.withValues(alpha: 0.12),
                  ),
                ),
              ),
              const _StickerBadge(
                asset: 'assets/images/stiker3.png',
                top: 10,
                left: 10,
                width: 108,
                opacity: 0.5,
              ),
              const _StickerBadge(
                asset: 'assets/images/stiker1.png',
                bottom: 16,
                right: 18,
                width: 104,
                opacity: 0.86,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Berita ', style: headerStyle),
                              const SizedBox(height: 4),
                              Text('kabar-kabar', style: subtitleStyle),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.82),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFB9B4D8),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(
                                  Icons.search_rounded,
                                  color: Color(0xFF5F6AAE),
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.filter_alt_rounded,
                                  color: Color(0xFFFF7FBF),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Berita telah diperbarui \u2661'),
                            ),
                          );
                        }
                      },
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                        itemCount: newsList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (BuildContext context, int index) {
                          final News news = newsList[index];
                          final String relativeTime = _formatTime(news.time);
                          return _NewsCard(
                            news: news,
                            relativeTime: relativeTime,
                            onTap: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Membuka: ${news.title}'),
                                  ),
                                ),
                            onBookmark: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Berita disimpan cantik \u2661',
                                    ),
                                  ),
                                ),
                          );
                        },
                      ),
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

  String _formatTime(String isoTime) {
    try {
      final DateTime dateTime = DateTime.parse(isoTime).toLocal();
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} hari yang lalu';
      }
      if (difference.inHours > 0) {
        return '${difference.inHours} jam yang lalu';
      }
      if (difference.inMinutes > 0) {
        return '${difference.inMinutes} menit yang lalu';
      }
      return 'Baru saja';
    } catch (_) {
      return isoTime;
    }
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.news,
    required this.relativeTime,
    required this.onTap,
    required this.onBookmark,
  });

  final News news;
  final String relativeTime;
  final VoidCallback onTap;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = GoogleFonts.fredoka(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.3,
      color: const Color(0xFF4F4B8C),
    );
    final TextStyle badgeStyle = GoogleFonts.fredoka(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF4F4B8C),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: _newsCardGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFB9B4D8), width: 1.3),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF8A83C2).withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -8,
              right: -6,
              child: Opacity(
                opacity: 0.18,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 72,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _NewsThumbnail(news: news),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          news.title,
                          style: titleStyle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: <Widget>[
                            _MetaBadge(
                              icon: Icons.source_rounded,
                              label: news.source,
                              style: badgeStyle,
                            ),
                            _MetaBadge(
                              icon: Icons.access_time_rounded,
                              label: relativeTime,
                              style: badgeStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.bookmark_add_outlined,
                        color: Color(0xFF4E4D88),
                      ),
                      onPressed: onBookmark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsThumbnail extends StatelessWidget {
  const _NewsThumbnail({required this.news});

  final News news;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB9B4D8), width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              child: Image.network(
                news.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder:
                    (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? progress,
                    ) {
                      if (progress == null) {
                        return child;
                      }
                      return Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF6E78DA),
                            ),
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                errorBuilder:
                    (BuildContext context, Object error, StackTrace? stack) {
                      return Center(
                        child: Icon(
                          news.icon,
                          size: 36,
                          color: const Color(0xFF5E73D4),
                        ),
                      );
                    },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 26,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      const Color(0xFF2F2640).withValues(alpha: 0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({
    required this.icon,
    required this.label,
    required this.style,
  });

  final IconData icon;
  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFB9B4D8), width: 1.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: const Color(0xFF6F6DB6)),
          const SizedBox(width: 6),
          Text(label, style: style),
        ],
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
