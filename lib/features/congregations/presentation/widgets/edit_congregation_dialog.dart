import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/congregation_entity.dart';
import '../providers/congregations_notifier.dart';

class EditCongregationDialog extends ConsumerStatefulWidget {
  final CongregationEntity congregation;
  final VoidCallback? onCongregationUpdated;

  const EditCongregationDialog({
    super.key,
    required this.congregation,
    this.onCongregationUpdated,
  });

  @override
  ConsumerState<EditCongregationDialog> createState() =>
      _EditCongregationDialogState();
}

class _EditCongregationDialogState
    extends ConsumerState<EditCongregationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;

  @override
  void initState() {
    super.initState();
    // Inicializar con el valor actual
    _nombreController = TextEditingController(text: widget.congregation.nombre);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final congregationsState = ref.watch(congregationsNotifierProvider);
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
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
                              'Editar Congregación',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            Text(
                              'Modifica el nombre de la congregación',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.mediumBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Campo Nombre (Requerido)
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la Congregación *',
                      hintText: 'Ej: Congregación Central',
                      prefixIcon: const Icon(Icons.account_balance_rounded),
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
                        return 'El nombre de la congregación es requerido';
                      }
                      if (value.trim().length < 3) {
                        return 'El nombre debe tener al menos 3 caracteres';
                      }
                      if (value.trim().length > 50) {
                        return 'El nombre no puede exceder 50 caracteres';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _updateCongregation(),
                  ),

                  const SizedBox(height: 24),

                  // Información de la congregación
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
                              'Información de la congregación',
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
                          '${widget.congregation.createdAt.day}/${widget.congregation.createdAt.month}/${widget.congregation.createdAt.year}',
                        ),
                        if (widget.congregation.updatedAt !=
                            widget.congregation.createdAt) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Última actualización',
                            '${widget.congregation.updatedAt.day}/${widget.congregation.updatedAt.month}/${widget.congregation.updatedAt.year}',
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
                          onPressed: congregationsState.isUpdating
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
                          onPressed: congregationsState.isUpdating
                              ? null
                              : _updateCongregation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mediumBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: congregationsState.isUpdating
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
                                    const Text('Guardar'),
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

  void _updateCongregation() async {
    if (!_formKey.currentState!.validate()) return;

    // Verificar si el nombre ha cambiado
    if (_nombreController.text.trim() == widget.congregation.nombre) {
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
    final updatedCongregation = CongregationEntity(
      id: widget.congregation.id,
      nombre: _nombreController.text.trim(),
      createdAt: widget.congregation.createdAt,
      updatedAt: DateTime.now(),
    );

    final success = await ref
        .read(congregationsNotifierProvider.notifier)
        .updateCongregation(updatedCongregation);

    if (success && mounted) {
      Navigator.of(context).pop();
      widget.onCongregationUpdated?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Congregación "${_nombreController.text.trim()}" actualizada exitosamente'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: SnackBarAction(
            label: 'Ver',
            textColor: Colors.white,
            onPressed: () {
              // Aquí podrías navegar a los detalles de la congregación
            },
          ),
        ),
      );
    }
  }
}
