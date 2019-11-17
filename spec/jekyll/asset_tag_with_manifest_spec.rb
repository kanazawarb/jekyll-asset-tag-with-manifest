require "spec_helper"

describe Jekyll::AssetTagWithManifest do
  before {
    Liquid::Template.register_tag('asset', Jekyll::AssetTagWithManifest::Tag)
  }

  #
  # [param] String literal
  #
  def template(literal)
    t = Liquid::Template.parse(literal)
    t.root.nodelist.first
  end

  #
  # [param] Hash data
  # [param] Hash config
  # [return] Object
  #
  def site(data: {}, config: {})
    Struct.new(:data, :config)
      .new(
        data,
        config_with_fail_on_error(config))
  end

  #
  # [param] Hash data
  # [param] Hash config
  # [return] Object
  #
  def context(site)
    Liquid::Context.new({}, {}, {site: site})
  end

  #
  # [param] Hash config
  # [return] Hash
  #
  def config_with_fail_on_error(config = {})
    namespace = Jekyll::AssetTagWithManifest::CONFIG_NAMESPACE
    f = { 'fail_on_error' => true }

    if config.has_key?(namespace)
      config[namespace].merge!(f)
    else
      config[namespace] = f
    end

    config
  end
  
  describe '.register' do
    describe 'without config' do
      it {
        assert {
          Jekyll::AssetTagWithManifest::Tag.register(site)
        }
      }
    end
  end
  
  describe '#text' do
    describe 'without quote' do
      it 'whitespace stripped' do
        assert {
          template('{% asset foo.js %}').text == "foo.js"
        }
      end
    end

    describe 'with quote' do
      it 'quote stripped' do
        assert {
          template('{% asset "foo.js" %}').text == "foo.js"
        }
      end
    end
  end

  describe '#render' do
    describe 'manifest not exists' do
      it {
        assert_raises Jekyll::AssetTagWithManifest::ManifestNotExist do
          template('{% asset foo.js %}').render(context(site)) == 'foo.js'
        end
      }
    end

    describe 'manifest exists, render normally' do
      it {
        c = context(
          site(
            data: JSON.parse(<<JSON),
{
  "manifest": {
    "foo.js": "foo.c30102c2.js"
  }
}
JSON
          ))

        assert {
          template('{% asset foo.js %}').render(c) == 'foo.c30102c2.js'
        }
      }
    end

    describe 'manifest not exist' do
      it {
        assert_raises Jekyll::AssetTagWithManifest::ManifestNotExist do
          template('{% asset foo.js %}').render(context(site))
        end
      }
    end

    describe 'manifest exists, but asset not found' do
      it {
        c = context(
          site(
            data: JSON.parse(<<JSON)
{
  "manifest": {}
}
JSON
          ))

        assert_raises Jekyll::AssetTagWithManifest::AssetNotFound do
          template('{% asset foo.js %}').render(c)
        end
      }
    end

    describe 'custom tag' do
      before {
        s = site(
          data: JSON.parse(<<JSON),
{
  "manifest": {
    "foo.js": "foo.c30102c2.js"
  }
}
JSON
          config: YAML.load(<<YAML)
asset_tag_with_manifest:
  tag: asset_path
YAML
        )
        Jekyll::AssetTagWithManifest::Tag.register(s)
        @context = context(s)
      }

      it {
         template('{% asset_path foo.js %}').render(@context) == 'foo.c30102c2.js'
      }
    end
  end
end
