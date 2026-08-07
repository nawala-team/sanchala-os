// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/ui/reader_mode.h"
#include "base/logging.h"
#include <regex>

namespace sanchala {

ReaderMode::ReaderMode() = default;
ReaderMode::~ReaderMode() = default;

void ReaderMode::Initialize() {
  config_.font_family = "Georgia";
  config_.font_size = 18;
  config_.line_height = 1.6f;
  config_.content_width = 680;
  config_.theme = "auto";
  LOG(INFO) << "Reader mode initialized";
}

bool ReaderMode::IsReaderModeAvailable(const std::string& html, const std::string& url) {
  // Check if page has article-like content
  float score = GetReadabilityScore(html);
  return score > 0.5f;
}

float ReaderMode::GetReadabilityScore(const std::string& html) {
  // Simplified readability detection
  // Look for article tags, paragraph density, text length
  
  int paragraphs = 0;
  size_t pos = 0;
  while ((pos = html.find("<p", pos)) != std::string::npos) {
    paragraphs++;
    pos++;
  }
  
  bool has_article = html.find("<article") != std::string::npos;
  bool has_main = html.find("<main") != std::string::npos;
  
  float score = 0.0f;
  if (paragraphs > 3) score += 0.3f;
  if (paragraphs > 10) score += 0.2f;
  if (has_article) score += 0.3f;
  if (has_main) score += 0.2f;
  
  return std::min(score, 1.0f);
}

ArticleContent ReaderMode::ExtractArticle(const std::string& html, const std::string& url) {
  ArticleContent article;
  
  // Extract title
  std::regex title_regex("<title>([^<]+)</title>");
  std::smatch match;
  if (std::regex_search(html, match, title_regex)) {
    article.title = match[1].str();
  }
  
  // Extract main content (simplified)
  article.content_html = ExtractMainContent(html);
  
  // Calculate stats
  std::string text = CleanHTML(article.content_html);
  article.word_count = CalculateWordCount(text);
  article.read_time_minutes = (article.word_count + 200) / 200;  // ~200 wpm
  
  LOG(INFO) << "Extracted article: " << article.title 
            << " (" << article.word_count << " words)";
  
  return article;
}

std::string ReaderMode::ExtractMainContent(const std::string& html) {
  // Look for article or main content
  std::regex article_regex("<article[^>]*>([\\s\\S]*?)</article>");
  std::smatch match;
  if (std::regex_search(html, match, article_regex)) {
    return match[1].str();
  }
  
  std::regex main_regex("<main[^>]*>([\\s\\S]*?)</main>");
  if (std::regex_search(html, match, main_regex)) {
    return match[1].str();
  }
  
  return html;
}

std::string ReaderMode::CleanHTML(const std::string& html) {
  // Remove all HTML tags
  std::regex tag_regex("<[^>]+>");
  return std::regex_replace(html, tag_regex, " ");
}

int ReaderMode::CalculateWordCount(const std::string& text) {
  int count = 0;
  bool in_word = false;
  for (char c : text) {
    if (std::isspace(c)) {
      in_word = false;
    } else if (!in_word) {
      in_word = true;
      count++;
    }
  }
  return count;
}

std::string ReaderMode::RenderReaderView(const ArticleContent& article) {
  std::string html = R"(
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>)" + article.title + R"(</title>
  <style>)" + GetReaderCSS(config_) + R"(</style>
</head>
<body>
  <article class="reader-content">
    <header>
      <h1>)" + article.title + R"(</h1>
      <div class="meta">
        <span class="author">)" + article.author + R"(</span>
        <span class="read-time">)" + std::to_string(article.read_time_minutes) + R"( min read</span>
      </div>
    </header>
    <div class="content">
      )" + article.content_html + R"(
    </div>
  </article>
</body>
</html>
)";
  return html;
}

std::string ReaderMode::GetReaderCSS(const ReaderConfig& config) {
  return R"(
    body {
      font-family: )" + config.font_family + R"(, serif;
      font-size: )" + std::to_string(config.font_size) + R"(px;
      line-height: )" + std::to_string(config.line_height) + R"(;
      max-width: )" + std::to_string(config.content_width) + R"(px;
      margin: 0 auto;
      padding: 2rem;
      background: var(--bg-color, #fff);
      color: var(--text-color, #333);
    }
    h1 { font-size: 2em; margin-bottom: 0.5em; }
    .meta { color: #666; margin-bottom: 2em; }
    img { max-width: 100%; height: auto; }
    @media (prefers-color-scheme: dark) {
      body { --bg-color: #1a1a1a; --text-color: #e0e0e0; }
    }
  )";
}

void ReaderMode::SetConfig(const ReaderConfig& config) { config_ = config; }
void ReaderMode::SetTheme(const std::string& theme) { config_.theme = theme; }
void ReaderMode::SetFontSize(int size) { config_.font_size = size; }
void ReaderMode::SetFontFamily(const std::string& family) { config_.font_family = family; }
void ReaderMode::SetContentWidth(int width) { config_.content_width = width; }

void ReaderMode::EnableTTS(bool enable) { tts_enabled_ = enable; }
void ReaderMode::StartTTS() { if (tts_enabled_) LOG(INFO) << "TTS started"; }
void ReaderMode::StopTTS() { LOG(INFO) << "TTS stopped"; }

}  // namespace sanchala
