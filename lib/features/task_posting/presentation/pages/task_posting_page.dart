import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../../../profile/presentation/widgets/profile_dropdown.dart';
import '../bloc/task_posting_bloc.dart';
import '../bloc/task_posting_event.dart';
import '../bloc/task_posting_state.dart';
import '../widgets/location_details_step_widget.dart';
import '../widgets/budget_date_step_widget.dart';
import '../widgets/step_indicator.dart';
import '../widgets/step_navigation_bar.dart';
import '../../../booking/presentation/pages/provider_selection_page.dart';

class TaskPostingPage extends StatefulWidget {
  final String? category;
  final String? subcategory;
  
  const TaskPostingPage({
    super.key,
    this.category,
    this.subcategory,
  });

  @override
  State<TaskPostingPage> createState() => _TaskPostingPageState();
}

class _TaskPostingPageState extends State<TaskPostingPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskPostingBloc>().add(TaskPostingInitialize());

    if (widget.category != null && widget.category!.isNotEmpty) {
      context.read<TaskPostingBloc>().add(
        TaskPostingUpdateCategory(
          widget.category!,
          widget.subcategory ?? '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.iconColor),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              // If there's nothing to pop, go to home page
              context.go('/home');
            }
          },
        ),
        title: const Text(
          'FINDR',
          style: TextStyle(
            color: AppTheme.iconColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppTheme.iconColor),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ProfileDropdown(
              userName: 'John Doe', // TODO: Get from user state
              userEmail: 'john@example.com', // TODO: Get from user state
              profileImageUrl: 'assets/images/person.jpg',
            ),
          ),
        ],
      ),
      body: BlocConsumer<TaskPostingBloc, TaskPostingState>(
        listener: (context, state) {
          if (state is TaskPostingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task posted successfully!'),
                backgroundColor: AppTheme.successColor,
              ),
            );
            context.pop();
          } else if (state is TaskPostingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskPostingLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            );
          }

          if (state is! TaskPostingLoaded) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          return Column(
            children: [
               // Step Indicator
               Container(
                 padding: const EdgeInsets.all(16),
                 child: StepIndicator(
                   currentStep: state.currentStep,
                   totalSteps: 2,
                 ),
               ),
              
              // Category Information Header
              if (widget.category != null && widget.category!.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Service',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                       Text(
                         '${widget.category}${widget.subcategory != null && widget.subcategory!.isNotEmpty ? ' - ${widget.subcategory}' : ''}',
                         style: AppTextStyles.heading3.copyWith(
                           color: AppTheme.textPrimaryColor,
                         ),
                       ),
                    ],
                  ),
                ),

              // Step Content
              Expanded(
                child: _buildStepContent(context, state),
              ),

              // Navigation Bar
              const StepNavigationBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, TaskPostingLoaded state) {
    switch (state.currentStep) {
      case 0:
        return LocationDetailsStepWidget(
          location: state.location,
          title: state.title,
          summary: state.summary,
          images: state.images,
          onLocationChanged: (location) {
            context.read<TaskPostingBloc>().add(TaskPostingUpdateLocation(location));
          },
          onTitleChanged: (title) {
            context.read<TaskPostingBloc>().add(TaskPostingUpdateTitle(title));
          },
          onSummaryChanged: (summary) {
            context.read<TaskPostingBloc>().add(TaskPostingUpdateSummary(summary));
          },
          onImageAdded: (imagePath) {
            context.read<TaskPostingBloc>().add(TaskPostingAddImage(imagePath));
          },
          onImageRemoved: (index) {
            context.read<TaskPostingBloc>().add(TaskPostingRemoveImage(index));
          },
        );
      case 1:
        return BudgetDateStepWidget(
          budget: state.budget,
          preferredDate: state.preferredDate,
          onBudgetChanged: (budget) {
            context.read<TaskPostingBloc>().add(TaskPostingUpdateBudget(budget));
          },
          onPreferredDateChanged: (date) {
            context.read<TaskPostingBloc>().add(TaskPostingUpdatePreferredDate(date));
          },
        );
      default:
        return const Center(child: Text('Invalid step'));
    }
  }
}
