class SongSearcher

  def self.search(params)
    filters = []

    if params[:name].present?
      filters << {match: {name: params[:name]}}
    end
    binding.pry
    Song.__elasticsearch__.search query: base_query(filters)
  end

  private

  def self.base_query(filters = {})
    {
      bool: {
        must: filters,
      }
    }
  end

end
