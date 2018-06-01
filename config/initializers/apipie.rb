Apipie.configure do |config|
  config.app_name                = "MusicServiceApi"
  config.app_info["1.0"]         = "RESTful API for Music service"
  config.api_base_url            = "/"
  config.doc_base_url            = "/apidocs"
  config.validate                = false
  config.validate_value          = false
  config.translate               = false
  config.api_routes              = Rails.application.routes
  config.reload_controllers      = true
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end

class Apipie::Application
  alias_method :orig_load_controller_from_file, :load_controller_from_file
  def load_controller_from_file(controller_file)
    begin
      orig_load_controller_from_file(controller_file)
    rescue LoadError => e
       controller_file.gsub(/\A.*\/app\/controllers\//,"").gsub(/\.\w*\Z/,"").gsub("concerns/","").camelize.constantize
    end
  end
end
