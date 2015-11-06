class Challenge < ActiveRecord::Base
    belongs_to :challenger, class_name: "User"
    belongs_to :challengee, class_name: "User"
    validates_uniqueness_of :challengee_id, :scope => [:challenger_id]
end
