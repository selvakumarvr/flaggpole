FactoryGirl.define do

  factory :scan do
    sequence(:row_id){ |n| n.to_s }
    quantity 15
    scanned_on Date.yesterday
    association :ncm
  end

  factory :ncm do
    sequence(:ncm_number){ |n| n.to_s }
  end

end