require 'benchmark/ips'
require 'set'


Benchmark.ips do |x|
  @str = 'session,0,5,Internet Explorer 35,6,2016-09-01'
  @hash = {:totalUsers=>3, :uniqueBrowsersCount=>14, :totalSessions=>15, :allBrowsers=>"CHROME 13,CHROME 20,CHROME 35,CHROME 6,FIREFOX 12,FIREFOX 32,FIREFOX 47,INTERNET EXPLORER 10,INTERNET EXPLORER 28,INTERNET EXPLORER 35,SAFARI 17,SAFARI 29,SAFARI 39,SAFARI 49", :usersStats=>{"Leida Cira"=>{:sessionsCount=>6, :totalTime=>"455 min.", :longestSession=>"118 min.", :browsers=>"FIREFOX 12, INTERNET EXPLORER 28, INTERNET EXPLORER 28, INTERNET EXPLORER 35, SAFARI 29, SAFARI 39", :usedIE=>true, :alwaysUsedChrome=>false, :dates=>["2017-09-27", "2017-03-28", "2017-02-27", "2016-10-23", "2016-09-15", "2016-09-01"]}, "Palmer Katrina"=>{:sessionsCount=>5, :totalTime=>"218 min.", :longestSession=>"116 min.", :browsers=>"CHROME 13, CHROME 6, FIREFOX 32, INTERNET EXPLORER 10, SAFARI 17", :usedIE=>true, :alwaysUsedChrome=>false, :dates=>["2017-04-29", "2016-12-28", "2016-12-20", "2016-11-11", "2016-10-21"]}, "Gregory Santos"=>{:sessionsCount=>4, :totalTime=>"192 min.", :longestSession=>"85 min.", :browsers=>"CHROME 20, CHROME 35, FIREFOX 47, SAFARI 49", :usedIE=>false, :alwaysUsedChrome=>false, :dates=>["2018-09-21", "2018-02-02", "2017-05-22", "2016-11-25"]}}}
  @st = 'Chrome 21'
  BROWSERS = %w[CHROME INTERNET\ EXPLORER FIREFOX SAFARI].freeze
  s = Set.new
  i = 0

  def b_index
    BROWSERS.rindex(BROWSERS.find{|v| str.upcase.include? v})
  end

  def version
    /(#{browser})\s(\d{1,})/.match[2]
  end

  x.report("<<") do
    i += 1
    s << i
  end

  x.report('add') do
    i += 1
    s.add i
  end

  x.compare!
end
