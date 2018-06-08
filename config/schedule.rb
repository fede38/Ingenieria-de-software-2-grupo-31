require 'rubygems'
require 'whenever'

set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}
env :PATH, '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'

#every 1.minutes do
#  runner "User.proceso", :environment => :development
#end
