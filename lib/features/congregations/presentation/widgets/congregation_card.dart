import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/congregation_entity.dart';
import '../providers/congregation_details_notifier.dart';

class CongregationCard extends ConsumerWidget {
  final CongregationEntity congregation;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onViewDetails;

  const CongregationCard({
    super.key,
    required this.congregation,
    required this.onEdit,
    required this.onDelete,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showCongregationDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.paleBlue.withOpacity(0.1),
              ],
            ),
          ),
          child: Row(
            children: [
              // Icono de la congregación
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.lightBlue.withOpacity(0.8),
                      AppColors.lightBlue,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // Información de la congregación
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      congregation.nombre,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: AppColors.mediumBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Creada: ${congregation.createdAt.day}/${congregation.createdAt.month}/${congregation.createdAt.year}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.mediumBlue,
                          ),
                        ),
                      ],
                    ),
                    if (congregation.updatedAt != congregation.createdAt) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.update_rounded,
                            size: 16,
                            color: AppColors.lightBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Actualizada: ${congregation.updatedAt.day}/${congregation.updatedAt.month}/${congregation.updatedAt.year}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.lightBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Menú de acciones
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'details':
                      // Limpiar el estado antes de navegar
                      ref
                          .read(congregationDetailsNotifierProvider.notifier)
                          .clearState();
                      onViewDetails?.call();
                      break;
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'details',
                    child: Row(
                      children: [
                        Icon(Icons.analytics_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('Ver Detalles'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.lightBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCongregationDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lightBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.account_balance_rounded,
                color: AppColors.lightBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                congregation.nombre,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailItem('Nombre', congregation.nombre),
            const SizedBox(height: 16),
            _buildDetailItem(
              'Fecha de creación',
              '${congregation.createdAt.day}/${congregation.createdAt.month}/${congregation.createdAt.year}',
            ),
            if (congregation.updatedAt != congregation.createdAt) ...[
              const SizedBox(height: 12),
              _buildDetailItem(
                'Última actualización',
                '${congregation.updatedAt.day}/${congregation.updatedAt.month}/${congregation.updatedAt.year}',
              ),
            ],
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.paleBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: AppColors.mediumBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Información adicional',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.mediumBlue,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Esta congregación está disponible para la gestión de territorio y asignaciones.',
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onEdit();
            },
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: const Text('Editar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightBlue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.mediumBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
