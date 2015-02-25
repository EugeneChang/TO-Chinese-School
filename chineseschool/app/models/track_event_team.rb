class TrackEventTeam < ActiveRecord::Base
  attr_accessible :name

  belongs_to :track_event_program

  validates :name, :track_event_program, presence: true

end
