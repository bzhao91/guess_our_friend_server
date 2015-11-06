class Challenge < ActiveRecord::Base
    belongs_to :challenger, class_name: "User"
    belongs_to :challengee, class_name: "User"
    validates_uniqueness_of :challenger_id, :scope => [:challengee_id]
end
