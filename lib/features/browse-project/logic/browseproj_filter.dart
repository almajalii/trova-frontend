class ProjectsFilter {
  final String? sector;
  final double? minValue;
  final double? maxValue;
  final String sortBy;

  const ProjectsFilter({
    this.sector,
    this.minValue,
    this.maxValue,
    this.sortBy = 'deadline_asc',
  });
}