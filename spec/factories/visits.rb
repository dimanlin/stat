FactoryBot.define do
  sequence :evid do |n|
    "00000000-0000-0000-0000-00000000000#{n}"
  end

  factory :visit do
    evid { generate :evid }
    vendor_site_id { '209' }
    vendor_visit_id { '134853338' }
    visit_ip { '24.6.5.33' }
    vendor_visitor_id { 'e280af5191b64f18' }
  end

  # def visit_with_page_views(page_views_count: 5)
  #   FactoryBot.create(:visit) do |visit|
  #     FactoryBot.create_list(:post, page_view, page_view: page_view, count: 2)
  #   end
  # end
end