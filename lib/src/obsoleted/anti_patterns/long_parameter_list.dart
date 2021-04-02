import '../../models/function_type.dart';
import '../../models/issue.dart';
import '../../models/scoped_function_declaration.dart';
import '../config/config.dart' as metrics;
import '../models/internal_resolved_unit_result.dart';
import '../utils/metrics_analyzer_utils.dart';
import 'base_pattern.dart';
import 'pattern_utils.dart' as utils;

class LongParameterList extends BasePattern {
  static const String patternId = 'long-parameter-list';
  static const _documentationUrl = 'https://git.io/JUGrU';

  LongParameterList()
      : super(id: patternId, documentation: Uri.parse(_documentationUrl));

  @override
  Iterable<Issue> check(
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    metrics.Config config,
  ) =>
      functions
          .where((function) =>
              getArgumentsCount(function) >
              config.numberOfParametersWarningLevel)
          .map((function) => utils.createIssue(
                this,
                _compileMessage(
                  args: getArgumentsCount(function),
                  functionType: function.type,
                ),
                _compileRecommendationMessage(
                  maximumArguments: config.numberOfParametersWarningLevel,
                  functionType: function.type,
                ),
                source,
                function.declaration,
              ))
          .toList();

  String _compileMessage({required int args, FunctionType? functionType}) =>
      'Long Parameter List. This ${functionType.toString().toLowerCase()} require $args arguments.';

  String _compileRecommendationMessage({
    required int maximumArguments,
    FunctionType? functionType,
  }) =>
      "Based on configuration of this package, we don't recommend writing a ${functionType.toString().toLowerCase()} with argument count more than $maximumArguments.";
}