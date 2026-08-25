import 'package:flutter/material.dart';

/// ============================================================
/// SPOTIFY HOME VIEW — Recreación visual estática (sin lógica)
/// ============================================================
/// Reproduce la pantalla principal de Spotify y su navegación
/// lateral (drawer de perfil) tal como aparecen en las capturas
/// de referencia. Todos los datos son mock y no hay llamadas a
/// red, estado de negocio ni navegación real entre pantallas:
/// solo se usa el mecanismo nativo de Drawer de Flutter para
/// poder *ver* el panel lateral, sin lógica adicional.
/// ============================================================

void main() {
  runApp(const SpotifyCloneApp());
}

class SpotifyCloneApp extends StatelessWidget {
  const SpotifyCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Home (UI Only)',
      debugShowCheckedModeBanner: false,
      theme: SpotifyTheme.dark,
      home: const SpotifyHomeView(),
    );
  }
}

/// ------------------------------------------------------------
/// PALETA Y TIPOGRAFÍA — tokens de diseño centralizados
/// ------------------------------------------------------------
class SpotifyColors {
  static const black = Color(0xFF000000);
  static const background = Color(0xFF121212); // fondo base scaffold
  static const surface = Color(0xFF181818); // tarjetas / chips
  static const surfaceHigh = Color(0xFF282828); // tarjetas elevadas / hover
  static const drawerBackground = Color(0xFF1A1A1A); // fondo del nav lateral
  static const green = Color(0xFF1DB954); // acento de marca
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB3B3B3);
  static const divider = Color(0xFF2A2A2A);
  static const miniPlayerNavy = Color(0xFF15335C); // fondo "A continuación"
  static const familiarBadge = Color(0xFFC9A6FF); // pill "Familiar"
  static const avatarBlue = Color(0xFF3B82C4);

  // Gradientes usados como placeholder de "carátulas" de álbum
  static const List<List<Color>> artworkGradients = [
    [Color(0xFF8E44AD), Color(0xFF1B1464)],
    [Color(0xFFE74C3C), Color(0xFF6B1E07)],
    [Color(0xFF16A085), Color(0xFF0B3D2E)],
    [Color(0xFFF39C12), Color(0xFF7A4300)],
    [Color(0xFF2980B9), Color(0xFF0B2545)],
    [Color(0xFFD35400), Color(0xFF4A1B00)],
    [Color(0xFF27AE60), Color(0xFF0E4429)],
    [Color(0xFF8E44AD), Color(0xFF2C0735)],
    [Color(0xFF1F3B73), Color(0xFF0A1530)],
    [Color(0xFF5D4037), Color(0xFF2C1B12)],
  ];
}

class SpotifyTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SpotifyColors.background,
      fontFamily: 'Roboto', // Spotify usa "Circular"; Roboto es el fallback más cercano
      colorScheme: const ColorScheme.dark(
        primary: SpotifyColors.green,
        surface: SpotifyColors.surface,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}

/// ------------------------------------------------------------
/// MODELOS DE DATOS MOCK (solo para poblar la vista)
/// ------------------------------------------------------------

/// Tile de la grilla "reproducido recientemente".
class _RecentTile {
  final String title;
  final int gradientIndex;
  final IconData icon;
  final String? overlayLabel; // etiqueta de color sobre la miniatura
  final Color? overlayColor;
  final bool hasDot; // punto azul de novedad

  const _RecentTile(
    this.title,
    this.gradientIndex, {
    this.icon = Icons.image_outlined,
    this.overlayLabel,
    this.overlayColor,
    this.hasDot = false,
  });
}

const _recentlyPlayed = <_RecentTile>[
  _RecentTile('Mix: Silvestre Dangond', 8),
  _RecentTile(
    'Mix diario 1',
    1,
    overlayLabel: 'Mix diario 1',
    overlayColor: Color(0xFF29B6D8),
  ),
  _RecentTile(
    'Diomedes Diaz Mix',
    9,
    overlayLabel: 'Diomedes Diaz Mix',
    overlayColor: Color(0xFFB768C7),
  ),
  _RecentTile('El Fuete', 3),
  _RecentTile('Tus me gusta', 0, icon: Icons.favorite),
  _RecentTile('Mix: Salsa', 5, hasDot: true),
  _RecentTile('El Pluma Blanca', 2),
  _RecentTile(
    'Pura Adrenalina',
    4,
    overlayLabel: 'Pura Adrenalina',
    overlayColor: Color(0xFFE86AA6),
  ),
];

/// Tarjeta de "Tus mixes más escuchados": título incrustado como
/// etiqueta de color sobre la carátula + subtítulo de artistas.
class _MixCard {
  final String label;
  final Color labelColor;
  final Color labelTextColor;
  final String artists;
  final int gradientIndex;

  const _MixCard({
    required this.label,
    required this.labelColor,
    required this.artists,
    required this.gradientIndex,
    this.labelTextColor = Colors.black,
  });
}

const _topMixes = <_MixCard>[
  _MixCard(
    label: 'Churo Diaz Mix',
    labelColor: Color(0xFFE85AA0),
    artists: 'Beto & Franco, El Gran Martín Elías y Luifer Cuello',
    gradientIndex: 4,
  ),
  _MixCard(
    label: 'Mix cumbia',
    labelColor: Color(0xFFD9D9F3),
    artists: 'Los Ángeles Azules, Los del Fuego, Rafa Perez y…',
    gradientIndex: 8,
  ),
  _MixCard(
    label: 'Mix de alegorías',
    labelColor: Color(0xFFF4D53E),
    artists: 'Los Fabulosos, Bomba Estéreo',
    gradientIndex: 5,
  ),
];

/// Tile plano de "Vuelve a tu música" — solo carátula, sin texto
/// (el título ya viene incrustado en la portada, como en la app real).
const _jumpBackIn = <_RecentTile>[
  _RecentTile('Jorge Oñate', 6, icon: Icons.person),
  _RecentTile('Dúo Vallenato', 2),
  _RecentTile('Álbum del Cañón', 3),
];

/// ------------------------------------------------------------
/// VISTA PRINCIPAL
/// ------------------------------------------------------------
class SpotifyHomeView extends StatelessWidget {
  const SpotifyHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Únicamente para poder abrir el Drawer al tocar el avatar:
    // es plomería estándar de navegación de Flutter, no lógica
    // de negocio ni manejo de estado.
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: SpotifyColors.background,
      drawer: const _SpotifySideNav(),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Barra superior: avatar + chips de categoría (sin saludo ni iconos)
            SliverToBoxAdapter(
              child: _TopBar(
                onAvatarTap: () => scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Grid 2xN de "reproducido recientemente"
            SliverToBoxAdapter(
              child: _RecentlyPlayedGrid(items: _recentlyPlayed),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // "Tus mixes más escuchados" — tarjetas con etiqueta incrustada
            SliverToBoxAdapter(
              child: _MixSection(
                title: 'Tus mixes más escuchados',
                items: _topMixes,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // "Vuelve a tu música" — tarjetas planas sin texto
            SliverToBoxAdapter(
              child: _PlainArtworkSection(
                title: 'Vuelve a tu música',
                items: _jumpBackIn,
              ),
            ),

            // Espacio final para que el mini-reproductor no tape contenido
            const SliverToBoxAdapter(child: SizedBox(height: 140)),
          ],
        ),
      ),

      // Mini-reproductor + barra de navegación inferior
      bottomNavigationBar: const _BottomArea(),
    );
  }
}

/// ------------------------------------------------------------
/// BARRA SUPERIOR — avatar + chips (sin saludo ni iconos laterales)
/// ------------------------------------------------------------
class _TopBar extends StatelessWidget {
  final VoidCallback onAvatarTap;
  const _TopBar({required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            // Avatar de usuario — abre el nav lateral
            GestureDetector(
              onTap: onAvatarTap,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: SpotifyColors.avatarBlue,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'P',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Chips de categoría, scrolleables horizontalmente
            Expanded(child: _CategoryChips()),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// CHIPS DE CATEGORÍA
/// ------------------------------------------------------------
class _CategoryChips extends StatelessWidget {
  static const _labels = ['Todas', 'Música', 'Podcasts'];
  static const _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(right: 16),
      itemCount: _labels.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final selected = index == _selectedIndex;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? SpotifyColors.green : SpotifyColors.surfaceHigh,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            _labels[index],
            style: TextStyle(
              color: selected ? Colors.black : SpotifyColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}

/// ------------------------------------------------------------
/// GRID DE "REPRODUCIDO RECIENTEMENTE" (2 columnas, tarjetas rectangulares)
/// ------------------------------------------------------------
class _RecentlyPlayedGrid extends StatelessWidget {
  final List<_RecentTile> items;
  const _RecentlyPlayedGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.9,
        ),
        itemBuilder: (context, index) => _RecentlyPlayedTile(item: items[index]),
      ),
    );
  }
}

class _RecentlyPlayedTile extends StatelessWidget {
  final _RecentTile item;
  const _RecentlyPlayedTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final gradient = SpotifyColors.artworkGradients[item.gradientIndex];
    return Material(
      color: SpotifyColors.surfaceHigh,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {}, // sin lógica: solo diseño
        child: Row(
          children: [
            // Miniatura cuadrada con gradiente + posible etiqueta de color
            SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(4),
                      ),
                    ),
                    child: Icon(item.icon, color: Colors.white54, size: 18),
                  ),
                  if (item.overlayLabel != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: item.overlayColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 2,
                        ),
                        child: Text(
                          item.overlayLabel!,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 6.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: SpotifyColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
            if (item.hasDot)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3D91F4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// SECCIÓN "TUS MIXES MÁS ESCUCHADOS" — carátula + badge Spotify
/// + etiqueta de color incrustada + subtítulo de artistas
/// ------------------------------------------------------------
class _MixSection extends StatelessWidget {
  final String title;
  final List<_MixCard> items;
  const _MixSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: SpotifyColors.textPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => _MixArtworkCard(item: items[index]),
          ),
        ),
      ],
    );
  }
}

class _MixArtworkCard extends StatelessWidget {
  final _MixCard item;
  const _MixArtworkCard({required this.item});

  static const _cardWidth = 148.0;

  @override
  Widget build(BuildContext context) {
    final gradient = SpotifyColors.artworkGradients[item.gradientIndex];
    return SizedBox(
      width: _cardWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {}, // sin lógica: solo diseño
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: _cardWidth,
                height: _cardWidth,
                child: Stack(
                  children: [
                    // Carátula
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    // Badge de Spotify (esquina superior izquierda)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.podcasts,
                          size: 13,
                          color: SpotifyColors.green,
                        ),
                      ),
                    ),
                    // Etiqueta de color con el título del mix
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: item.labelColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: item.labelTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.artists,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: SpotifyColors.textSecondary,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// SECCIÓN "VUELVE A TU MÚSICA" — carátulas planas, sin texto
/// (el título ya está incrustado en la portada, como en la app real)
/// ------------------------------------------------------------
class _PlainArtworkSection extends StatelessWidget {
  final String title;
  final List<_RecentTile> items;
  const _PlainArtworkSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: SpotifyColors.textPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 148,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              final gradient = SpotifyColors.artworkGradients[item.gradientIndex];
              return Container(
                width: 148,
                height: 148,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(item.icon, color: Colors.white38, size: 34),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// ------------------------------------------------------------
/// ÁREA INFERIOR: MINI-REPRODUCTOR + BARRA DE NAVEGACIÓN
/// ------------------------------------------------------------
class _BottomArea extends StatelessWidget {
  const _BottomArea();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _MiniPlayerBar(),
        _BottomNavBar(),
      ],
    );
  }
}

/// Mini-reproductor en su variante "A continuación" (DJ de Spotify):
/// fondo azul marino, ícono circular tipo orbe y controles de cast/play.
class _MiniPlayerBar extends StatelessWidget {
  const _MiniPlayerBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: SpotifyColors.miniPlayerNavy,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Ícono orbe circular (DJ)
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFF00E0B0), Color(0xFF00796B)],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Título + subtítulo
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A continuación',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: SpotifyColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'DJ Livi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: SpotifyColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Controles: dispositivo de reproducción + play
          const Icon(Icons.cast, color: SpotifyColors.textPrimary, size: 22),
          const SizedBox(width: 18),
          const Icon(Icons.play_arrow, color: SpotifyColors.textPrimary, size: 26),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  static const _items = [
    (icon: Icons.home_filled, label: 'Inicio', selected: true),
    (icon: Icons.search, label: 'Buscar', selected: false),
    (icon: Icons.library_music_outlined, label: 'Tu biblioteca', selected: false),
    (icon: Icons.add_box_outlined, label: 'Crear', selected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SpotifyColors.black,
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items.map((item) {
          final color = item.selected
              ? SpotifyColors.textPrimary
              : SpotifyColors.textSecondary;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: item.selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// NAV LATERAL (Drawer de perfil) — se abre al tocar el avatar
/// ------------------------------------------------------------
class _SpotifySideNav extends StatelessWidget {
  const _SpotifySideNav();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: SpotifyColors.drawerBackground,
      width: MediaQuery.of(context).size.width * 0.82,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado: avatar + nombre + "Ver perfil"
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: SpotifyColors.avatarBlue,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'P',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pablo',
                        style: TextStyle(
                          color: SpotifyColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Ver perfil',
                        style: TextStyle(
                          color: SpotifyColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: SpotifyColors.divider, height: 1),
              const SizedBox(height: 20),

              // Lista de opciones de cuenta
              const _SideNavItem(
                icon: Icons.add,
                title: 'Agregar cuenta',
                subtitle: 'Agrega a un menor o a alguien más.',
              ),
              const SizedBox(height: 22),
              _SideNavItem(
                icon: Icons.podcasts,
                title: 'Tu Premium',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: SpotifyColors.familiarBadge,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Familiar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const _SideNavItem(
                icon: Icons.show_chart,
                title: 'Estadísticas de reproducción',
              ),
              const SizedBox(height: 22),
              const _SideNavItem(
                icon: Icons.history,
                title: 'Recientes',
              ),
              const SizedBox(height: 22),
              const _SideNavItem(
                icon: Icons.campaign_outlined,
                title: 'Tus avisos',
              ),
              const SizedBox(height: 22),
              const _SideNavItem(
                icon: Icons.settings_outlined,
                title: 'Configuración y privacidad',
              ),
              const SizedBox(height: 28),

              // Accesos rápidos: Actividad / Invitar a amigos
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: SpotifyColors.avatarBlue.withOpacity(0.55),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'P',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Actividad',
                        style: TextStyle(
                          color: SpotifyColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Activar',
                        style: TextStyle(
                          color: SpotifyColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 28),
                  Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: SpotifyColors.surfaceHigh,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          color: SpotifyColors.textPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Invitar a',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: SpotifyColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'amigos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: SpotifyColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Sección "Mensajes"
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Mensajes',
                              style: TextStyle(
                                color: SpotifyColors.textPrimary,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.chevron_right,
                              color: SpotifyColors.textPrimary,
                              size: 20,
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Comparte lo que te gusta con tus personas '
                          'favoritas en Spotify.',
                          style: TextStyle(
                            color: SpotifyColors.textSecondary,
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: SpotifyColors.surfaceHigh,
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      color: SpotifyColors.textPrimary,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Fila "Nuevo mensaje"
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: SpotifyColors.surfaceHigh,
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      color: SpotifyColors.textPrimary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Nuevo mensaje',
                    style: TextStyle(
                      color: SpotifyColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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

/// Fila reutilizable de ítem del nav lateral: icono + título (+ subtítulo
/// opcional) + widget final opcional (p. ej. el badge "Familiar").
class _SideNavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _SideNavItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // sin lógica: solo diseño
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: SpotifyColors.textPrimary, size: 24),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: SpotifyColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: SpotifyColors.textSecondary,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}