import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    super.key,
    this.shadows = const <BoxShadow>[],
    super.child,
  });

  final List<BoxShadow> shadows;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderInnerShadow()..shadows = shadows;
  }

  @override
  void updateRenderObject(BuildContext context, RenderInnerShadow renderObject) {
    renderObject.shadows = shadows;
  }
}

class RenderInnerShadow extends RenderProxyBox {
  RenderInnerShadow({
    RenderBox? child,
    List<BoxShadow> shadows = const <BoxShadow>[],
  })  : _shadows = shadows,
        super(child);

  List<BoxShadow> _shadows;

  set shadows(List<BoxShadow> value) {
    if (_shadows == value) return;
    _shadows = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final Rect bounds = offset & size;
    context.canvas.saveLayer(bounds, Paint());
    context.paintChild(child!, offset);

    for (final BoxShadow shadow in _shadows) {
      final Rect shadowRect = bounds.inflate(shadow.spreadRadius);
      final Paint shadowPaint = Paint()
        ..color = shadow.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurSigma);

      context.canvas.saveLayer(bounds, shadowPaint);
      context.canvas.drawRect(shadowRect, Paint()..color = Colors.white);
      context.canvas.drawRect(
        bounds.shift(shadow.offset),
        Paint()
          ..color = Colors.black
          ..blendMode = BlendMode.dstOut,
      );
      context.canvas.restore();
    }
    context.canvas.restore();
  }
}
