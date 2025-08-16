import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../providers/recommendations_notifier.dart';

class EditRecommendationDialog extends ConsumerStatefulWidget {
  final RecommendationEntity recommendation;
  final VoidCallback? onRecommendationUpdated;

  const EditRecommendationDialog({
    super.key,
    required this.recommendation,
    this.onRecommendationUpdated,
  });

  @override
  ConsumerState<EditRecommendationDialog> createState() =>
      _EditRecommendationDialogState();
}

class _EditRecommendationDialogState
    extends ConsumerState<EditRecommendationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _edadController;
  late final TextEditingController _anosBautizadoController;
  late final TextEditingController _comentariosController;

  late TipoRecomendacion _tipo;
  late bool _censurado;
  late DateTime? _fechaCensurado;
  late bool _sacado;
  late DateTime? _fechaSacado;

  @override
  void initState() {
    super.initState();
    // Inicializar con los valores actuales
    _tituloController =
        TextEditingController(text: widget.recommendation.titulo);
    _edadController =
        TextEditingController(text: widget.recommendation.edad.toString());
    _anosBautizadoController = TextEditingController(
        text: widget.recommendation.anosBautizado.toString());
    _comentariosController =
        TextEditingController(text: widget.recommendation.comentarios ?? '');

    _tipo = widget.recommendation.tipo;
    _censurado = widget.recommendation.censurado;
    _fechaCensurado = widget.recommendation.fechaCensurado;
    _sacado = widget.recommendation.sacado;
    _fechaSacado = widget.recommendation.fechaSacado;
  }

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
                          color: AppColors.mediumBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
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
                              'Editar Recomendación',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            Text(
                              'Modifica la información de la recomendación',
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<TipoRecomendacion>(
                                title: const Text('Anciano'),
                                value: TipoRecomendacion.anciano,
                                groupValue: _tipo,
                                onChanged: (value) {
                                  setState(() {
                                    _tipo = value!;
                                  });
                                },
                                activeColor: AppColors.mediumBlue,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<TipoRecomendacion>(
                                title: const Text('Siervo Ministerial'),
                                value: TipoRecomendacion.siervoMinisterial,
                                groupValue: _tipo,
                                onChanged: (value) {
                                  setState(() {
                                    _tipo = value!;
                                  });
                                },
                                activeColor: AppColors.mediumBlue,
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
                            prefixIcon: const Icon(Icons.cake_rounded),
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

                  const SizedBox(height: 16),

                  // Información de fechas
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Información de la recomendación:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Creado: ${widget.recommendation.createdAt.day}/${widget.recommendation.createdAt.month}/${widget.recommendation.createdAt.year}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (widget.recommendation.updatedAt !=
                            widget.recommendation.createdAt)
                          Text(
                            'Última actualización: ${widget.recommendation.updatedAt.day}/${widget.recommendation.updatedAt.month}/${widget.recommendation.updatedAt.year}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: recommendationsState.isUpdating
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
                          onPressed: recommendationsState.isUpdating
                              ? null
                              : _updateRecommendation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mediumBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: recommendationsState.isUpdating
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
                              : const Text('Actualizar'),
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

  void _updateRecommendation() async {
    if (!_formKey.currentState!.validate()) return;

    // Verificar si hay cambios
    final hasChanges = _tituloController.text != widget.recommendation.titulo ||
        _tipo != widget.recommendation.tipo ||
        int.parse(_edadController.text) != widget.recommendation.edad ||
        int.parse(_anosBautizadoController.text) !=
            widget.recommendation.anosBautizado ||
        _censurado != widget.recommendation.censurado ||
        _fechaCensurado != widget.recommendation.fechaCensurado ||
        _sacado != widget.recommendation.sacado ||
        _fechaSacado != widget.recommendation.fechaSacado ||
        _comentariosController.text.trim() !=
            (widget.recommendation.comentarios ?? '');

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

    // Crear entidad actualizada
    final updatedRecommendation = RecommendationEntity(
      id: widget.recommendation.id,
      congregationId: widget.recommendation.congregationId,
      titulo: _tituloController.text.trim(),
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
      createdAt: widget.recommendation.createdAt,
      updatedAt: DateTime.now(),
    );

    final success = await ref
        .read(recommendationsNotifierProvider.notifier)
        .updateRecommendation(updatedRecommendation);

    if (success && mounted) {
      Navigator.of(context).pop();
      widget.onRecommendationUpdated?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Recomendación actualizada exitosamente'),
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
