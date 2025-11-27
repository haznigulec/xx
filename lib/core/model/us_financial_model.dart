class UsFinancialModel {
  final String startDate;
  final String endDate;
  final String timeframe;
  final String fiscalPeriod;
  final String fiscalYear;
  final String cik;
  final String sic;
  final List<String> tickers;
  final String companyName;
  final Financials financials;

  UsFinancialModel({
    required this.startDate,
    required this.endDate,
    required this.timeframe,
    required this.fiscalPeriod,
    required this.fiscalYear,
    required this.cik,
    required this.sic,
    required this.tickers,
    required this.companyName,
    required this.financials,
  });

  factory UsFinancialModel.fromJson(Map<String, dynamic> json) {
    return UsFinancialModel(
      startDate: json['start_date'],
      endDate: json['end_date'],
      timeframe: json['timeframe'],
      fiscalPeriod: json['fiscal_period'],
      fiscalYear: json['fiscal_year'],
      cik: json['cik'],
      sic: json['sic'],
      tickers: List<String>.from(json['tickers']),
      companyName: json['company_name'],
      financials: Financials.fromJson(json['financials']),
    );
  }
}

class Financials {
  final ComprehensiveIncome? comprehensiveIncome;
  final BalanceSheet? balanceSheet;
  final IncomeStatement? incomeStatement;
  final CashFlowStatement? cashFlowStatement;

  Financials({
    required this.comprehensiveIncome,
    required this.balanceSheet,
    required this.incomeStatement,
    required this.cashFlowStatement,
  });

  factory Financials.fromJson(Map<String, dynamic> json) {
    return Financials(
      comprehensiveIncome:
          json['comprehensive_income'] == null ? null : ComprehensiveIncome.fromJson(json['comprehensive_income']),
      balanceSheet: json['balance_sheet'] == null ? null : BalanceSheet.fromJson(json['balance_sheet']),
      incomeStatement: json['income_statement'] == null ? null : IncomeStatement.fromJson(json['income_statement']),
      cashFlowStatement:
          json['cash_flow_statement'] == null ? null : CashFlowStatement.fromJson(json['cash_flow_statement']),
    );
  }
}

class FinancialItem {
  final double value;
  final String unit;
  final String label;
  final int order;

  FinancialItem({
    required this.value,
    required this.unit,
    required this.label,
    required this.order,
  });

  factory FinancialItem.fromJson(Map<String, dynamic> json) {
    return FinancialItem(
      value: (json['value'] as num).toDouble(),
      unit: json['unit'],
      label: json['label'],
      order: json['order'],
    );
  }
}

class ComprehensiveIncome {
  final FinancialItem? comprehensiveIncomeLoss;
  final FinancialItem? comprehensiveIncomeLossAttributableToParent;
  final FinancialItem? comprehensiveIncomeLossAttributableToNoncontrollingInterest;
  final FinancialItem? otherComprehensiveIncomeLoss;
  final FinancialItem? otherComprehensiveIncomeLossAttributableToParent;

  ComprehensiveIncome({
    required this.comprehensiveIncomeLoss,
    required this.comprehensiveIncomeLossAttributableToParent,
    required this.comprehensiveIncomeLossAttributableToNoncontrollingInterest,
    required this.otherComprehensiveIncomeLoss,
    required this.otherComprehensiveIncomeLossAttributableToParent,
  });

  factory ComprehensiveIncome.fromJson(Map<String, dynamic> json) {
    return ComprehensiveIncome(
      comprehensiveIncomeLoss:
          json['comprehensive_income_loss'] != null ? FinancialItem.fromJson(json['comprehensive_income_loss']) : null,
      comprehensiveIncomeLossAttributableToParent: json['comprehensive_income_loss_attributable_to_parent'] != null
          ? FinancialItem.fromJson(json['comprehensive_income_loss_attributable_to_parent'])
          : null,
      comprehensiveIncomeLossAttributableToNoncontrollingInterest:
          json['comprehensive_income_loss_attributable_to_noncontrolling_interest'] != null
              ? FinancialItem.fromJson(json['comprehensive_income_loss_attributable_to_noncontrolling_interest'])
              : null,
      otherComprehensiveIncomeLoss: json['other_comprehensive_income_loss'] != null
          ? FinancialItem.fromJson(json['other_comprehensive_income_loss'])
          : null,
      otherComprehensiveIncomeLossAttributableToParent:
          json['other_comprehensive_income_loss_attributable_to_parent'] != null
              ? FinancialItem.fromJson(json['other_comprehensive_income_loss_attributable_to_parent'])
              : null,
    );
  }
}

class BalanceSheet {
  final Map<String, FinancialItem> items;

  BalanceSheet({required this.items});

  factory BalanceSheet.fromJson(Map<String, dynamic> json) {
    return BalanceSheet(
      items: json.map((key, value) => MapEntry(key, FinancialItem.fromJson(value))),
    );
  }
}

class IncomeStatement {
  final Map<String, FinancialItem> items;

  IncomeStatement({required this.items});

  factory IncomeStatement.fromJson(Map<String, dynamic> json) {
    return IncomeStatement(
      items: json.map((key, value) => MapEntry(key, FinancialItem.fromJson(value))),
    );
  }
}

class CashFlowStatement {
  final Map<String, FinancialItem> items;

  CashFlowStatement({required this.items});

  factory CashFlowStatement.fromJson(Map<String, dynamic> json) {
    return CashFlowStatement(
      items: json.map((key, value) => MapEntry(key, FinancialItem.fromJson(value))),
    );
  }
}
