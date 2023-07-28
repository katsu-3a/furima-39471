FactoryBot.define do
  factory :order_form do
    association :user
    association :item
    postcode { '123-4567' }
    prefecture_id { 1 }
    city { '横浜市' }
    block { '旭町1-1-1' }
    building{'ハイツ'}
    phone_number { '12345678910' }
    token { 'tok_abcdefghijk00000000000000000' }
    
  end
end