import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/service_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeLoadServices());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              controller: _searchController,
              onChanged: (query) {
                if (query.isNotEmpty) {
                  context.read<HomeBloc>().add(HomeSearchServices(query: query));
                } else {
                  context.read<HomeBloc>().add(HomeLoadServices());
                }
              },
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoaded) {
                return Column(
                  children: [
                    if (state.categories.isNotEmpty)
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.categories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: CategoryChip(
                                  label: 'All',
                                  isSelected: state.selectedCategory == null,
                                  onTap: () {
                                    context.read<HomeBloc>().add(HomeClearFilters());
                                  },
                                ),
                              );
                            }
                            final category = state.categories[index - 1];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CategoryChip(
                                label: category,
                                isSelected: state.selectedCategory == category,
                                onTap: () {
                                  context.read<HomeBloc>().add(
                                        HomeFilterByCategory(category: category),
                                      );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: state.services.isEmpty
                          ? const Center(
                              child: Text('No services found'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.services.length,
                              itemBuilder: (context, index) {
                                final service = state.services[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: ServiceCard(
                                    service: service,
                                    onTap: () {
                                      context.go('/service-details');
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              } else if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.message}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppTheme.errorColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(HomeLoadServices());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: Text('Welcome to Service Booking'),
              );
            },
          ),
        ],
      ),
    );
  }
}
