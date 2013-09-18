module CreativeCommonsRails
  class Railtie < Rails::Railtie
    # load the action view helpers and i18n dictionary files
    initializer "creative_commons_rails" do
      ActionView::Base.send :include, CreativeCommonsRails::ActionViewHelpers
      I18n.load_path += Dir.glob( File.dirname(__FILE__) + "/../../config/locales/*.{rb,yml}" )
    end
  end
end