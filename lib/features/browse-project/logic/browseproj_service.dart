import 'package:trova/features/browse-project/logic/browseproj_filter.dart';
import 'package:trova/features/browse-project/logic/browseproj_model.dart';

class ProjectsService {
  // final Dio dio;
  // ProjectsService({required this.dio});

  Future<List<ProjectModel>> fetchProjects({ProjectsFilter? filter}) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate network

    var projects = [
      ProjectModel(
        id: '1',
        title: 'Al Rawda Residential Tower',
        companyName: 'Al Bunyan Construction Co.',
        category: 'Construction',
        budget: 850000,
        budgetDisplay: 'JOD 850,000',
        minScore: 70,
        daysLeft: 12,
      ),
      ProjectModel(
        id: '2',
        title: 'Amman Ring Road Extension',
        companyName: 'Jordan Infra Group',
        category: 'Infrastructure',
        budget: 2400000,
        budgetDisplay: 'JOD 2,400,000',
        minScore: 85,
        daysLeft: 25,
      ),
      ProjectModel(
        id: '3',
        title: 'Zarqa Industrial Warehouse',
        companyName: 'Sharq Industrial Contractors',
        category: 'Industrial',
        budget: 610000,
        budgetDisplay: 'JOD 610,000',
        minScore: 60,
        daysLeft: 8,
      ),
      ProjectModel(
        id: '4',
        title: 'Dabouq Villas MEP Fit-out',
        companyName: 'Precision MEP Solutions',
        category: 'MEP',
        budget: 320000,
        budgetDisplay: 'JOD 320,000',
        minScore: 55,
        daysLeft: 18,
      ),
      ProjectModel(
        id: '5',
        title: 'Downtown Mall Renovation',
        companyName: 'Modern Fit-out LLC',
        category: 'Renovation & Fit-out',
        budget: 480000,
        budgetDisplay: 'JOD 480,000',
        minScore: 65,
        daysLeft: 30,
      ),
    ];

    if (filter?.sector != null) {
      projects = projects.where((p) => p.category == filter!.sector).toList();
    }
    if (filter?.minValue != null) {
      projects = projects.where((p) => p.budget >= filter!.minValue!).toList();
    }
    if (filter?.maxValue != null) {
      projects = projects.where((p) => p.budget <= filter!.maxValue!).toList();
    }

    final sortBy = filter?.sortBy ?? 'deadline_asc';
    switch (sortBy) {
      case 'deadline_asc':
        projects.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
        break;
      case 'deadline_desc':
        projects.sort((a, b) => b.daysLeft.compareTo(a.daysLeft));
        break;
      case 'value_desc':
        projects.sort((a, b) => b.budget.compareTo(a.budget));
        break;
      case 'value_asc':
        projects.sort((a, b) => a.budget.compareTo(b.budget));
        break;
    }

    return projects;
  }
}