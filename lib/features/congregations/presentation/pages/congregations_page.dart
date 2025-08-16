import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/congregation_entity.dart';
import '../providers/congregations_notifier.dart';
import '../widgets/create_congregation_dialog.dart';
import '../widgets/edit_congregation_dialog.dart';
import '../widgets/congregation_card.dart';
import '../pages/congregation_details_page.dart';
import '../providers/congregation_details_notifier.dart';

class CongregationsPage extends ConsumerStatefulWidget {
  const CongregationsPage({super.key});

  @override
  ConsumerState<CongregationsPage> createState() => _CongregationsPageState();
}

class _CongregationsPageState extends ConsumerState<CongregationsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar congregaciones al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(congregationsNotifierProvider.notifier).loadCongregations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final congregationsState = ref.watch(congregationsNotifierProvider);
    final theme = Theme.of(context);

    ref.listen<CongregationsState>(congregationsNotifierProvider,
        (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        ref.read(congregationsNotifierProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Congregaciones'),
        backgroundColor: AppColors.lightBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.home);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: () {
              context.go(RouteNames.home);
            },
            tooltip: 'Ir al inicio',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref
                  .read(congregationsNotifierProvider.notifier)
                  .loadCongregations();
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightBlue.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header con estadísticas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.lightBlue, AppColors.paleBlue],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightBlue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
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
                          'Gestión de Congregaciones',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${congregationsState.congregations.length} congregación${congregationsState.congregations.length == 1 ? '' : 'es'} registrada${congregationsState.congregations.length == 1 ? '' : 's'}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(),

            // Lista de congregaciones
            Expanded(
              child: congregationsState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : congregationsState.congregations.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () async {
                            ref
                                .read(congregationsNotifierProvider.notifier)
                                .loadCongregations();
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: congregationsState.congregations.length,
                            itemBuilder: (context, index) {
                              final congregation =
                                  congregationsState.congregations[index];
                              return CongregationCard(
                                congregation: congregation,
                                onEdit: () => _showEditDialog(congregation),
                                onDelete: () => _showDeleteDialog(congregation),
                                onViewDetails: () =>
                                    _navigateToDetails(congregation),
                              )
                                  .animate()
                                  .fadeIn(
                                    delay: Duration(milliseconds: 100 * index),
                                    duration: 600.ms,
                                  )
                                  .slideX();
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        backgroundColor: AppColors.lightBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva Congregación'),
      ).animate().scale(delay: 800.ms, duration: 400.ms),
    );
  }

  void _navigateToDetails(CongregationEntity congregation) {
    print('Hereeeee');
    context.go(
      '/congregations/details/${congregation.id}',
      extra: {
        'congregation': congregation,
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.paleBlue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.account_balance_rounded,
              size: 80,
              color: AppColors.lightBlue.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay congregaciones registradas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primera congregación para comenzar',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.lightBlue,
                ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showCreateDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Crear Primera Congregación'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 800.ms);
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateCongregationDialog(
        onCongregationCreated: () {
          ref.read(congregationsNotifierProvider.notifier).loadCongregations();
        },
      ),
    );
  }

  void _showEditDialog(CongregationEntity congregation) {
    showDialog(
      context: context,
      builder: (context) => EditCongregationDialog(
        congregation: congregation,
        onCongregationUpdated: () {
          ref.read(congregationsNotifierProvider.notifier).loadCongregations();
        },
      ),
    );
  }

  void _showDeleteDialog(CongregationEntity congregation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Congregación'),
        content: Text(
            '¿Estás seguro de que quieres eliminar la congregación "${congregation.nombre}"?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await ref
                  .read(congregationsNotifierProvider.notifier)
                  .deleteCongregation(congregation.id);

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Congregación eliminada exitosamente'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
