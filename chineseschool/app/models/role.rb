class Role < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_and_belongs_to_many :rights

  validates_presence_of :name
  validates_uniqueness_of :name

  def authorized?(controller_path, action_name)
    return true if self.name == 'Super User'
    self.rights.any? { |right| right.authorized?(controller_path, action_name) }
  end
end
