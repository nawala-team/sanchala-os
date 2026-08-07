// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#ifndef SANCHALA_BROWSER_UI_TRANSLATE_H_
#define SANCHALA_BROWSER_UI_TRANSLATE_H_

#include <string>
#include <vector>
#include <functional>

namespace sanchala {

struct Language {
  std::string code;  // e.g., "en", "es"
  std::string name;  // e.g., "English", "Spanish"
};

struct TranslationResult {
  bool success;
  std::string source_lang;
  std::string target_lang;
  std::string translated_text;
  std::string error;
};

class TranslateService {
 public:
  TranslateService();
  ~TranslateService();
  
  void Initialize();
  
  // Language detection
  std::string DetectLanguage(const std::string& text);
  
  // Translation
  TranslationResult Translate(const std::string& text,
                               const std::string& target_lang);
  TranslationResult Translate(const std::string& text,
                               const std::string& source_lang,
                               const std::string& target_lang);
  
  // Page translation
  void TranslatePage(int tab_id, const std::string& target_lang);
  void RevertPageTranslation(int tab_id);
  bool IsPageTranslated(int tab_id) const;
  
  // Settings
  void SetDefaultLanguage(const std::string& lang);
  std::string GetDefaultLanguage() const { return default_lang_; }
  
  void AddNeverTranslateLanguage(const std::string& lang);
  void AddNeverTranslateSite(const std::string& domain);
  void SetAutoTranslate(bool enable);
  
  // Available languages
  std::vector<Language> GetSupportedLanguages() const;
  
  // Offline translation
  void DownloadLanguagePack(const std::string& lang);
  bool IsLanguageAvailableOffline(const std::string& lang) const;
  
 private:
  std::string default_lang_ = "en";
  std::vector<std::string> never_translate_langs_;
  std::vector<std::string> never_translate_sites_;
  bool auto_translate_ = false;
};

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_UI_TRANSLATE_H_
