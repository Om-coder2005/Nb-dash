import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/features/queue/providers/queue_provider.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_button.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';

import 'package:nextbills/shared/widgets/nb_toast.dart';

class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeModeProvider);
    final queueAsync = ref.watch(queueControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const NbAppBar(
        title: 'Guest Queue',
        showBack: true,
      ),
      body: queueAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return _buildEmptyState(context, ref);
          }
          return _buildQueueList(context, ref, entries);
        },
        loading: () => const Center(child: NbLoadingPulse()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEntryDialog(context, ref),
        icon: Icon(Icons.person_add_rounded),
        label: Text('Add Guest'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_outlined, size: 80, color: AppColors.textMuted.withOpacity(0.5)),
          SizedBox(height: 16),
          Text(
            'No guests in queue',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add guests here during peak hours',
            style: GoogleFonts.inter(color: AppColors.textMuted),
          ),
          SizedBox(height: 24),
          NbButton(
            text: 'Add First Guest',
            onPressed: () => _showAddEntryDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueList(BuildContext context, WidgetRef ref, List<QueueEntry> entries) {
    return Scrollbar(
      thumbVisibility: true,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return _QueueEntryCard(entry: entry);
        },
      ),
    );
  }

  void _showAddEntryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const _AddQueueEntryDialog(),
    );
  }
}

class _QueueEntryCard extends ConsumerWidget {
  final QueueEntry entry;

  const _QueueEntryCard({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeStr = DateFormat('hh:mm a').format(entry.createdAt);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Position Number
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryGlow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  '#${entry.waitingNumber}',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Guest Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.customerName,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.people_alt_rounded, size: 14, color: AppColors.textSecondary),
                      SizedBox(width: 4),
                      Text(
                        '${entry.requiredSeats} Persons',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.access_time_rounded, size: 14, color: AppColors.textMuted),
                      SizedBox(width: 4),
                      Text(
                        timeStr,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  if (entry.customerPhone != null && entry.customerPhone!.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      entry.customerPhone!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Actions
            Row(
              children: [
                _ActionButton(
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                  onPressed: () => ref.read(queueControllerProvider.notifier).markAsSeated(entry.id),
                  tooltip: 'Mark Seated',
                ),
                SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.cancel_rounded,
                  color: AppColors.error,
                  onPressed: () => _confirmRemove(context, ref),
                  tooltip: 'Cancel/Remove',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRemove(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => NbDialog(
        title: 'Remove Guest?',
        customContent: Text(
          'Remove ${entry.customerName} from the queue?',
          style: GoogleFonts.manrope(fontSize: 15, color: AppColors.textSecondary),
        ),
        primaryButtonText: 'Remove',
        isDanger: true,
        onPrimary: () => Navigator.pop(ctx, true),
        secondaryButtonText: 'No',
        onSecondary: () => Navigator.pop(ctx, false),
      ),
    );

    if (confirm == true) {
      await ref.read(queueControllerProvider.notifier).removeEntry(entry.id);
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }
}

class _AddQueueEntryDialog extends ConsumerStatefulWidget {
  const _AddQueueEntryDialog();

  @override
  ConsumerState<_AddQueueEntryDialog> createState() => _AddQueueEntryDialogState();
}

class _AddQueueEntryDialogState extends ConsumerState<_AddQueueEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int _seats = 2;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NbDialog(
      title: 'Add Guest to Queue',
      customContent: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NbInput(
              controller: _nameController,
              hintText: 'Customer Name',
              prefixIcon: Icons.person_rounded,
            ),
            SizedBox(height: 16),
            NbInput(
              controller: _phoneController,
              type: NbInputType.number,
              hintText: 'Phone Number (Optional)',
              prefixIcon: Icons.phone_rounded,
            ),
              SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Seats Required',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  _SeatSelector(
                    value: _seats,
                    onChanged: (v) => setState(() => _seats = v),
                  ),
                ],
              ),
            ],
          ),
      ),
      primaryButtonText: 'Add',
      onPrimary: () async {
        if (_nameController.text.trim().isEmpty) {
          NbToast.show(context, 'Name is required', type: NbToastType.error);
          return;
        }
        await ref.read(queueControllerProvider.notifier).addEntry(
          name: _nameController.text.trim(),
          seats: _seats,
          phone: _phoneController.text.trim().isNotEmpty
              ? _phoneController.text.trim()
              : null,
        );
        if (context.mounted) Navigator.pop(context);
      },
      secondaryButtonText: 'Cancel',
      onSecondary: () => Navigator.pop(context),
    );
  }
}

class _SeatSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _SeatSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: Icon(Icons.remove_rounded),
            color: AppColors.primary,
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon: Icon(Icons.add_rounded),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
