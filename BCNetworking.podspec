
Pod::Spec.new do |s|

  # -- Meta -- #
  s.name         = "BCNetworking"
  s.version      = "0.2.0"
  s.summary      = "BCNetworking aims to provide a simple, yet useful library for managing your everyday HTTP resquests and responses."
  s.homepage     = "https://github.com/ilbesculpi/BCNetworking"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  
  # --- License --- #
  s.license      = { :type => "GNU", :file => "LICENSE" }

  # --- Authors --- #
  s.authors            = { "ilbert esculpi" => "ilbert.esculpi@gmail.com" }
  # s.social_media_url   = "http://twitter.com/ilbert esculpi"

  # --- Platform --- #
  s.platform     = :ios, "6.0"

  # --- Source --- #
  s.source       = { :git => "https://github.com/ilbesculpi/BCNetworking.git", :tag => "v0.2" }
  s.source_files  = "lib/BCNetworking/*"
  s.requires_arc = true
  
  

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
