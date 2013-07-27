require 'i18n'

module CreativeCommonsRails
  module ActionViewHelpers

    # generates an image/link to the desired CC license
    def cc_license_tags(type, options = {})
      # merge options with defaults and convert to correct data types
      options = default_options.merge(options)
      options[:version] = "%.1f" % options[:version]
      options[:jurisdiction] = options[:jurisdiction].to_sym
      options[:size] = options[:size].to_sym

      # get license data (exception raised if not found)
      l = LicenseInfo.find({type: type}.merge(options))

      html = ""
      html << link_to(l.deed_url, rel: 'license') do
        image_tag(l.icon_url(options[:size]), alt: l.translated_title, style: "border-width:0")
      end
      html << "<br />"
      html << I18n.t(:license_notice, license_title: link_to(l.translated_title, l.deed_url, rel: 'license'))
      html.html_safe
    end

    private
    def default_options
      {
          version: '3.0',
          jurisdiction: :unported,
          size: :normal
      }
    end
  end
end