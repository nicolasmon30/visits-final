import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/assemblies_notifier.dart';

class CreateAssemblyDialog extends ConsumerStatefulWidget {
  final VoidCallback? onAssemblyCreated;

  const CreateAssemblyDialog({
    super.key,
    this.onAssemblyCreated,
  });

  @override
  ConsumerState<CreateAssemblyDialog> createState() =>
      _CreateAssemblyDialogState();
}

class _CreateAssemblyDialogState extends ConsumerState<CreateAssemblyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _lugarController = TextEditingController();

  DateTime? _fechaInicio;
  DateTime? _fechaFin;

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
                          color: AppColors.darkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.event_available_rounded,
                          color: AppColors.darkBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nueva Asamblea',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            Text(
                              'Programa una nueva asamblea',
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
                          color: AppColors.darkBlue,
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
                              color: AppColors.darkBlue,
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
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.darkBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.schedule_rounded,
                                    size: 16,
                                    color: AppColors.darkBlue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Duración: ${_fechaFin!.difference(_fechaInicio!).inDays + 1} día(s)',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.darkBlue,
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
                          color: AppColors.darkBlue,
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

                  // Información adicional
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.paleBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.darkBlue.withOpacity(0.3),
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
                              color: AppColors.darkBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Información importante',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkBlue,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• El nombre debe ser único\n• Las fechas pueden ser el mismo día\n• Podrás editar la información posteriormente',
                          style: TextStyle(
                            color: AppColors.mediumBlue,
                            fontSize: 12,
                            height: 1.4,
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
                          onPressed: assembliesState.isCreating
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: AppColors.darkBlue),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: assembliesState.isCreating
                              ? null
                              : _createAssembly,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: assembliesState.isCreating
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
                                    const Icon(Icons.add_rounded, size: 20),
                                    const SizedBox(width: 8),
                                    const Text('Crear Asamblea'),
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
                  color: date != null ? AppColors.darkBlue : Colors.grey,
                ),
                const SizedBox(width: 4),
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
          ],
        ),
      ),
    );
  }

  void _createAssembly() async {
    if (!_formKey.currentState!.validate()) return;

    if (_fechaInicio == null || _fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor selecciona las fechas de la asamblea'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final success =
        await ref.read(assembliesNotifierProvider.notifier).createAssembly(
              nombre: _nombreController.text.trim(),
              fechaInicio: _fechaInicio!,
              fechaFin: _fechaFin!,
              lugar: _lugarController.text.trim(),
            );

    if (success && mounted) {
      Navigator.of(context).pop();
      widget.onAssemblyCreated?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Asamblea "${_nombreController.text.trim()}" creada exitosamente'),
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
