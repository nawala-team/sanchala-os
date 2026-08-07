// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_READER_MODE_H_
#define SANCHALA_BROWSER_UI_READER_MODE_H_

#include <string>
#include "url/gurl.h"

namespace sanchala {

struct ReaderSettings {
  std::string font_family = "Georgia";
  int font_size = 18;
  int line_height = 160;  // percentage
  int max_width = 680;    // pixels
  std::string theme = "auto";  // light, dark, sepia, auto
};

struct ArticleContent {
  std::string title;
  std::string author;
  std::string date;
  std::string content;  // Clean HTML
  std::string site_name;
  int word_count;
  int reading_time;  // minutes
};

class ReaderMode {
 public:
  ReaderMode();
  ~ReaderMode();
  
  // Check if page is readable
  bool CanEnterReaderMode(const GURL& url, const std::string& html);
  
  // Enter/exit reader mode
  void Enter(const std::string& html);
  void Exit();
  bool IsActive() const { return active_; }
  
  // Get processed content
  ArticleContent GetArticle() const { return article_; }
  std::string GetReaderHTML() const;
  
  // Settings
  void SetSettings(const ReaderSettings& settings);
  ReaderSettings GetSettings() const { return settings_; }
  
  // Individual settings
  void SetFontSize(int size);
  void SetFontFamily(const std::string& family);
  void SetTheme(const std::string& theme);
  void SetMaxWidth(int width);
  
  // Text-to-speech
  void StartReading();
  void StopReading();
  void PauseReading();
  bool IsReading() const { return tts_active_; }
  
 private:
  std::string ExtractContent(const std::string& html);
  std::string CleanHTML(const std::string& html);
  std::string GenerateReaderHTML();
  
  bool active_ = false;
  bool tts_active_ = false;
  ArticleContent article_;
  ReaderSettings settings_;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_READER_MODE_H_
