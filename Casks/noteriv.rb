cask "noteriv" do
  version "3.0.4"
  sha256 "e2498b53d5014e81a1c7f6573ee6526c09a0a885a517ec1fb450fa64ff19b069"

  url "https://github.com/thejacedev/Noteriv/releases/download/v#{version}/Noteriv_#{version}_universal.dmg"
  name "Noteriv"
  desc "Markdown editor with graph view, plugins, themes and Git/WebDAV sync"
  homepage "https://www.noteriv.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Noteriv.app"

  zap trash: [
    "~/Library/Application Support/com.noteriv.Noteriv",
    "~/Library/Caches/com.noteriv.Noteriv",
    "~/Library/Preferences/com.noteriv.Noteriv.plist",
    "~/Library/Saved Application State/com.noteriv.Noteriv.savedState",
    "~/Library/WebKit/com.noteriv.Noteriv",
  ]
end
