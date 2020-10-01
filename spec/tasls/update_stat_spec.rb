require "rails_helper"

Rails.application.load_tasks

describe "update_stat" do
  context "WebMock enable" do
    let(:fake_server_host) { URI.parse(ENV['FAKE_SERVER_HOST']).host }
    let(:fake_server_port) { URI.parse(ENV['FAKE_SERVER_HOST']).port }

    it "create instance VisitKeeperService" do
      file_path = File.join("spec", "examples", "fake_server_response.json")

      stub_request(:get, ENV['FAKE_SERVER_HOST']).
        with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Host" => "#{fake_server_host}:#{fake_server_port}",
            "User-Agent" => "Ruby"
          }
        ).to_return(status: 200, body: File.open(file_path).read, headers: {})

      expect_any_instance_of(VisitKeeperService).to receive(:call)

      Rake::Task["update_statistics"].invoke
    end
  end
end