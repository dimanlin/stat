class VisitKeeperService

  REFERRER_NAME_REG = /\A[A-z0-9]{8}-[A-z0-9]{4}-[A-z0-9]{4}-[A-z0-9]{4}-[A-z0-9]{12}\z/

  attr_reader :visits

  def initialize(visits)
    Visit.delete_all
    PageView.delete_all

    @visits = prepare_visits(visits)
    @next_visit_id = next_auto_increment
  end

  def call
    save_visits
    save_page_views
  end

  private

  # Find next auto_increment (id)
  def next_auto_increment
    if Visit.count > 0
      Visit.last.id + 1
    else
      tmp_visit = Visit.create(evid: '00000000-0000-0000-0000-000000000000')
      auto_increment = tmp_visit.id + 1
      tmp_visit.delete
      auto_increment
    end
  end

  def prepare_visits(visits)
    visits.collect! do |visit|
      visit['referrerName'].gsub!('evid_', '')
      visit
    end

    visits.select { |visit| REFERRER_NAME_REG.match?(visit['referrerName']) }
  end

  def save_visits
    hash_visits = []

    @visits.each do |visit|
      current_time = Time.current
      hash_visits << {  evid: visit['referrerName'].gsub('evid_', ''),
                        vendor_site_id: visit['idSite'],
                        vendor_visit_id: visit['idVisit'],
                        visit_ip: visit['visitIp'],
                        vendor_visitor_id: visit['visitorId'],
                        created_at: current_time,
                        updated_at: current_time}

    end

    hash_visits.present? ? Visit.insert_all(hash_visits) : false
  end

  def save_page_views
    page_views = []
    @visits.each_with_index do |visit, index|
      visit['actionDetails'].uniq.each_with_index do |page_view, index|
        current_time = Time.current
        page_views << {  visit_id: @next_visit_id + index,
                         title: page_view['pageTitle'],
                         url: page_view['url'],
                         position: index + 1,
                         time_spent: page_view['timeSpent'],
                         timestamp: page_view['timestamp'],
                         created_at: current_time,
                         updated_at: current_time }
      end
    end

    page_views.present? ? PageView.insert_all(page_views) : false
  end
end