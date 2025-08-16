import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _userName = '';
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final repository = sl<AuthRepository>();
      final profile = await repository.getUserProfile();
      if (profile != null && mounted) {
        setState(() {
          _userName = profile.displayName;
          _greeting = _getGreeting();
        });
      }
    } catch (e) {
      // Silently handle error
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    return hour < 6
        ? 'Buenas noches'
        : hour < 12
            ? 'Buenos días'
            : hour < 18
                ? 'Buenas tardes'
                : 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(_userName.isNotEmpty ? 'Hola, $_userName' : 'Panel Principal'),
        backgroundColor: AppColors.mediumBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go(RouteNames.login);
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.paleBlue.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.mediumBlue, AppColors.lightBlue],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mediumBlue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.dashboard_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _greeting.isNotEmpty && _userName.isNotEmpty
                                      ? '$_greeting, $_userName!'
                                      : '¡Bienvenido!',
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Tu aplicación personal está lista',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(),

                const SizedBox(height: 32),

                // Secciones Principales
                Text(
                  'Secciones Principales',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

                const SizedBox(height: 16),

                // Grid para secciones principales (2 columnas)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildMainSectionCard(
                      context,
                      icon: Icons.route_rounded,
                      title: 'Rutas',
                      subtitle: '',
                      color: AppColors.mediumBlue,
                      onTap: () {
                        _navigateToRoutes(context);
                      },
                    ).animate().fadeIn(delay: 300.ms, duration: 600.ms).scale(),
                    _buildMainSectionCard(
                      context,
                      icon: Icons.account_balance_rounded,
                      title: 'Congregaciones',
                      subtitle: '',
                      color: AppColors.lightBlue,
                      onTap: () {
                        _navigateToCongregations(context);
                      },
                    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).scale(),
                    _buildMainSectionCard(
                      context,
                      icon: Icons.event_rounded,
                      title: 'Asambleas',
                      subtitle: '',
                      color: AppColors.darkBlue,
                      onTap: () {
                        _navigateToAssamblies(context);
                      },
                    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).scale(),
                  ],
                ),

                const SizedBox(height: 32),

                // // Acciones Rápidas
                // Text(
                //   'Acceso Rápido',
                //   style: theme.textTheme.titleLarge?.copyWith(
                //     fontWeight: FontWeight.bold,
                //     color: AppColors.darkBlue,
                //   ),
                // ).animate().fadeIn(delay: 500.ms, duration: 600.ms),

                // const SizedBox(height: 16),

                // // Grid para acciones rápidas (3 columnas para cards más pequeñas)
                // GridView.count(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   crossAxisCount: 2,
                //   crossAxisSpacing: 16,
                //   mainAxisSpacing: 16,
                //   childAspectRatio: 1.1,
                //   children: [
                //     _buildQuickActionCard(
                //       context,
                //       icon: Icons.person_rounded,
                //       title: 'Mi Perfil',
                //       color: AppColors.darkBlue,
                //       onTap: () {
                //         _showProfileDialog(context);
                //       },
                //     ).animate().fadeIn(delay: 600.ms, duration: 600.ms).scale(),
                //     _buildQuickActionCard(
                //       context,
                //       icon: Icons.settings_rounded,
                //       title: 'Configuración',
                //       color: AppColors.mediumBlue,
                //       onTap: () {
                //         _showInfoDialog(context, 'Configuración',
                //             'Ajustes de la aplicación');
                //       },
                //     ).animate().fadeIn(delay: 700.ms, duration: 600.ms).scale(),
                //     _buildQuickActionCard(
                //       context,
                //       icon: Icons.help_rounded,
                //       title: 'Ayuda',
                //       color: AppColors.paleBlue.withOpacity(0.8),
                //       onTap: () {
                //         _showInfoDialog(
                //             context, 'Ayuda', 'Centro de soporte y ayuda');
                //       },
                //     ).animate().fadeIn(delay: 800.ms, duration: 600.ms).scale(),
                //   ],
                // ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para secciones principales (más grandes)
  Widget _buildMainSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para acciones rápidas (más pequeñas)
  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.7),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRoutes(BuildContext context) {
    context.go(RouteNames.routes);
  }

  // Navegación a congregaciones
  void _navigateToCongregations(BuildContext context) {
    context.go(RouteNames.congregations);
  }

  // Navegación a Asambleas
  void _navigateToAssamblies(BuildContext context) {
    context.go(RouteNames.assemblies);
  }

  Widget _buildFeatureItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) async {
    try {
      final repository = sl<AuthRepository>();
      final profile = await repository.getUserProfile();

      if (profile != null && context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: AppColors.mediumBlue,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Mi Perfil'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileItem('Nombre completo', profile.fullName),
                const SizedBox(height: 12),
                _buildProfileItem('Como te decimos', profile.displayName),
                const SizedBox(height: 12),
                _buildProfileItem('Fecha de registro',
                    '${profile.createdAt.day}/${profile.createdAt.month}/${profile.createdAt.year}'),
                const SizedBox(height: 12),
                _buildProfileItem('Último acceso',
                    '${profile.lastLogin.day}/${profile.lastLogin.month}/${profile.lastLogin.year}'),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showChangeCodeDialog(context);
                },
                child: const Text('Cambiar Código'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showInfoDialog(
          context, 'Error', 'No se pudo cargar la información del perfil');
    }
  }

  Widget _buildProfileItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.mediumBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showChangeCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Código'),
        content: const Text(
          'Esta funcionalidad estará disponible en una próxima actualización.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
