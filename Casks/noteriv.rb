cask "noteriv" do
  version "3.0.3"
  sha256 "bc62b02562b155dcf0d9c71055a3fef58cd4f9f9e69ba38e64c2433350c67afc"

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
