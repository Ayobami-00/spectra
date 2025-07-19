class AuditParams {
  AuditParams(
      {this.page = "1",
      this.count = 10,
      this.startAfter,
      this.sortByValue,
      this.filterField,
      this.filterValue,
      this.orderByValue = 'created_at',
      this.operator = EqualityOperator.none});

  String? page;
  int? count;
  String? startAfter;
  String? sortByValue;
  String? filterField;
  String? filterValue;
  String? orderByValue;
  EqualityOperator? operator;
}

// equality_operator.dart

enum EqualityOperator {
  equalsTo,
  notEquals,
  greaterThan,
  lessThan,
  greaterThanOrEquals,
  lessThanOrEquals,
  none
}

extension EqualityOperatorExtension on EqualityOperator {
  String get symbol {
    switch (this) {
      case EqualityOperator.equalsTo:
        return '==';
      case EqualityOperator.notEquals:
        return '!=';
      case EqualityOperator.greaterThan:
        return '>';
      case EqualityOperator.lessThan:
        return '<';
      case EqualityOperator.greaterThanOrEquals:
        return '>=';
      case EqualityOperator.lessThanOrEquals:
        return '<=';
      case EqualityOperator.none:
        return '';
      default:
        return '';
    }
  }
}
