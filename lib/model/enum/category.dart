import '../../common/app_icons.dart';

enum Category { task, event, goal }


extension CategoryExtension on Category {
  String get iconPath{
    switch (this) {
      case Category.task:
        return AppIcons.icCategoryTask;
      case Category.goal:
        return AppIcons.icCategoryGoal;
      case Category.event:
        return AppIcons.icCategoryEvent;
    }
  }
}
