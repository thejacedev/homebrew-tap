cask "noteriv" do
  version "3.0.7"
  sha256 "6fb79132cb1cc271ca9e6939c9f7d4cbd717a8906ca8a365553bf69028b2a6d2"

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
