require 'rails_helper'

RSpec.describe VisitKeeperService do

  let(:visits) do
    file_path = File.join('spec', 'examples', 'fake_server_response.json')
    JSON.parse(File.open(file_path).read)
  end

  describe 'remove all records from DB when create instance' do
    before do
      @visit = FactoryBot.create(:visit)
      FactoryBot.create(:page_view, visit_id: @visit.id)
    end

    it 'return 0 records' do
      expect { VisitKeeperService.new([]) }.to change { PageView.count }.from(1).to(0)
    end

    it 'return 0 records' do
      expect { VisitKeeperService.new([]) }.to change { Visit.count }.from(1).to(0)
    end
  end

  describe '#method call' do
    let(:visit_keeper_service) { VisitKeeperService.new([]) }

    after do
      visit_keeper_service.call
    end

    it 'exec method save_visits' do
      expect(visit_keeper_service).to receive(:save_visits).and_return(true)
    end

    it 'exec method save_page_views' do
      expect(visit_keeper_service).to receive(:save_page_views).and_return(true)
    end
  end

  describe '#next_auto_increment' do
    context 'Model Visit have rows' do
      it 'return id next element' do
        FactoryBot.create(:visit)
        expect(VisitKeeperService.new([]).send(:next_auto_increment) > 0).to be_truthy
      end
    end

    context "Model Visit dos't have rows" do
      it 'return id next element' do
        expect(VisitKeeperService.new([]).send(:next_auto_increment) > 0).to be_truthy
      end
    end
  end

  describe '#prepare_visits' do
    let(:valid_referrer_names) { ["966634dc-0bf6-1ff7-f4b6-08000c95c670",
                                  "3385a27a-cc20-8d98-940a-37dad5a93133"] }

    it 'should remove "evid_" from referrerName and check match on regexp' do
      expect(VisitKeeperService.new(visits).visits.map {|visit| visit['referrerName']}).to eq(valid_referrer_names)
    end
  end

  describe '#save_visit' do
    it 'should create only 2 visits' do
      expect do
        VisitKeeperService.new(visits).call
      end.to change { Visit.count }.from(0).to(2)
    end
  end

  describe '#save_page_views' do
    it 'should create only 2 visits' do
      expect do
        VisitKeeperService.new(visits).call
      end.to change { PageView.count }.from(0).to(15)
    end
  end

  describe 'Position field' do
    it 'should be correct filling' do
      VisitKeeperService.new(visits).call

      expect(Visit.last.page_views.pluck(:position)).to eq((1..5).to_a)
      expect(Visit.first.page_views.pluck(:position)).to eq((1..10).to_a)
    end
  end
end