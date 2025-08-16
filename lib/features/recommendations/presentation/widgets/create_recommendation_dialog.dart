import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../providers/recommendations_notifier.dart';

class CreateRecommendationDialog extends ConsumerStatefulWidget {
  final String congregationId;
  final VoidCallback? onRecommendationCreated;

  const CreateRecommendationDialog({
    super.key,
    required this.congregationId,
    this.onRecommendationCreated,
  });

  @override
  ConsumerState<CreateRecommendationDialog> createState() =>
      _CreateRecommendationDialogState();
}

class _CreateRecommendationDialogState
    extends ConsumerState<CreateRecommendationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _edadController = TextEditingController();
  final _anosBautizadoController = TextEditingController();
  final _comentariosController = TextEditingController();

  TipoRecomendacion _tipo = TipoRecomendacion.anciano;
  bool _censurado = false;
  DateTime? _fechaCensurado;
  bool _sacado = false;
  DateTime? _fechaSacado;

  @override
  void dispose() {
    _tituloController.dispose();
    _edadController.dispose();
    _anosBautizadoController.dispose();
    _comentariosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recommendationsState = ref.watch(recommendationsNotifierProvider);
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
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
                          color: AppColors.lightBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person_add_rounded,
                          color: AppColors.lightBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nueva Recomendación',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            Text(
                              'Registra una nueva recomendación',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.lightBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Título
                  TextFormField(
                    controller: _tituloController,
                    decoration: InputDecoration(
                      labelText: 'Título de la Recomendación *',
                      hintText: 'Ej: Juan Pérez',
                      prefixIcon: const Icon(Icons.title_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El título es requerido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Tipo de recomendación
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo de Recomendación *',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Cards seleccionables
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _tipo = TipoRecomendacion.anciano;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _tipo == TipoRecomendacion.anciano
                                        ? AppColors.lightBlue.withOpacity(0.1)
                                        : Colors.grey.shade50,
                                    border: Border.all(
                                      color: _tipo == TipoRecomendacion.anciano
                                          ? AppColors.lightBlue
                                          : Colors.grey.shade300,
                                      width: _tipo == TipoRecomendacion.anciano
                                          ? 2
                                          : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.man,
                                        size: 32,
                                        color:
                                            _tipo == TipoRecomendacion.anciano
                                                ? AppColors.lightBlue
                                                : Colors.grey.shade600,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Anciano',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              _tipo == TipoRecomendacion.anciano
                                                  ? AppColors.lightBlue
                                                  : Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _tipo = TipoRecomendacion.siervoMinisterial;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _tipo ==
                                            TipoRecomendacion.siervoMinisterial
                                        ? AppColors.mediumBlue.withOpacity(0.1)
                                        : Colors.grey.shade50,
                                    border: Border.all(
                                      color: _tipo ==
                                              TipoRecomendacion
                                                  .siervoMinisterial
                                          ? AppColors.mediumBlue
                                          : Colors.grey.shade300,
                                      width: _tipo ==
                                              TipoRecomendacion
                                                  .siervoMinisterial
                                          ? 2
                                          : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.boy,
                                        size: 32,
                                        color: _tipo ==
                                                TipoRecomendacion
                                                    .siervoMinisterial
                                            ? AppColors.mediumBlue
                                            : Colors.grey.shade600,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Siervo Ministerial',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: _tipo ==
                                                  TipoRecomendacion
                                                      .siervoMinisterial
                                              ? AppColors.mediumBlue
                                              : Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Edad y Años Bautizado
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _edadController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Edad *',
                            hintText: 'Ej: 35',
                            prefixIcon: const Icon(Icons.calendar_month),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'La edad es requerida';
                            }
                            final edad = int.tryParse(value);
                            if (edad == null || edad <= 0 || edad > 120) {
                              return 'Edad inválida';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _anosBautizadoController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Años Bautizado *',
                            hintText: 'Ej: 15',
                            prefixIcon: const Icon(Icons.water_drop_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Los años bautizado son requeridos';
                            }
                            final anos = int.tryParse(value);
                            if (anos == null || anos < 0) {
                              return 'Años inválidos';
                            }
                            final edad = int.tryParse(_edadController.text);
                            if (edad != null && anos > edad) {
                              return 'No puede ser mayor a la edad';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Censurado
                  _buildSwitchWithDate(
                    title: 'Censurado',
                    subtitle: 'Indica si ha sido censurado',
                    value: _censurado,
                    date: _fechaCensurado,
                    onValueChanged: (value) {
                      setState(() {
                        _censurado = value;
                        if (!value) {
                          _fechaCensurado = null;
                        }
                      });
                    },
                    onDateChanged: (date) {
                      setState(() {
                        _fechaCensurado = date;
                      });
                    },
                    icon: Icons.gavel_rounded,
                    color: Colors.orange,
                  ),

                  const SizedBox(height: 16),

                  // Sacado
                  _buildSwitchWithDate(
                    title: 'Sacado',
                    subtitle: 'Indica si ha sido sacado',
                    value: _sacado,
                    date: _fechaSacado,
                    onValueChanged: (value) {
                      setState(() {
                        _sacado = value;
                        if (!value) {
                          _fechaSacado = null;
                        }
                      });
                    },
                    onDateChanged: (date) {
                      setState(() {
                        _fechaSacado = date;
                      });
                    },
                    icon: Icons.exit_to_app_rounded,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 20),

                  // Comentarios
                  TextFormField(
                    controller: _comentariosController,
                    decoration: InputDecoration(
                      labelText: 'Comentarios (Opcional)',
                      hintText: 'Información adicional...',
                      prefixIcon: const Icon(Icons.notes_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                    maxLength: 500,
                  ),

                  const SizedBox(height: 24),

                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: recommendationsState.isCreating
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
                          onPressed: recommendationsState.isCreating
                              ? null
                              : _createRecommendation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: recommendationsState.isCreating
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
                              : const Text('Crear'),
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

  Widget _buildSwitchWithDate({
    required String title,
    required String subtitle,
    required bool value,
    required DateTime? date,
    required Function(bool) onValueChanged,
    required Function(DateTime?) onDateChanged,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
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
                onChanged: onValueChanged,
                activeColor: color,
              ),
            ],
          ),
          if (value) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  onDateChanged(selectedDate);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 16, color: color),
                    const SizedBox(width: 8),
                    Text(
                      date != null
                          ? 'Fecha: ${date.day}/${date.month}/${date.year}'
                          : 'Seleccionar fecha (opcional)',
                      style: TextStyle(
                        color: date != null ? Colors.black : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _createRecommendation() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(recommendationsNotifierProvider.notifier)
        .createRecommendation(
          congregationId: widget.congregationId,
          titulo: _tituloController.text,
          tipo: _tipo,
          edad: int.parse(_edadController.text),
          anosBautizado: int.parse(_anosBautizadoController.text),
          censurado: _censurado,
          fechaCensurado: _fechaCensurado,
          sacado: _sacado,
          fechaSacado: _fechaSacado,
          comentarios: _comentariosController.text.trim().isEmpty
              ? null
              : _comentariosController.text.trim(),
        );

    if (success && mounted) {
      Navigator.of(context).pop();
      widget.onRecommendationCreated?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Recomendación creada exitosamente'),
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
