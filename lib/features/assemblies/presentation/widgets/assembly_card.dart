import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/assembly_entity.dart';

class AssemblyCard extends StatelessWidget {
  final AssemblyEntity assembly;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AssemblyCard({
    super.key,
    required this.assembly,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showAssemblyDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y acciones
              Row(
                children: [
                  // Icono de la asamblea
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.darkBlue.withOpacity(0.8),
                          AppColors.darkBlue,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.event_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assembly.nombre,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assembly.fechaRangeDisplay,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.mediumBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
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
                            Icon(Icons.delete_rounded,
                                size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Eliminar',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.darkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Información adicional
              Row(
                children: [
                  // Lugar
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: AppColors.mediumBlue,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            assembly.lugar,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.mediumBlue,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Duración
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 12,
                          color: AppColors.darkBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${assembly.duracionDias} día${assembly.duracionDias == 1 ? '' : 's'}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.darkBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor().withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(),
                      size: 14,
                      color: _getStatusColor(),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = DateTime(assembly.fechaInicio.year,
        assembly.fechaInicio.month, assembly.fechaInicio.day);
    final endDate = DateTime(
        assembly.fechaFin.year, assembly.fechaFin.month, assembly.fechaFin.day);

    if (today.isAfter(endDate)) {
      return Colors.grey; // Finalizada
    } else if (today.isBefore(startDate)) {
      return AppColors.lightBlue; // Próxima
    } else {
      return Colors.green; // En curso
    }
  }

  IconData _getStatusIcon() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = DateTime(assembly.fechaInicio.year,
        assembly.fechaInicio.month, assembly.fechaInicio.day);
    final endDate = DateTime(
        assembly.fechaFin.year, assembly.fechaFin.month, assembly.fechaFin.day);

    if (today.isAfter(endDate)) {
      return Icons.check_circle_rounded; // Finalizada
    } else if (today.isBefore(startDate)) {
      return Icons.schedule_rounded; // Próxima
    } else {
      return Icons.play_circle_rounded; // En curso
    }
  }

  String _getStatusText() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = DateTime(assembly.fechaInicio.year,
        assembly.fechaInicio.month, assembly.fechaInicio.day);
    final endDate = DateTime(
        assembly.fechaFin.year, assembly.fechaFin.month, assembly.fechaFin.day);

    if (today.isAfter(endDate)) {
      return 'Finalizada';
    } else if (today.isBefore(startDate)) {
      final daysUntil = startDate.difference(today).inDays;
      if (daysUntil == 0) return 'Hoy';
      if (daysUntil == 1) return 'Mañana';
      return 'En $daysUntil días';
    } else {
      return 'En curso';
    }
  }

  void _showAssemblyDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.darkBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.event_rounded,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                assembly.nombre,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Nombre', assembly.nombre),
              _buildDetailItem('Fechas', assembly.fechaRangeDisplay),
              _buildDetailItem('Lugar', assembly.lugar),
              _buildDetailItem('Duración',
                  '${assembly.duracionDias} día${assembly.duracionDias == 1 ? '' : 's'}'),
              _buildDetailItem('Estado', _getStatusText()),
              const SizedBox(height: 16),
              Text(
                'Creado: ${assembly.createdAt.day}/${assembly.createdAt.month}/${assembly.createdAt.year}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              if (assembly.updatedAt != assembly.createdAt)
                Text(
                  'Actualizado: ${assembly.updatedAt.day}/${assembly.updatedAt.month}/${assembly.updatedAt.year}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
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
              backgroundColor: AppColors.darkBlue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
