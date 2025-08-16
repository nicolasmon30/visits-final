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
    _loadData();
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

  void _loadData() {
    // Cargar los datos guardados de la congregación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(congregationDetailsNotifierProvider.notifier)
          .loadDetails(widget.congregation.id);
    });
  }

  @override
  void dispose() {
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
        ref.read(congregationDetailsNotifierProvider.notifier).clearError();
      }
    });

    // Cargar datos en los controllers cuando se obtengan los detalles
    if (detailsState.details != null &&
        !detailsState.isLoading &&
        !_isDataLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateControllers(detailsState.details!);
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
            onPressed: () => context.go(RouteNames.home),
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
        child: detailsState.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  controller: _scrollController,
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

                      const SizedBox(height: 100), // Espacio para el FAB
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: _hasChanges
          ? FloatingActionButton.extended(
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
              label: Text(
                  detailsState.isSaving ? 'Guardando...' : 'Guardar Cambios'),
            ).animate().scale(duration: 300.ms)
          : null,
    );
  }

  void _populateControllers(CongregationDetailsEntity details) {
    // Solo poblar si los controllers están vacíos (primera carga)
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

  void _showUnsavedChangesDialog() {
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
              _goBack();
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

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.congregations);
    }
  }
}
