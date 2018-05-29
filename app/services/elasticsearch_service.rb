class ElasticsearchService
  class << self
    def should_log?
      Rails.env.development?
    end

    def build_client
      settings = {
        log: should_log?,
        host: SETTINGS[:elasticsearch].try(:[], :host)
      }

      Elasticsearch::Client.new settings
    end
  end
end
