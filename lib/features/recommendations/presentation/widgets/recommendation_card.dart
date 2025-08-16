import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recommendation_entity.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendationEntity recommendation;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecommendationCard({
    super.key,
    required this.recommendation,
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
        onTap: () => _showRecommendationDetails(context),
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
                _getTipoColor().withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTipoColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTipoIcon(),
                      color: _getTipoColor(),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.titulo,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          recommendation.tipoDisplay,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getTipoColor(),
                            fontWeight: FontWeight.w600,
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
                        color: AppColors.lightBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.mediumBlue,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Información básica
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.cake_rounded,
                    label: '${recommendation.edad} años',
                    color: AppColors.mediumBlue,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.water_drop_rounded,
                    label: '${recommendation.anosBautizado} años baut.',
                    color: AppColors.lightBlue,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Estados
              if (recommendation.censurado || recommendation.sacado) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (recommendation.censurado)
                      _buildStatusChip(
                        'Censurado',
                        Colors.orange,
                        recommendation.fechaCensurado,
                      ),
                    if (recommendation.sacado)
                      _buildStatusChip(
                        'Sacado',
                        Colors.red,
                        recommendation.fechaSacado,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Comentarios preview
              if (recommendation.comentarios != null &&
                  recommendation.comentarios!.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.paleBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.notes_rounded,
                            size: 14,
                            color: AppColors.mediumBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Comentarios',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.mediumBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recommendation.comentarios!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color, DateTime? fecha) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (fecha != null) ...[
            const SizedBox(width: 4),
            Text(
              '(${fecha.day}/${fecha.month}/${fecha.year})',
              style: TextStyle(
                color: color,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getTipoColor() {
    switch (recommendation.tipo) {
      case TipoRecomendacion.anciano:
        return AppColors.mediumBlue;
      case TipoRecomendacion.siervoMinisterial:
        return AppColors.lightBlue;
    }
  }

  IconData _getTipoIcon() {
    switch (recommendation.tipo) {
      case TipoRecomendacion.anciano:
        return Icons.admin_panel_settings_rounded;
      case TipoRecomendacion.siervoMinisterial:
        return Icons.support_agent_rounded;
    }
  }

  void _showRecommendationDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getTipoColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTipoIcon(),
                color: _getTipoColor(),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                recommendation.titulo,
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
              _buildDetailItem('Tipo', recommendation.tipoDisplay),
              _buildDetailItem('Edad', '${recommendation.edad} años'),
              _buildDetailItem(
                  'Años Bautizado', '${recommendation.anosBautizado} años'),
              const SizedBox(height: 16),
              const Text(
                'Estados:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildStatusDetailItem('Censurado', recommendation.censurado,
                  recommendation.fechaCensurado),
              _buildStatusDetailItem(
                  'Sacado', recommendation.sacado, recommendation.fechaSacado),
              if (recommendation.comentarios != null &&
                  recommendation.comentarios!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Comentarios:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.paleBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(recommendation.comentarios!),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Creado: ${recommendation.createdAt.day}/${recommendation.createdAt.month}/${recommendation.createdAt.year}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              if (recommendation.updatedAt != recommendation.createdAt)
                Text(
                  'Actualizado: ${recommendation.updatedAt.day}/${recommendation.updatedAt.month}/${recommendation.updatedAt.year}',
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
              backgroundColor: _getTipoColor(),
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
            width: 100,
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

  Widget _buildStatusDetailItem(String label, bool value, DateTime? fecha) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: value ? Colors.orange : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(label),
          if (value && fecha != null) ...[
            const SizedBox(width: 8),
            Text(
              '(${fecha.day}/${fecha.month}/${fecha.year})',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
