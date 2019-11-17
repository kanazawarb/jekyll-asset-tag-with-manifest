require "jekyll/asset_tag_with_manifest/version"
require "jekyll"

module Jekyll
  module AssetTagWithManifest
    class ManifestNotExist < StandardError; end
    class AssetNotFound < StandardError; end

    CONFIG_NAMESPACE = 'asset_tag_with_manifest'

    class Tag < ::Liquid::Tag
      class << self
        def register(site)
          config = site.config[CONFIG_NAMESPACE]
          tag = if config && config.dig('tag')
                  config.dig('tag')
                else
                  'asset'
                end
          
          Liquid::Template.register_tag(tag, self)
        end
      end

      #
      # [param] String tag_name
      # [param] String text
      # [param] Object
      #
      def initialize(tag_name, text, tokens)
        super
        @text = asset_name(text)
      end
      attr_reader :text
      
      #
      # [param] String text
      # [return] String
      #
      def asset_name(text)
        text.strip.gsub(/['"]/, '')
      end

      def set_site(context)
        @site = context.registers[:site]
      end
      attr_reader :site

      #
      # [return] String
      #
      def manifest_name
        config = site.config[CONFIG_NAMESPACE]

        if config && config.dig('manifest')
          config.dig('manifest')
        else
          'manifest'
        end
      end

      #
      # [return] Boolean
      #
      def fail_on_error
        config = site.config[CONFIG_NAMESPACE]

        config.dig('fail_on_error') if config && config.dig('fail_on_error')
      end

      #
      # [param] Object context
      #
      def render(context)
        set_site(context)
        
        m = site.data[manifest_name]
        unless m
          raise ManifestNotExist.new("`#{manifest_name}.json` not exist in `data_dir`")
        end

        if m.has_key? @text
          m[@text]
        else
          not_found
        end
      end

      #
      # [return] String
      #
      def not_found
        err = AssetNotFound.new("#{@text} not found in `#{manifest_name}.json`")

        if fail_on_error
          raise err
        else
          err.inspect
        end
      end
    end
  end
end

Jekyll::Hooks.register(:site, :post_read) do |site|
  Jekyll::AssetTagWithManifest::Tag.register(site)
end
