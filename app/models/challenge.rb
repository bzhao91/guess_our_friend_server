class Challenge < ActiveRecord::Base
    belongs_to :challenger, class_name: "User"
    belongs_to :challengee, class_name: "User"
    validates :challenger_id, presence: true
    validates :challengee_id, presence: true
    validates_uniqueness_of :challengee_id, :scope => [:challenger_id]
    validates_uniqueness_of :challenger_id, :scope => [:challengee_id]
end
