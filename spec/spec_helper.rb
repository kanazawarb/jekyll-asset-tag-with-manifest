$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "jekyll/asset_tag_with_manifest"

require "minitest/autorun"
require "minitest-power_assert"
require "minitest/reporters"

require "pry-byebug"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
