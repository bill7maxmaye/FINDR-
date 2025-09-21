import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme.dart';
import '../bloc/task_posting_bloc.dart';
import '../bloc/task_posting_event.dart';
import '../bloc/task_posting_state.dart';

class StepNavigationBar extends StatelessWidget {
  const StepNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskPostingBloc, TaskPostingState>(
      builder: (context, state) {
        if (state is! TaskPostingLoaded) return const SizedBox.shrink();
        
        final currentState = state;
        final isFirstStep = currentState.currentStep == 0;
        final isLastStep = currentState.currentStep == 2;
        final canProceed = currentState.canProceedToNextStep;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Back Button
              if (!isFirstStep)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<TaskPostingBloc>().add(TaskPostingPreviousStep());
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppTheme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              
              if (!isFirstStep) const SizedBox(width: 16),
              
              // Next/Submit Button
              Expanded(
                flex: isFirstStep ? 1 : 1,
                child: ElevatedButton(
                  onPressed: canProceed
                      ? () {
                          if (isLastStep) {
                            context.read<TaskPostingBloc>().add(TaskPostingSubmit());
                          } else {
                            context.read<TaskPostingBloc>().add(TaskPostingNextStep());
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canProceed ? AppTheme.primaryColor : Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isLastStep ? 'Submit Task' : 'Next',
                    style: TextStyle(
                      color: canProceed ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
