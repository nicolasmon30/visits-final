import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/congregation_entity.dart';
import '../../domain/entities/congregation_details_entity.dart';
import '../providers/congregation_details_notifier.dart';
import '../../../recommendations/domain/entities/recommendation_entity.dart';
import '../../../recommendations/presentation/providers/recommendations_notifier.dart';
import '../../../recommendations/presentation/widgets/create_recommendation_dialog.dart';
import '../../../recommendations/presentation/widgets/edit_recommendation_dialog.dart';
import '../../../recommendations/presentation/widgets/recommendation_card.dart';

class CongregationDetailsPage extends ConsumerStatefulWidget {
  final CongregationEntity congregation;

  const CongregationDetailsPage({
    super.key,
    required this.congregation,
  });

  @override
  ConsumerState<CongregationDetailsPage> createState() =>
      _CongregationDetailsPageState();
}

class _CongregationDetailsPageState
    extends ConsumerState<CongregationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controllers para text areas
  final _aspectosPositivosController = TextEditingController();
  final _aspectosAMejorarController = TextEditingController();

  // Controllers para cada sección (6 inputs cada una)
  final Map<String, List<TextEditingController>> _controllers = {};

  bool _hasChanges = false;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataSequentially();
    });
  }

  void _initializeControllers() {
    final sections = [
      'reunionEntreSemana',
      'reunionFinDeSemana',
      'cursosBiblicos',
      'publicadoresDirigenCursos',
      'precursoresEspeciales',
      'precursoresRegulares',
      'precursoresAuxiliares',
      'totalPublicadores',
      'publicadoresNuevos',
      'publicadoresIrregulares',
      'publicadoresInactivos',
      'publicadoresReactivados',
      'readmitidos',
      'ancianos',
      'siervosMinisteriales',
    ];

    for (String section in sections) {
      _controllers[section] =
          List.generate(6, (index) => TextEditingController());
    }

    // Agregar listeners para detectar cambios
    for (var sectionControllers in _controllers.values) {
      for (var controller in sectionControllers) {
        controller.addListener(_onDataChanged);
      }
    }

    _aspectosPositivosController.addListener(_onDataChanged);
    _aspectosAMejorarController.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    if (_isDataLoaded && !_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  // void _loadData() {
  //   // Limpiar el estado anterior y cargar los datos de esta congregación
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Primero limpiar el estado
  //     ref.read(congregationDetailsNotifierProvider.notifier).clearState();
  //     ref.read(recommendationsNotifierProvider.notifier).clearState();

  //     // Luego cargar los datos específicos de esta congregación
  //     ref
  //         .read(congregationDetailsNotifierProvider.notifier)
  //         .loadDetails(widget.congregation.id);

  //     ref
  //         .read(recommendationsNotifierProvider.notifier)
  //         .loadRecommendations(widget.congregation.id);
  //   });
  // }

  Future<void> _loadDataSequentially() async {
    if (!mounted) return;

    try {
      print(
          'Starting sequential data load for congregation: ${widget.congregation.id}');

      // 1. Primero limpiar todos los estados
      print('🧹 Clearing states...');
      ref.read(congregationDetailsNotifierProvider.notifier).clearState();
      ref.read(recommendationsNotifierProvider.notifier).clearState();

      // 2. Esperar un frame para que se limpien los estados
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) {
        print('❌ Widget unmounted during state clearing');
        return;
      }

      // 3. Cargar detalles de congregación primero
      print('Loading congregation details...');
      await ref
          .read(congregationDetailsNotifierProvider.notifier)
          .loadDetails(widget.congregation.id);

      if (!mounted) {
        print('❌ Widget unmounted during details loading');
        return;
      }

      final detailsState = ref.read(congregationDetailsNotifierProvider);
      print(
          '📊 Details state: loading=${detailsState.isLoading}, hasDetails=${detailsState.details != null}, congregationId=${detailsState.currentCongregationId}');

      // 4. Esperar un poco más para que se estabilice el estado
      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) {
        print('❌ Widget unmounted before recommendations loading');
        return;
      }

      // 5. Luego cargar recomendaciones
      print('Loading recommendations...');
      await ref
          .read(recommendationsNotifierProvider.notifier)
          .loadRecommendations(widget.congregation.id);

      print('Sequential data load completed');
    } catch (e) {
      print('Error loading congregation data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cargando datos: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  // Eliminar el método _loadData() anterior y usar este:
  Future<void> _reloadData() async {
    await _loadDataSequentially();
  }

  @override
  void deactivate() {
    // Solo limpiar si realmente estamos saliendo de la página
    if (!mounted) {
      try {
        ref.read(congregationDetailsNotifierProvider.notifier).clearState();
        ref.read(recommendationsNotifierProvider.notifier).clearState();
      } catch (e) {
        // Silently handle if ref is already disposed
      }
    }
    super.deactivate();
  }

  @override
  void dispose() {
    try {
      ref.read(congregationDetailsNotifierProvider.notifier).clearState();
      ref.read(recommendationsNotifierProvider.notifier).clearState();
    } catch (e) {
      // Silently handle if ref is already disposed
    }
    _scrollController.dispose();
    _aspectosPositivosController.dispose();
    _aspectosAMejorarController.dispose();

    for (var sectionControllers in _controllers.values) {
      for (var controller in sectionControllers) {
        controller.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detailsState = ref.watch(congregationDetailsNotifierProvider);

    // Listener para errores
    ref.listen<CongregationDetailsState>(congregationDetailsNotifierProvider,
        (previous, next) {
      if (next.error != null && mounted) {
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
        ref.read(congregationDetailsNotifierProvider.notifier).clearError();
      }
    });

    // Cargar datos en los controllers cuando se obtengan los detalles
    // SOLO si es para la congregación correcta
    if (detailsState.details != null &&
        !detailsState.isLoading &&
        !_isDataLoaded &&
        detailsState.currentCongregationId == widget.congregation.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _populateControllers(detailsState.details!);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.congregation.nombre),
        backgroundColor: AppColors.lightBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_hasChanges) {
              _showUnsavedChangesDialog();
            } else {
              _goBack();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: _handleHomePressed,
            tooltip: 'Ir al inicio',
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
        child: _buildBody(detailsState),
      ),
      floatingActionButton: _buildFloatingActionButton(detailsState),
    );
  }

  Widget? _buildFloatingActionButton(CongregationDetailsState detailsState) {
    if (!_hasChanges) return null;

    return FloatingActionButton.extended(
      onPressed: detailsState.isSaving ? null : _saveData,
      backgroundColor: AppColors.lightBlue,
      foregroundColor: Colors.white,
      icon: detailsState.isSaving
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.save_rounded),
      label: Text(detailsState.isSaving ? 'Guardando...' : 'Guardar Cambios'),
    ).animate().scale(duration: 300.ms);
  }

  Widget _buildBody(CongregationDetailsState detailsState) {
    // Mostrar loading mientras se cargan los datos iniciales
    if (detailsState.isLoading ||
        (detailsState.currentCongregationId != widget.congregation.id &&
            detailsState.details == null)) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando detalles de la congregación...'),
          ],
        ),
      );
    }

    // Verificar que tenemos datos válidos antes de mostrar el formulario
    if (detailsState.details == null ||
        detailsState.currentCongregationId != widget.congregation.id) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text('Error cargando los datos de la congregación'),
          ],
        ),
      );
    }

    // Solo renderizar el formulario cuando los datos están listos
    return SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 24),

                // Reuniones
                _buildSection(
                  title: 'Reunión Entre Semana',
                  subtitle: 'Asistencia promedio semanal',
                  icon: Icons.calendar_view_week_rounded,
                  sectionKey: 'reunionEntreSemana',
                  color: AppColors.mediumBlue,
                ),

                _buildSection(
                  title: 'Reunión Fin De Semana',
                  subtitle: 'Asistencia promedio de fin de semana',
                  icon: Icons.weekend_rounded,
                  sectionKey: 'reunionFinDeSemana',
                  color: AppColors.lightBlue,
                ),

                // Cursos y Publicadores
                _buildSection(
                  title: 'Cursos Bíblicos',
                  subtitle: 'Número de cursos bíblicos activos',
                  icon: Icons.menu_book_rounded,
                  sectionKey: 'cursosBiblicos',
                  color: AppColors.darkBlue,
                ),

                _buildSection(
                  title: 'Publicadores que Dirigen Cursos Bíblicos',
                  subtitle: 'Publicadores activos en la enseñanza',
                  icon: Icons.school_rounded,
                  sectionKey: 'publicadoresDirigenCursos',
                  color: AppColors.mediumBlue,
                ),

                // Precursores
                _buildSection(
                  title: 'Precursores Especiales',
                  subtitle: 'Precursores de tiempo completo',
                  icon: Icons.star_rounded,
                  sectionKey: 'precursoresEspeciales',
                  color: AppColors.lightBlue,
                ),

                _buildSection(
                  title: 'Precursores Regulares',
                  subtitle: 'Precursores regulares activos',
                  icon: Icons.stars_rounded,
                  sectionKey: 'precursoresRegulares',
                  color: AppColors.darkBlue,
                ),

                _buildSection(
                  title: 'Precursores Auxiliares',
                  subtitle: 'Precursores auxiliares del mes',
                  icon: Icons.volunteer_activism_rounded,
                  sectionKey: 'precursoresAuxiliares',
                  color: AppColors.mediumBlue,
                ),

                // Publicadores
                _buildSection(
                  title: 'Total Publicadores',
                  subtitle: 'Todos los publicadores activos',
                  icon: Icons.groups_rounded,
                  sectionKey: 'totalPublicadores',
                  color: AppColors.lightBlue,
                ),

                _buildSection(
                  title: 'Publicadores Nuevos',
                  subtitle: 'Nuevos publicadores este período',
                  icon: Icons.person_add_rounded,
                  sectionKey: 'publicadoresNuevos',
                  color: AppColors.darkBlue,
                ),

                _buildSection(
                  title: 'Publicadores Irregulares',
                  subtitle: 'Publicadores con actividad irregular',
                  icon: Icons.warning_amber_rounded,
                  sectionKey: 'publicadoresIrregulares',
                  color: Colors.orange,
                ),

                _buildSection(
                  title: 'Publicadores Inactivos',
                  subtitle: 'Publicadores sin actividad reportada',
                  icon: Icons.person_off_rounded,
                  sectionKey: 'publicadoresInactivos',
                  color: Colors.red,
                ),

                _buildSection(
                  title: 'Publicadores Reactivados',
                  subtitle: 'Publicadores que retomaron la actividad',
                  icon: Icons.refresh_rounded,
                  sectionKey: 'publicadoresReactivados',
                  color: Colors.green,
                ),

                _buildSection(
                  title: 'Readmitidos',
                  subtitle: 'Personas readmitidas en la congregación',
                  icon: Icons.how_to_reg_rounded,
                  sectionKey: 'readmitidos',
                  color: AppColors.mediumBlue,
                ),

                // Nombramientos
                _buildSection(
                  title: 'Ancianos',
                  subtitle: 'Ancianos activos en la congregación',
                  icon: Icons.admin_panel_settings_rounded,
                  sectionKey: 'ancianos',
                  color: AppColors.lightBlue,
                ),

                _buildSection(
                  title: 'Siervos Ministeriales',
                  subtitle: 'Siervos ministeriales activos',
                  icon: Icons.support_agent_rounded,
                  sectionKey: 'siervosMinisteriales',
                  color: AppColors.darkBlue,
                ),

                // Text Areas
                const SizedBox(height: 32),
                _buildTextAreaSection(),

                // Recomendaciones Section
                const SizedBox(height: 32),
                _buildRecommendationsSection(),

                const SizedBox(height: 100), // Espacio para el FAB
              ],
            )),
      ),
    );
  }

// También necesitas actualizar el método _buildRecommendationsSection
  Widget _buildRecommendationsSection() {
    final recommendationsState = ref.watch(recommendationsNotifierProvider);
    final theme = Theme.of(context);

    // Listener para errores de recomendaciones en el build principal
    ref.listen<RecommendationsState>(recommendationsNotifierProvider,
        (previous, next) {
      if (next.error != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
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
            ref.read(recommendationsNotifierProvider.notifier).clearError();
          }
        });
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recomendaciones',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
            ),
            // Envolver el botón en un SizedBox para darle un ancho fijo
            SizedBox(
              width: 120, // Ancho fijo para evitar constraints infinitos
              child: ElevatedButton.icon(
                onPressed: recommendationsState.isLoading
                    ? null
                    : () => _showCreateRecommendationDialog(),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Contenido de recomendaciones
        _buildRecommendationsContent(recommendationsState, theme),
      ],
    ).animate().fadeIn(delay: Duration(milliseconds: 600), duration: 600.ms);
  }

  Widget _buildRecommendationsContent(
      RecommendationsState recommendationsState, ThemeData theme) {
    // Loading state
    if (recommendationsState.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando recomendaciones...'),
            ],
          ),
        ),
      );
    }

    // Error state
    if (recommendationsState.error != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Error cargando recomendaciones',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recommendationsState.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Empty state
    if (recommendationsState.recommendations.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.paleBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.lightBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.person_add_rounded,
              size: 48,
              color: AppColors.lightBlue.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay recomendaciones registradas',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega la primera recomendación para esta congregación',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.lightBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showCreateRecommendationDialog(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Crear Primera Recomendación'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Recommendations list
    return Column(
      children: [
        for (int index = 0;
            index < recommendationsState.recommendations.length;
            index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RecommendationCard(
              recommendation: recommendationsState.recommendations[index],
              onEdit: () => _showEditRecommendationDialog(
                  recommendationsState.recommendations[index]),
              onDelete: () => _showDeleteRecommendationDialog(
                  recommendationsState.recommendations[index]),
            )
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: 100 * index),
                  duration: 400.ms,
                )
                .slideX(),
          ),
      ],
    );
  }

  void _showCreateRecommendationDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateRecommendationDialog(
        congregationId: widget.congregation.id,
        onRecommendationCreated: () {
          ref
              .read(recommendationsNotifierProvider.notifier)
              .loadRecommendations(widget.congregation.id);
        },
      ),
    );
  }

  void _showEditRecommendationDialog(RecommendationEntity recommendation) {
    showDialog(
      context: context,
      builder: (context) => EditRecommendationDialog(
        recommendation: recommendation,
        onRecommendationUpdated: () {
          ref
              .read(recommendationsNotifierProvider.notifier)
              .loadRecommendations(widget.congregation.id);
        },
      ),
    );
  }

  void _showDeleteRecommendationDialog(RecommendationEntity recommendation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Recomendación'),
        content: Text(
            '¿Estás seguro de que quieres eliminar la recomendación de "${recommendation.titulo}"?'),
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
                  .read(recommendationsNotifierProvider.notifier)
                  .deleteRecommendation(
                      recommendation.id, widget.congregation.id);

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Recomendación eliminada exitosamente'),
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

  void _populateControllers(CongregationDetailsEntity details) {
    // Solo poblar si los controllers están vacíos (primera carga)
    if (details.congregationId != widget.congregation.id) {
      return; // No poblar si es de otra congregación
    }
    // Y si es para la congregación correcta
    if (!_isDataLoaded) {
      _populateSectionControllers(
          'reunionEntreSemana', details.reunionEntreSemana);
      _populateSectionControllers(
          'reunionFinDeSemana', details.reunionFinDeSemana);
      _populateSectionControllers('cursosBiblicos', details.cursosBiblicos);
      _populateSectionControllers(
          'publicadoresDirigenCursos', details.publicadoresDirigenCursos);
      _populateSectionControllers(
          'precursoresEspeciales', details.precursoresEspeciales);
      _populateSectionControllers(
          'precursoresRegulares', details.precursoresRegulares);
      _populateSectionControllers(
          'precursoresAuxiliares', details.precursoresAuxiliares);
      _populateSectionControllers(
          'totalPublicadores', details.totalPublicadores);
      _populateSectionControllers(
          'publicadoresNuevos', details.publicadoresNuevos);
      _populateSectionControllers(
          'publicadoresIrregulares', details.publicadoresIrregulares);
      _populateSectionControllers(
          'publicadoresInactivos', details.publicadoresInactivos);
      _populateSectionControllers(
          'publicadoresReactivados', details.publicadoresReactivados);
      _populateSectionControllers('readmitidos', details.readmitidos);
      _populateSectionControllers('ancianos', details.ancianos);
      _populateSectionControllers(
          'siervosMinisteriales', details.siervosMinisteriales);

      _aspectosPositivosController.text = details.aspectosPositivos ?? '';
      _aspectosAMejorarController.text = details.aspectosAMejorar ?? '';

      // Marcar como cargado y reset del flag de cambios
      setState(() {
        _isDataLoaded = true;
        _hasChanges = false;
      });
    }
  }

  void _populateSectionControllers(String section, List<double?> values) {
    for (int i = 0; i < 6 && i < values.length; i++) {
      if (values[i] != null) {
        _controllers[section]![i].text = values[i].toString();
      }
    }
  }

  List<double?> _getValuesFromControllers(String section) {
    return _controllers[section]!.map((controller) {
      if (controller.text.trim().isEmpty) return null;
      return double.tryParse(controller.text.trim());
    }).toList();
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
                  Icons.analytics_rounded,
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
                      'Detalles de Congregación',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Gestiona la información estadística',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    ).animate().fadeIn(duration: 600.ms).slideY();
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required String sectionKey,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header de la sección
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkBlue,
                                  ),
                        ),
                        Text(
                          subtitle,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: color,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Grid de 6 inputs
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return _buildNumberInput(
                    controller: _controllers[sectionKey]![index],
                    label: 'Mes ${index + 1}',
                    color: color,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 100), duration: 600.ms)
        .slideX();
  }

  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
    required Color color,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: color,
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        isDense: true,
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildTextAreaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Observaciones',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
        ),
        const SizedBox(height: 16),

        // Aspectos Positivos
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.green.withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.thumb_up_rounded,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Aspectos Positivos',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _aspectosPositivosController,
                  decoration: InputDecoration(
                    hintText: 'Describe los aspectos positivos observados...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                  maxLines: 4,
                  maxLength: 500,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Aspectos a Mejorar
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.orange.withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.trending_up_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Aspectos a Mejorar',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _aspectosAMejorarController,
                  decoration: InputDecoration(
                    hintText: 'Describe las áreas que necesitan atención...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.orange, width: 2),
                    ),
                  ),
                  maxLines: 4,
                  maxLength: 500,
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: Duration(milliseconds: 500), duration: 600.ms);
  }

  void _saveData() async {
    final currentDetailsState = ref.read(congregationDetailsNotifierProvider);
    if (currentDetailsState.isSaving) return;

    // Verificar que estamos guardando para la congregación correcta
    if (currentDetailsState.currentCongregationId != widget.congregation.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error: datos de congregación incorrectos'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    try {
      // Crear la entidad de detalles con los datos actuales
      final details = CongregationDetailsEntity(
        congregationId: widget.congregation.id,
        reunionEntreSemana: _getValuesFromControllers('reunionEntreSemana'),
        reunionFinDeSemana: _getValuesFromControllers('reunionFinDeSemana'),
        cursosBiblicos: _getValuesFromControllers('cursosBiblicos'),
        publicadoresDirigenCursos:
            _getValuesFromControllers('publicadoresDirigenCursos'),
        precursoresEspeciales:
            _getValuesFromControllers('precursoresEspeciales'),
        precursoresRegulares: _getValuesFromControllers('precursoresRegulares'),
        precursoresAuxiliares:
            _getValuesFromControllers('precursoresAuxiliares'),
        totalPublicadores: _getValuesFromControllers('totalPublicadores'),
        publicadoresNuevos: _getValuesFromControllers('publicadoresNuevos'),
        publicadoresIrregulares:
            _getValuesFromControllers('publicadoresIrregulares'),
        publicadoresInactivos:
            _getValuesFromControllers('publicadoresInactivos'),
        publicadoresReactivados:
            _getValuesFromControllers('publicadoresReactivados'),
        readmitidos: _getValuesFromControllers('readmitidos'),
        ancianos: _getValuesFromControllers('ancianos'),
        siervosMinisteriales: _getValuesFromControllers('siervosMinisteriales'),
        aspectosPositivos: _aspectosPositivosController.text.trim().isEmpty
            ? null
            : _aspectosPositivosController.text.trim(),
        aspectosAMejorar: _aspectosAMejorarController.text.trim().isEmpty
            ? null
            : _aspectosAMejorarController.text.trim(),
        createdAt: currentDetailsState.details?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await ref
          .read(congregationDetailsNotifierProvider.notifier)
          .saveDetails(details);

      if (success && mounted) {
        setState(() {
          _hasChanges = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Datos guardados exitosamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            action: SnackBarAction(
              label: 'Ver',
              textColor: Colors.white,
              onPressed: () {
                // Aquí podrías navegar a un resumen
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al guardar los datos'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _showUnsavedChangesDialog({bool goToHome = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambios sin guardar'),
        content: const Text(
          '¿Estás seguro de que quieres salir? Los cambios no guardados se perderán.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (goToHome) {
                _clearStatesAndNavigate(() => context.go(RouteNames.home));
              } else {
                _goBack();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Salir sin guardar'),
          ),
        ],
      ),
    );
  }

  void _handleHomePressed() {
    if (_hasChanges) {
      _showUnsavedChangesDialog(goToHome: true);
    } else {
      _clearStatesAndNavigate(() => context.go(RouteNames.home));
    }
  }

  void _clearStatesAndNavigate(VoidCallback navigationAction) {
    try {
      ref.read(congregationDetailsNotifierProvider.notifier).clearState();
      ref.read(recommendationsNotifierProvider.notifier).clearState();
    } catch (e) {
      // Silently handle if ref is already disposed
      print('Error clearing states: $e');
    }
    navigationAction();
  }

  void _goBack() {
    _clearStatesAndNavigate(() {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(RouteNames.congregations);
      }
    });
  }

  void _handleBackPressed() {
    if (_hasChanges) {
      _showUnsavedChangesDialog();
    } else {
      _goBack();
    }
  }
}
