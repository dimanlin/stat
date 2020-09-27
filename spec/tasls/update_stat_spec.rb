require "rails_helper"

Rails.application.load_tasks

describe "update_stat" do
  it "raise " do
    expect(Net::HTTP).to receive(:get).and_raise
    expect(Rails.logger).to receive(:fatal).with(RuntimeError)
    Rake::Task["update_statistics"].invoke
  end
end