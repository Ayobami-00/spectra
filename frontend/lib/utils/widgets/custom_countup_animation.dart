import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' hide TextDirection;

class CustomCountupAnimation extends StatefulWidget {
  final double begin;
  final double end;
  final int precision;
  final int? decimalDigits;
  final Curve curve;
  final Duration duration;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final String? separator;
  final String prefix;
  final String suffix;
  final bool isCurrency;

  const CustomCountupAnimation({
    super.key,
    required this.begin,
    required this.end,
    this.precision = 0,
    this.decimalDigits,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 250),
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.separator,
    this.prefix = '',
    this.suffix = '',
    this.isCurrency = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomCountupAnimationState createState() => _CustomCountupAnimationState();
}

class _CustomCountupAnimationState extends State<CustomCountupAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double? _latestBegin;
  double? _latestEnd;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _latestBegin = widget.begin;
    _latestEnd = widget.end;
  }

  @override
  Widget build(BuildContext context) {
    final CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: _controller, curve: widget.curve);
    _animation = Tween<double>(begin: widget.begin, end: widget.end)
        .animate(curvedAnimation);

    final NumberFormat formatter = widget.isCurrency
        ? NumberFormat.currency(
            decimalDigits: widget.decimalDigits ?? 2,
            locale: Localizations.localeOf(context).toString(),
            symbol: "\$", // Set the currency symbol here
          )
        : NumberFormat.compact(
            locale: Localizations.localeOf(context).toString(),
          );

    if (widget.begin != _latestBegin || widget.end != _latestEnd) {
      _controller.reset();
    }

    _latestBegin = widget.begin;
    _latestEnd = widget.end;
    _controller.forward();

    return _CustomCountupAnimationAnimatedText(
      key: UniqueKey(),
      animation: _animation,
      precision: widget.precision,
      formatter: formatter,
      style: widget.style,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaleFactor: widget.textScaleFactor,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
      separator: widget.separator,
      prefix: widget.prefix,
      suffix: widget.suffix,
    );
  }
}

// ignore: must_be_immutable
class _CustomCountupAnimationAnimatedText extends AnimatedWidget {
  final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  final Animation<double> animation;
  final int precision;
  NumberFormat formatter;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final String? separator;
  final String? prefix;
  final String? suffix;

  _CustomCountupAnimationAnimatedText({
    super.key,
    required this.animation,
    required this.precision,
    required this.formatter,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.separator,
    this.prefix,
    this.suffix,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = animation.value.toStringAsFixed(precision);
    final formattedValue = separator != null
        ? value.replaceAllMapped(
            reg,
            (Match match) => '${match[1]}$separator',
          )
        : formatter.format(double.parse(value));

    return Text(
      '$prefix$formattedValue$suffix',
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
  }
}
