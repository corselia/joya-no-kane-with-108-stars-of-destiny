require 'twitter'
require 'csv'
require File.expand_path('../twitter_api_config', __FILE__)

HITTING_STATUS_FILENAME = File.expand_path('../hitting_status', __FILE__)
STARS_NAME_CSV_FILENAME = File.expand_path('../108_stars_name.csv', __FILE__)
BEGIN_DAYTIME  = "2016-12-31 22:11:59"
FINISH_DAYTIME = "2017-01-01 00:01:59"
TO_HIT_TIMES = 108

# 最初から撞き直したい場合は hitting_times を削除する
def existence_check_hitting_status_file
  if !File.exist?(HITTING_STATUS_FILENAME)
    File.open(HITTING_STATUS_FILENAME, "w") do |f|
      f.puts "0,0" # "撞いた回数,開始ツイート済フラグ"
    end
  end
end

def read_hitting_status
  existence_check_hitting_status_file
  hitting_status = CSV.read(HITTING_STATUS_FILENAME, headers: false)
  @hitting_times = hitting_status[0][0].to_i
  @opening_tweet_done = hitting_status[0][1].to_i
end

def modify_hitting_status
  if @hitting_times == 0 and @opening_tweet_done == 0
    modified_status = "#{@hitting_times},1"
  else
    modified_status = "#{@hitting_times + 1},1"
  end

  File.open(HITTING_STATUS_FILENAME, "r+") do |f|
    f.puts "#{modified_status}"
  end
end

def whether_tweet_or_not
  hit_begin_daytime  = Time.parse(BEGIN_DAYTIME)
  hit_finish_daytime = Time.parse(FINISH_DAYTIME)
  now_daytime        = Time.now

  exit(0) if !(check_deadline(hit_begin_daytime, now_daytime) and check_deadline(now_daytime, hit_finish_daytime))
  exit(0) if @hitting_times > TO_HIT_TIMES
end

def check_deadline(from_datetime, to_datetime)
  diff_datetime = to_datetime - from_datetime
  return diff_datetime >= 0 ? true : false
end

def stars_name_import
  @csv_data = CSV.read(STARS_NAME_CSV_FILENAME, headers: false)
end

def main
  read_hitting_status
  whether_tweet_or_not

  stars_name_import
  twitter_api_config
  if @hitting_times == 0 and @opening_tweet_done == 0
    tweet_content = "ただいまより108星除夜の鐘を撞き始めたいと存じます / キャラの登場作品順は、「幻水I / 幻水II / 幻水III / 幻水IV / 幻水V/ 幻水TK / 幻水紡時」という順となります"
  elsif @hitting_times == TO_HIT_TIMES
    tweet_content = "108星の願いとともに！ / 2017年もよろしくお願いいたします"
  else
    # 幻水I,幻水II,幻水III,幻水IV,幻水V,TK,紡時
    tweet_content = "108星除夜の鐘（#{@hitting_times + 1} 回目）: [#{@csv_data[107 - @hitting_times][0]}] : #{@csv_data[107 - @hitting_times][1]} / #{@csv_data[107 - @hitting_times][2]} / #{@csv_data[107 - @hitting_times][3]} / #{@csv_data[107 - @hitting_times][4]} / #{@csv_data[107 - @hitting_times][5]} / #{@csv_data[107 - @hitting_times][6]} / #{@csv_data[107 - @hitting_times][7]}"
  end

  @client.update(tweet_content)
  puts tweet_content

  modify_hitting_status
end

main
