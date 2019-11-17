lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll/asset_tag_with_manifest/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-asset-tag-with-manifest"
  spec.version       = Jekyll::AssetTagWithManifest::VERSION
  spec.authors       = ["wtnabe"]
  spec.email         = ["wtnabe@gmail.com"]

  spec.summary       = %q{Custom Liquid Tag for Jekyll and Asset Manifest.}
  spec.homepage      = "https://github.com/kanazawarb/jekyll-asset-tag-with-manifest"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "liquid", "~>4"
  spec.add_runtime_dependency "jekyll", ">3"
  
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-power_assert"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "pry-byebug"
end
