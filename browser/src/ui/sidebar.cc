// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0

#include "browser/src/ui/sidebar.h"
#include "base/logging.h"

namespace sanchala {

Sidebar::Sidebar() = default;
Sidebar::~Sidebar() = default;

void Sidebar::Initialize() {
  visible_ = true;
  width_ = 280;
  current_panel_ = SidebarPanel::kBookmarks;
  LOG(INFO) << "Sidebar initialized";
}

void Sidebar::Show() { visible_ = true; }
void Sidebar::Hide() { visible_ = false; }
void Sidebar::Toggle() { visible_ = !visible_; }

void Sidebar::SetPanel(SidebarPanel panel) {
  current_panel_ = panel;
  LOG(INFO) << "Sidebar panel changed to: " << static_cast<int>(panel);
}

void Sidebar::SetWidth(int width) {
  width_ = width;
}

std::vector<BookmarkItem> Sidebar::GetBookmarks(const std::string& folder_id) {
  std::vector<BookmarkItem> result;
  for (const auto& item : bookmarks_) {
    if (folder_id.empty() || item.folder_id == folder_id) {
      result.push_back(item);
    }
  }
  return result;
}

void Sidebar::AddBookmark(const BookmarkItem& item) {
  bookmarks_.push_back(item);
  LOG(INFO) << "Added bookmark: " << item.title;
}

void Sidebar::RemoveBookmark(const std::string& id) {
  bookmarks_.erase(
    std::remove_if(bookmarks_.begin(), bookmarks_.end(),
      [&id](const BookmarkItem& b) { return b.id == id; }),
    bookmarks_.end()
  );
}

BookmarkItem Sidebar::CreateFolder(const std::string& name, const std::string& parent_id) {
  BookmarkItem folder;
  folder.id = "folder_" + std::to_string(bookmarks_.size());
  folder.title = name;
  folder.folder_id = parent_id;
  folder.is_folder = true;
  folder.date_added = time(nullptr);
  bookmarks_.push_back(folder);
  return folder;
}

std::vector<HistoryItem> Sidebar::GetHistory(int limit) {
  std::vector<HistoryItem> result;
  int count = 0;
  for (auto it = history_.rbegin(); it != history_.rend() && count < limit; ++it, ++count) {
    result.push_back(*it);
  }
  return result;
}

std::vector<HistoryItem> Sidebar::SearchHistory(const std::string& query) {
  std::vector<HistoryItem> result;
  for (const auto& item : history_) {
    if (item.title.find(query) != std::string::npos ||
        item.url.find(query) != std::string::npos) {
      result.push_back(item);
    }
  }
  return result;
}

void Sidebar::DeleteHistoryItem(const std::string& id) {
  history_.erase(
    std::remove_if(history_.begin(), history_.end(),
      [&id](const HistoryItem& h) { return h.id == id; }),
    history_.end()
  );
}

void Sidebar::ClearHistory() {
  history_.clear();
  LOG(INFO) << "History cleared";
}

std::vector<DownloadItem> Sidebar::GetDownloads() {
  return downloads_;
}

void Sidebar::PauseDownload(const std::string& id) {
  for (auto& d : downloads_) {
    if (d.id == id) { d.paused = true; break; }
  }
}

void Sidebar::ResumeDownload(const std::string& id) {
  for (auto& d : downloads_) {
    if (d.id == id) { d.paused = false; break; }
  }
}

void Sidebar::CancelDownload(const std::string& id) {
  downloads_.erase(
    std::remove_if(downloads_.begin(), downloads_.end(),
      [&id](const DownloadItem& d) { return d.id == id; }),
    downloads_.end()
  );
}

void Sidebar::ClearCompletedDownloads() {
  downloads_.erase(
    std::remove_if(downloads_.begin(), downloads_.end(),
      [](const DownloadItem& d) { return d.completed; }),
    downloads_.end()
  );
}

void Sidebar::AddToReadingList(const std::string& url, const std::string& title) {
  LOG(INFO) << "Added to reading list: " << title;
}

}  // namespace sanchala
