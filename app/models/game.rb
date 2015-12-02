class Game < ActiveRecord::Base
    belongs_to :player1, class_name: "User"
    belongs_to :player2, class_name: "User"
    validates :player1id, presence: true
    validates :player2id, presence: true
    validates_uniqueness_of :player1id, :scope => [:player2id]
    validates_uniqueness_of :player2id, :scope => [:player1id]
end
