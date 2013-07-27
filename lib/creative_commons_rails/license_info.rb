require 'i18n'

module CreativeCommonsRails
  class LicenseInfo
    attr_accessor :type, :jurisdiction, :version

    # ensure the license exists in the license index
    def self.find(attributes = {})
      index = license_index
      [:jurisdiction, :version, :type].each do |key|
        raise "You must specify the #{attr} to find a licence" if attributes[key].nil?
        index = index[attributes[key].to_s]
        raise "Unknown license #{key}: #{attributes[key]}" if index.nil? || !index
      end

      LicenseInfo.new(attributes[:type],attributes[:jurisdiction],attributes[:version])
    end

    def initialize(type, jurisdiction, version)
      @type, @jurisdiction, @version = type, jurisdiction, version
    end

    def deed_url
      "http://creativecommons.org/licenses/#{type}/#{version}/#{jurisdiction}/deed.#{language}"
    end

    def icon_url(size = :normal)
      "http://i.creativecommons.org/l/#{type}/#{version}/#{size == :compact ? '80x15' : '88x31'}.png"
    end

    def translated_title
      I18n.t :license_title, license_type: translated_type
    end

    def translated_type
      I18n.t "license_type_#{type}", version: version, jurisdiction: I18n.t(jurisdiction)
    end

    def language
      I18n.locale
    end

    private
    def self.license_index
      gem_root = Gem::Specification.find_by_name("creative_commons_rails").gem_dir
      @index ||= YAML.load_file("#{gem_root}/config/license_list.yaml")
    end
  end
end