import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/routes_notifier.dart';

class CreateRouteDialog extends ConsumerStatefulWidget {
  final VoidCallback? onRouteCreated;

  const CreateRouteDialog({
    super.key,
    this.onRouteCreated,
  });

  @override
  ConsumerState<CreateRouteDialog> createState() => _CreateRouteDialogState();
}

class _CreateRouteDialogState extends ConsumerState<CreateRouteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _actividadController = TextEditingController();
  final _detallesController = TextEditingController();

  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  bool _jw = false;
  bool _aviso = false;
  bool _agenda = false;

  @override
  void dispose() {
    _actividadController.dispose();
    _detallesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routesState = ref.watch(routesNotifierProvider);
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.mediumBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.add_road_rounded,
                          color: AppColors.mediumBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Crear Nueva Ruta',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            Text(
                              'Completa la información de la ruta',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.mediumBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Campo Actividad (Requerido)
                  TextFormField(
                    controller: _actividadController,
                    decoration: InputDecoration(
                      labelText: 'Actividad *',
                      hintText: 'Ingresa el nombre de la actividad',
                      prefixIcon: const Icon(Icons.event_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La actividad es requerida';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Selección de fechas (Requerido)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.date_range_rounded,
                              color: AppColors.mediumBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Rango de Fechas *',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateButton(
                                context: context,
                                label: 'Fecha Inicio',
                                date: _fechaInicio,
                                onDateSelected: (date) {
                                  setState(() {
                                    _fechaInicio = date;
                                    // Si no hay fecha fin o es anterior, actualizar
                                    if (_fechaFin == null ||
                                        _fechaFin!.isBefore(date)) {
                                      _fechaFin = date;
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDateButton(
                                context: context,
                                label: 'Fecha Fin',
                                date: _fechaFin,
                                onDateSelected: (date) {
                                  setState(() {
                                    _fechaFin = date;
                                  });
                                },
                                minDate: _fechaInicio,
                              ),
                            ),
                          ],
                        ),
                        if (_fechaInicio != null && _fechaFin != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Duración: ${_fechaFin!.difference(_fechaInicio!).inDays + 1} día(s)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.mediumBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Switches opcionales
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.paleBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Configuración Adicional',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSwitchTile(
                          title: 'JW',
                          subtitle: 'Incluir en reportes JW',
                          value: _jw,
                          onChanged: (value) => setState(() => _jw = value),
                          icon: Icons.people_rounded,
                        ),
                        _buildSwitchTile(
                          title: 'Aviso',
                          subtitle: 'Enviar avisos y recordatorios',
                          value: _aviso,
                          onChanged: (value) => setState(() => _aviso = value),
                          icon: Icons.notifications_rounded,
                        ),
                        _buildSwitchTile(
                          title: 'Agenda',
                          subtitle: 'Agregar a agenda personal',
                          value: _agenda,
                          onChanged: (value) => setState(() => _agenda = value),
                          icon: Icons.calendar_today_rounded,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Campo Detalles (Opcional)
                  TextFormField(
                    controller: _detallesController,
                    decoration: InputDecoration(
                      labelText: 'Detalles (Opcional)',
                      hintText: 'Información adicional sobre la ruta...',
                      prefixIcon: const Icon(Icons.description_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                    maxLength: 500,
                  ),

                  const SizedBox(height: 24),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: routesState.isCreating
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              routesState.isCreating ? null : _createRoute,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mediumBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: routesState.isCreating
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Crear Ruta'),
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

  Widget _buildDateButton({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required Function(DateTime) onDateSelected,
    DateTime? minDate,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate:
              minDate ?? DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : 'Seleccionar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: date != null ? Colors.black : Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.mediumBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.mediumBlue,
          ),
        ],
      ),
    );
  }

  void _createRoute() async {
    if (!_formKey.currentState!.validate()) return;

    if (_fechaInicio == null || _fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Por favor selecciona las fechas de inicio y fin'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final success = await ref.read(routesNotifierProvider.notifier).createRoute(
          actividad: _actividadController.text,
          fechaInicio: _fechaInicio!,
          fechaFin: _fechaFin!,
          jw: _jw,
          aviso: _aviso,
          agenda: _agenda,
          detalles: _detallesController.text.trim().isEmpty
              ? null
              : _detallesController.text.trim(),
        );

    if (success && mounted) {
      Navigator.of(context).pop();
      widget.onRouteCreated?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ruta creada exitosamente'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
