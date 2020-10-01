require 'net/http'

desc 'Update statistics'
task :update_statistics => :environment do
 begin
   escaped_address = URI.escape(ENV.fetch('FAKE_SERVER_HOST'))
   uri = URI.parse(escaped_address)
   response = Net::HTTP.get(uri)
   visits = JSON.parse(response)
   VisitKeeperService.new(visits).call
 rescue Exception => e
   puts e
   Rails.logger.fatal e
 end
end
