desc 'Update statistics'
task :update_statistics => :environment do
  uri = URI('http://127.0.0.1:4567/samples/api_response.json')

  begin
    response = Net::HTTP.get(uri)
    visits = JSON.parse(response)
    VisitKeeperService.new(visits).call
  rescue Exception => e
    Rails.logger.fatal e
  end

end
