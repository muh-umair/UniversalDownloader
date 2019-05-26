Pod::Spec.new do |spec|

  spec.name         = "UniversalDownloader"
  spec.version      = "0.0.1"
  
  spec.summary      = "A downloader to get all types of data from the network."
  spec.description  = "Get all types of data from the network with UniversalDownloader. Download images, JSON, and many more."

  spec.homepage     = "https://github.com/umairbhatti39/UniversalDownloader"

  spec.license      = "MIT"

  spec.author       = { "Muhammad Umair" => "muh.umair.bhatti@gmail.com" }
  
  spec.platform     = :ios, "12.0"

  spec.source       = { :git => "https://github.com/umairbhatti39/UniversalDownloader", :tag => "1.0.0" }
  spec.source_files  = "Source/*.swift", "Source/**/*.swift", "Source/**/**/*.swift"

  spec.swift_version = "4.2" 

end
