class Game < ActiveRecord::Base
    belongs_to :player1, class_name: "User"
    belongs_to :player2, class_name: "User"
    validates_uniqueness_of :player1, :scope => [:player2]
    validates_uniqueness_of :player2, :scope => [:player1]
end
