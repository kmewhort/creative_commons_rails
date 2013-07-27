module CreativeCommonsRails
  class Railtie < Rails::Railtie
    # load the action view helpers and i18n dictionary files
    initializer "creative_commons_rails" do
      ActionView::Base.send :include, CreativeCommonsRails::ActionViewHelpers
      I18n.load_path += Dir.glob( File.dirname(__FILE__) + "/../../config/locales/*.{rb,yml}" )
    end

    # load the rake task to re-retrieve the data on available licenses
    rake_tasks do
      load File.join(File.dirname(__FILE__),'tasks/retrieve_data.rake')
    end
  end
end