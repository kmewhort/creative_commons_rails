namespace :cc_retrieve_data do
  desc 'Populate license_list.yaml with an index of all available CC licenses by jurisdiction'
  task :license_index do |t, args|
    require 'mechanize'
    require 'yaml'
    require 'open-uri'

    # pull the list of jurisdictions from the CC license chooser page
    agent = Mechanize.new { |a| a.user_agent_alias = 'Mac Safari' }
    jurisdictions = agent.get('http://creativecommons.org/choose/').search('#field_jurisdiction option').map do |o|
      o['value']
    end.compact

    # ping for the deed page of each possible combination of jurisdiction, version and type
    license_index = {}
    jurisdictions.each do |jurisdiction|
      license_index[jurisdiction] = {}
      ["1.0","2.0","2.5","3.0","4.0"].each do |version|
        license_index[jurisdiction][version] = {}
        [:by,:by_sa,:by_nd,:by_nc,:by_nc_sa,:by_nc_nd].each do |type|
          deed_url = "http://creativecommons.org/licenses/#{type.to_s.gsub('_','-')}/#{version}/#{jurisdiction}"
          license_index[jurisdiction][version][type] = false
          begin
            ping_result =  open(deed_url)
            if ping_result.status[0] == "200"
              license_index[jurisdiction][version][type.to_s] = true
            end
          rescue OpenURI::HTTPError => ex
            # not found
          end
          sleep(1) # rate limit to avoid hammering creativecommons.org
        end
      end
    end
    license_index['unported'] = license_index[""]
    license_index.delete("")

    File.open('config/license_list.yaml', 'w') {|f| YAML::dump(license_index, f) }
  end

  desc 'Populate I18n localizations with translations from the CC License Chooser'
  task :localization do |t, args|
    require 'mechanize'
    require 'yaml'
    require 'open-uri'
    require 'json'

    notice_localization = {}
    jurisdiction_localization = {}
    agent = Mechanize.new { |a| a.user_agent_alias = 'Mac Safari' }

    # for each available language
    agent.get('http://creativecommons.org/choose/').search('#other_stuff .licensebox a').each do |a|
      chooser_page = agent.get(a['href'])
      lang = a['hreflang'].to_sym

      # for each license type
      [:by,:by_sa,:by_nd,:by_nc,:by_nc_sa,:by_nc_nd].each_with_index do |type, i|
        # get the license notice info directly from the License Chooser API
        uri = URI.parse('http://creativecommons.org/choose/xhr_api')
        params = case type
          when :by
            {
                "field_commercial" => 'y',
                "field_derivatives" => 'y'
            }
          when :by_sa
            {
                "field_commercial" => 'y',
                "field_derivatives" => 'sa'
            }
          when :by_nd
            {
                "field_commercial" => 'y',
                "field_derivatives" => 'n'
            }
          when :by_nc
            {
                "field_commercial" => 'n',
                "field_derivatives" => 'y'
            }
          when :by_nc_sa
            {
                "field_commercial" => 'n',
                "field_derivatives" => 'sa'
            }
          when :by_nc_nd
            {
                "field_commercial" => 'n',
                "field_derivatives" => 'n'
            }
        end

        params["lang"] = lang
        uri.query = URI.encode_www_form( params )
        result = JSON.parse(uri.open.read)

        if i == 0
          html = Nokogiri::HTML(result['license_html'])
          title = html.css('a:last-child').text
          notice_localization[lang.to_s] = {
            'license_notice' => html.text.sub(title, "\%\{license_title\}"),
            'license_title' => title.sub(result['license_title'], "\%\{license_type\}"),
          }
        end
        notice_localization[lang.to_s]["license_type_#{type.to_s}"] =
            result['license_title'].sub(/3\.0.*/, "\%\{version\} \%\{jurisdiction\}")

        sleep(1) # rate limit to avoid hammering creativecommons.org
      end

      # get the translations of jurisdiction names (eg. "Canada", "United States", etc.)
      jurisdiction_localization[lang.to_s] = {}
      chooser_page.search('#field_jurisdiction option').each do |o|
        jurisdiction_key = o['value'].empty? ? 'unported' : o['value']
        jurisdiction_localization[lang.to_s][jurisdiction_key.to_s] = o.text.strip
      end
    end
    File.open('config/locales/cc_license_notices.yml', 'w') {|f| YAML.dump(notice_localization,f) }
    File.open('config/locales/cc_license_jurisdictions.yml', 'w') {|f| YAML.dump(jurisdiction_localization,f) }
  end
end
