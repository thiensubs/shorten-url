Apipie.configure do |config|
  config.app_name = 'Shorten URL Application'
  config.copyright = '&copy; 2021 anvotien@gmail.com'
  config.app_info = 'This is API document for app Shorten URL Application.'
  config.api_base_url            = '/api/v1/'
  config.doc_base_url            = '/api/doc'
  config.translate = false
  config.default_locale = nil
  # config.api_controllers_matcher = "#{Rails.root}/app/controllers/{[!concerns/]**/*}.rb"
  config.api_controllers_matcher = Dir["#{Rails.root}/app/controllers/**/*.rb"].map do |f|
    if f.include?('concerns')
      nil
    elsif f.include?('.rb')
      f
    else
      "#{f}/*.rb"
    end
  end.compact

  # config.validator               = false
  # where is your API defined?
  # config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"

  if Rails.env.to_s == 'production'
    config.authenticate = proc do
      authenticate_or_request_with_http_basic do |username, password|
        username == 'shorten_url_doc' && password == 'someThingverys3cR3ct'
      end
    end
  end
end
