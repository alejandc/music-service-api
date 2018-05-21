# == Schema Information
#
# Table name: songs
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  duration   :decimal(6, 2)
#  genre_cd   :integer
#  artist_id  :bigint(8)
#  album_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Song, type: :model do

end
