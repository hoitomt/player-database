FactoryGirl.define do
  factory :box_score do
    player
    game
    one_point_attempt 1
    two_point_attempt 1
    three_point_attempt 1
    one_point_make 1
    two_point_make 1
    three_point_make 1
    turnovers 1
    assists 1
    fouls 1
    rebounds 1
  end

end
