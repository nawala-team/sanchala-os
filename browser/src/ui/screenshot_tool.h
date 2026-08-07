// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_SCREENSHOT_TOOL_H_
#define SANCHALA_BROWSER_UI_SCREENSHOT_TOOL_H_

#include <string>
#include <vector>
#include "ui/gfx/image/image.h"

namespace sanchala {

enum class ScreenshotType {
  kVisibleArea,
  kFullPage,
  kSelection
};

enum class ScreenshotFormat {
  kPNG,
  kJPEG,
  kWebP
};

struct ScreenshotOptions {
  ScreenshotType type = ScreenshotType::kVisibleArea;
  ScreenshotFormat format = ScreenshotFormat::kPNG;
  int quality = 90;  // For JPEG/WebP
  bool include_scrollbar = false;
};

class ScreenshotTool {
 public:
  ScreenshotTool();
  ~ScreenshotTool();
  
  // Capture screenshot
  gfx::Image Capture(int tab_id, const ScreenshotOptions& options);
  gfx::Image CaptureSelection(int tab_id, const gfx::Rect& rect);
  gfx::Image CaptureFullPage(int tab_id);
  
  // Save screenshot
  bool SaveToFile(const gfx::Image& image, const std::string& path,
                  ScreenshotFormat format);
  bool CopyToClipboard(const gfx::Image& image);
  
  // Annotation tools
  void EnableAnnotation(bool enable);
  void AddText(const std::string& text, int x, int y);
  void AddArrow(int x1, int y1, int x2, int y2);
  void AddHighlight(const gfx::Rect& rect);
  
  // Get last screenshot
  gfx::Image GetLastScreenshot() const { return last_screenshot_; }
  
 private:
  gfx::Image last_screenshot_;
  bool annotation_enabled_ = false;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_SCREENSHOT_TOOL_H_
