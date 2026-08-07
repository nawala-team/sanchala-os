// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_PDF_VIEWER_H_
#define SANCHALA_BROWSER_UI_PDF_VIEWER_H_

#include <string>
#include <vector>
#include "ui/gfx/geometry/rect.h"

namespace sanchala {

struct PDFPageInfo {
  int page_number;
  int width;
  int height;
  std::string text_content;
};

struct PDFOutlineItem {
  std::string title;
  int page;
  std::vector<PDFOutlineItem> children;
};

class PDFViewer {
 public:
  PDFViewer();
  ~PDFViewer();
  
  // Load PDF
  bool Load(const std::string& path);
  bool LoadFromUrl(const std::string& url);
  bool LoadFromData(const std::vector<uint8_t>& data);
  void Close();
  
  // Navigation
  void GoToPage(int page);
  void NextPage();
  void PreviousPage();
  int GetCurrentPage() const { return current_page_; }
  int GetPageCount() const { return page_count_; }
  
  // Zoom
  void SetZoom(float zoom);
  float GetZoom() const { return zoom_; }
  void FitToWidth();
  void FitToPage();
  
  // View modes
  void SetSinglePageView(bool single);
  void SetContinuousScroll(bool continuous);
  
  // Outline/bookmarks
  std::vector<PDFOutlineItem> GetOutline() const;
  
  // Search
  std::vector<gfx::Rect> Search(const std::string& query);
  void HighlightSearchResults(bool highlight);
  
  // Annotations
  void AddHighlight(int page, const gfx::Rect& rect);
  void AddNote(int page, int x, int y, const std::string& text);
  
  // Print/Save
  void Print();
  bool SaveAs(const std::string& path);
  
 private:
  int current_page_ = 0;
  int page_count_ = 0;
  float zoom_ = 1.0f;
  bool loaded_ = false;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_PDF_VIEWER_H_
