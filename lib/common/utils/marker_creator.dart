import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Класс для создания изображений для маркеров на карте
class MarkerCreator {
  static Future<BitmapDescriptor> captureFromWidget(
    Widget widget, {
    Size? targetSize,
    double? imagePixelRatio,
    Duration delay = const Duration(seconds: 1),
  }) async {
    ui.Image image = await _widgetToUiImage(
      widget,
      delay: delay,
    );
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    return BitmapDescriptor.bytes(
      byteData!.buffer.asUint8List(),
      imagePixelRatio: imagePixelRatio,
      width: targetSize?.width,
      height: targetSize?.height,
    );
  }

  static Future<ui.Image> _widgetToUiImage(
    Widget widget, {
    Duration delay = const Duration(seconds: 1),
  }) async {
    int retryCounter = 3;
    bool isDirty = false;
    Widget child = widget;

    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    final fallBackView = platformDispatcher.views.first;
    final view = fallBackView;
    Size logicalSize = view.physicalSize / view.devicePixelRatio;
    Size imageSize = view.physicalSize;

    assert(logicalSize.aspectRatio.toStringAsPrecision(5) ==
        imageSize.aspectRatio.toStringAsPrecision(5));

    final RenderView renderView = RenderView(
      view: view,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.loose(logicalSize),
        devicePixelRatio: 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(
      focusManager: FocusManager(),
      onBuildScheduled: () {
        isDirty = true;
      },
    );

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        RenderObjectToWidgetAdapter<RenderBox>(
            container: repaintBoundary,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: child,
            )).attachToRenderTree(
      buildOwner,
    );

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();
    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image? image;

    // костыль из 3 итераций если по каким то причинам не создался скриншот
    do {
      isDirty = false;

      image = await repaintBoundary.toImage(
        pixelRatio: (imageSize.width / logicalSize.width),
      );

      await Future.delayed(delay);

      // Проверяем требуется ли ребилд
      if (isDirty) {
        // Обновляем предыдущий скрин и делаем ребилд
        buildOwner.buildScope(rootElement);
        buildOwner.finalizeTree();
        pipelineOwner.flushLayout();
        pipelineOwner.flushCompositingBits();
        pipelineOwner.flushPaint();
      }
      retryCounter--;

      // повторяем несколько раз пока не будет успешно
    } while (isDirty && retryCounter >= 0);
    try {
      buildOwner.finalizeTree();
    } catch (_, __) {}

    return image;
  }
}
