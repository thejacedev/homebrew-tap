cask "noteriv" do
  version "2.4.10"
  sha256 "a22172972dd7226aeced9d05ba1e288964d83b9d4cbcea9c54661e57ffa4c6a8"

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
