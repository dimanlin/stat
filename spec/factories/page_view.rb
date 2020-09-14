FactoryBot.define do
  sequence :title do |n|
    "Title #{n}"
  end

  sequence :position do |n|
    n
  end

  factory :page_view do
    title { generate :title }
    url { 'http://example.com' }
    time_spent { '50' }
    timestamp { '1537623579' }
  end
end