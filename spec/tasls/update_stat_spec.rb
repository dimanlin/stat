require "rails_helper"

Rails.application.load_tasks

describe "update_stat" do
  context "WebMock enable" do
    it "create instance VisitKeeperService" do
      file_path = File.join("spec", "examples", "fake_server_response.json")

      stub_request(:get, "http://127.0.0.1:4567/samples/api_response.json").
        with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Host" => "127.0.0.1:4567",
            "User-Agent" => "Ruby"
          }
        ).to_return(status: 200, body: File.open(file_path).read, headers: {})

      expect_any_instance_of(VisitKeeperService).to receive(:call)

      Rake::Task["update_statistics"].invoke
    end
  end
end