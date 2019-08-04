require 'multi_json'
require 'set'

def work(file)
  filer   = File.new('result.json', 'w')
  @report = { totalUsers: 0, uniqueBrowsersCount: 0, totalSessions: 0, allBrowsers: Set.new, usersStats: {} }
  @user   = ''

  File.foreach(file) do |line|
    cols = line.split(',')
    is_user = cols.first.eql? 'user'
    @user = is_user ? "#{cols[2]} #{cols[3]}" : @user

    make_report(cols, @user, is_user)
  end

  prepare_report
  filer.write"#{MultiJson.dump(@report)}\n"
  filer.close
end

private

def browser_decoration(browsers)
  browsers.map(&:upcase).sort.join(',')
end

def browser(name)
  name.upcase
end

def make_report(cols, user, is_user = false)
  if is_user
    @report[:usersStats][user] = {sessionsCount:    0,
                                 totalTime:        [0, 'min.'],
                                 longestSession:   [0, 'min.'],
                                 browsers:         [],
                                 usedIE:           false,
                                 alwaysUsedChrome: true,
                                 dates:  []}
    @report[:totalUsers] += 1
  elsif cols.first.eql? 'session'
    @report[:totalSessions] += 1
    @report[:allBrowsers].add(browser(cols[3]))

    @report[:usersStats][user][:sessionsCount] += 1
    @report[:usersStats][user][:browsers] << browser(cols[3])
    @report[:usersStats][user][:usedIE] = true if @report[:usersStats][user][:usedIE] || cols[3] =~ /Internet Explorer/
    @report[:usersStats][user][:alwaysUsedChrome] = false if !@report[:usersStats][user][:alwaysUsedChrome] || cols[3] !~ /Chrome/
    @report[:usersStats][user][:dates] << cols[5].chomp
    @report[:usersStats][user][:totalTime][0] += cols[4].to_i
    @report[:usersStats][user][:longestSession][0] = cols[4].to_i if @report[:usersStats][user][:longestSession][0] < cols[4].to_i
  end
end

def prepare_report
  @report[:uniqueBrowsersCount] = @report[:allBrowsers].length
  @report[:allBrowsers]         = browser_decoration(@report[:allBrowsers])

  @report[:usersStats].each_value do |user|
    user[:totalTime]      = user[:totalTime].join(' ')
    user[:browsers]       = user[:browsers].sort.join(', ')
    user[:longestSession] = user[:longestSession].join(' ')
    user[:dates]          = user[:dates].sort.reverse
  end
end

# work('data_large.txt')
# puts "MEMORY USAGE: #{`ps -o rss= -p #{Process.pid}`.to_i / 1024}"
