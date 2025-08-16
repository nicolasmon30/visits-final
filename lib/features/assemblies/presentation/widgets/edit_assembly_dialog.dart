import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/assembly_entity.dart';
import '../providers/assemblies_notifier.dart';

class EditAssemblyDialog extends ConsumerStatefulWidget {
  final AssemblyEntity assembly;
  final VoidCallback? onAssemblyUpdated;

  const EditAssemblyDialog({
    super.key,
    required this.assembly,
    this.onAssemblyUpdated,
  });

  @override
  ConsumerState<EditAssemblyDialog> createState() => _EditAssemblyDialogState();
}

class _EditAssemblyDialogState extends ConsumerState<EditAssemblyDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _lugarController;

  late DateTime _fechaInicio;
  late DateTime _fechaFin;

  @override
  void initState() {
    super.initState();
    // Inicializar con los valores actuales
    _nombreController = TextEditingController(text: widget.assembly.nombre);
    _lugarController = TextEditingController(text: widget.assembly.lugar);
    _fechaInicio = widget.assembly.fechaInicio;
    _fechaFin = widget.assembly.fechaFin;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _lugarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assembliesState = ref.watch(assembliesNotifierProvider);
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
                          Icons.edit_calendar_rounded,
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
                              'Editar Asamblea',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            Text(
                              'Modifica la información de la asamblea',
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

                  // Campo Nombre (Requerido)
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la Asamblea *',
                      hintText: 'Ej: Asamblea de Circuito 2024',
                      prefixIcon: const Icon(Icons.title_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.mediumBlue,
                          width: 2,
                        ),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre de la asamblea es requerido';
                      }
                      if (value.trim().length < 3) {
                        return 'El nombre debe tener al menos 3 caracteres';
                      }
                      if (value.trim().length > 100) {
                        return 'El nombre no puede exceder 100 caracteres';
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
                              'Fechas de la Asamblea *',
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
                                    // Si la fecha fin es anterior, actualizar
                                    if (_fechaFin.isBefore(date)) {
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.mediumBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 16,
                                  color: AppColors.mediumBlue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Duración: ${_fechaFin.difference(_fechaInicio).inDays + 1} día(s)',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.mediumBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Campo Lugar (Requerido)
                  TextFormField(
                    controller: _lugarController,
                    decoration: InputDecoration(
                      labelText: 'Lugar de la Asamblea *',
                      hintText: 'Ej: Salón de Asambleas del Circuito',
                      prefixIcon: const Icon(Icons.location_on_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.mediumBlue,
                          width: 2,
                        ),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El lugar de la asamblea es requerido';
                      }
                      if (value.trim().length < 3) {
                        return 'El lugar debe tener al menos 3 caracteres';
                      }
                      if (value.trim().length > 200) {
                        return 'El lugar no puede exceder 200 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Información de la asamblea
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: AppColors.mediumBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Información de la asamblea',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkBlue,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Creada',
                          '${widget.assembly.createdAt.day}/${widget.assembly.createdAt.month}/${widget.assembly.createdAt.year}',
                        ),
                        if (widget.assembly.updatedAt !=
                            widget.assembly.createdAt) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Última actualización',
                            '${widget.assembly.updatedAt.day}/${widget.assembly.updatedAt.month}/${widget.assembly.updatedAt.year}',
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Advertencia sobre nombres únicos
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.amber.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 20,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Recuerda que el nombre debe ser único',
                            style: TextStyle(
                              color: Colors.amber.shade800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: assembliesState.isUpdating
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: AppColors.mediumBlue),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: assembliesState.isUpdating
                              ? null
                              : _updateAssembly,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mediumBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: assembliesState.isUpdating
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
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.save_rounded, size: 20),
                                    const SizedBox(width: 8),
                                    const Text('Actualizar'),
                                  ],
                                ),
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
    required DateTime date,
    required Function(DateTime) onDateSelected,
    DateTime? minDate,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate:
              minDate ?? DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 730)), // 2 años
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
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: AppColors.mediumBlue,
                ),
                const SizedBox(width: 4),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  void _updateAssembly() async {
    if (!_formKey.currentState!.validate()) return;

    // Verificar si hay cambios
    final hasChanges =
        _nombreController.text.trim() != widget.assembly.nombre ||
            _lugarController.text.trim() != widget.assembly.lugar ||
            _fechaInicio != widget.assembly.fechaInicio ||
            _fechaFin != widget.assembly.fechaFin;

    if (!hasChanges) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No se detectaron cambios'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Crear una nueva entidad con los datos actualizados
    final updatedAssembly = AssemblyEntity(
      id: widget.assembly.id,
      nombre: _nombreController.text.trim(),
      fechaInicio: _fechaInicio,
      fechaFin: _fechaFin,
      lugar: _lugarController.text.trim(),
      createdAt: widget.assembly.createdAt,
      updatedAt: DateTime.now(),
    );

    final success = await ref
        .read(assembliesNotifierProvider.notifier)
        .updateAssembly(updatedAssembly);

    if (success && mounted) {
      Navigator.of(context).pop();
      widget.onAssemblyUpdated?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Asamblea "${_nombreController.text.trim()}" actualizada exitosamente'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: SnackBarAction(
            label: 'Ver',
            textColor: Colors.white,
            onPressed: () {
              // Aquí podrías navegar a los detalles de la asamblea
            },
          ),
        ),
      );
    }
  }
}
