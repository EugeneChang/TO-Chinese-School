class TrackEventHeat < ActiveRecord::Base

  LANE_COUNT = 7

  attr_accessible :track_event_program

  belongs_to :track_event_program
  has_many :track_event_signups, dependent: :nullify
  has_many :track_event_teams, dependent: :nullify

  validates :track_event_program, presence: true

  def full?
    (track_event_signups.size >= LANE_COUNT) || (track_event_teams.size >= LANE_COUNT)
  end

  def max_student_school_age
    max_student_school_age = 1
    self.track_event_signups.each do |signup|
      school_age = signup.student.school_age_for(SchoolYear.current_school_year)
      max_student_school_age = school_age if school_age > max_student_school_age
    end
    max_student_school_age
  end

  def sorted_signups
    if track_event_program.parent_division?
      track_event_signups.sort do |a, b|
        parent_a = a.parent
        parent_b = b.parent
        gender_order = parent_a.gender <=> parent_b.gender
        if gender_order == 0
          last_name_order = parent_a.english_last_name <=> parent_b.english_last_name
          if last_name_order == 0
            parent_a.english_first_name <=> parent_b.english_first_name
          else
            last_name_order
          end
        else
          gender_order
        end
      end
    else
      track_event_signups.sort do |a, b|
        # Sort by school age first
        school_age_order = a.student.school_age_for(SchoolYear.current_school_year) <=> b.student.school_age_for(SchoolYear.current_school_year)
        if school_age_order == 0
          a <=> b
        else
          school_age_order
        end
      end
    end
  end
end