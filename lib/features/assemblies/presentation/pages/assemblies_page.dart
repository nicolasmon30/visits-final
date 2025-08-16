import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/assembly_entity.dart';
import '../providers/assemblies_notifier.dart';
import '../widgets/create_assembly_dialog.dart';
import '../widgets/edit_assembly_dialog.dart';
import '../widgets/assembly_card.dart';

class AssembliesPage extends ConsumerStatefulWidget {
  const AssembliesPage({super.key});

  @override
  ConsumerState<AssembliesPage> createState() => _AssembliesPageState();
}

class _AssembliesPageState extends ConsumerState<AssembliesPage> {
  @override
  void initState() {
    super.initState();
    // Cargar asambleas al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(assembliesNotifierProvider.notifier).loadAssemblies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final assembliesState = ref.watch(assembliesNotifierProvider);
    final theme = Theme.of(context);

    ref.listen<AssembliesState>(assembliesNotifierProvider, (previous, next) {
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
        ref.read(assembliesNotifierProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asambleas'),
        backgroundColor: AppColors.darkBlue,
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
              ref.read(assembliesNotifierProvider.notifier).loadAssemblies();
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
              AppColors.darkBlue.withOpacity(0.1),
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
                  colors: [AppColors.darkBlue, AppColors.mediumBlue],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkBlue.withOpacity(0.3),
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
                      Icons.event_rounded,
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
                          'Gestión de Asambleas',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${assembliesState.assemblies.length} asamblea${assembliesState.assemblies.length == 1 ? '' : 's'} programada${assembliesState.assemblies.length == 1 ? '' : 's'}',
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

            // Lista de asambleas
            Expanded(
              child: assembliesState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : assembliesState.assemblies.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () async {
                            ref
                                .read(assembliesNotifierProvider.notifier)
                                .loadAssemblies();
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: assembliesState.assemblies.length,
                            itemBuilder: (context, index) {
                              final assembly =
                                  assembliesState.assemblies[index];
                              return AssemblyCard(
                                assembly: assembly,
                                onEdit: () => _showEditDialog(assembly),
                                onDelete: () => _showDeleteDialog(assembly),
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
        backgroundColor: AppColors.darkBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva Asamblea'),
      ).animate().scale(delay: 800.ms, duration: 400.ms),
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
              Icons.event_rounded,
              size: 80,
              color: AppColors.darkBlue.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay asambleas programadas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Programa tu primera asamblea para comenzar',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.mediumBlue,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 800.ms);
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateAssemblyDialog(
        onAssemblyCreated: () {
          ref.read(assembliesNotifierProvider.notifier).loadAssemblies();
        },
      ),
    );
  }

  void _showEditDialog(AssemblyEntity assembly) {
    showDialog(
      context: context,
      builder: (context) => EditAssemblyDialog(
        assembly: assembly,
        onAssemblyUpdated: () {
          ref.read(assembliesNotifierProvider.notifier).loadAssemblies();
        },
      ),
    );
  }

  void _showDeleteDialog(AssemblyEntity assembly) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Asamblea'),
        content: Text(
            '¿Estás seguro de que quieres eliminar la asamblea "${assembly.nombre}"?'),
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
                  .read(assembliesNotifierProvider.notifier)
                  .deleteAssembly(assembly.id);

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Asamblea eliminada exitosamente'),
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
