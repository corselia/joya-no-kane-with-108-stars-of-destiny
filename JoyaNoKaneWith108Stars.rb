require 'twitter'
require 'csv'
require './TwitterApiConfig'

class JoyaNoKaneWith108Stars
  include TwitterApiConfig

  HITTING_STATUS_FILENAME = File.expand_path('../hitting_status', __FILE__)
  STARS_NAME_CSV_FILENAME = File.expand_path('../108_stars_name.csv', __FILE__)
  BEGIN_DATETIME  = "2016-12-31 22:11:59"
  FINISH_DATETIME = "2017-01-01 00:01:59"
  TO_HIT_TIMES = 108

  OPENING_TWEET = "ただいまより108星除夜の鐘を撞き始めたいと存じます / キャラの登場作品順は、「幻水I / 幻水II / 幻水III / 幻水IV / 幻水V/ 幻水TK / 幻水紡時」という順となります"
  FINISH_TWEET = "108星の願いとともに！ / 2017年もよろしくお願いいたします"

  # CSV の最終行からツイートを開始し、一行ずつ上の行に進んでいく
  # HACK: スマートに書く（マジックナンバーの撤廃）
  TWEET_CONTENT = "108星除夜の鐘（#{@hitting_times + 1} 回目）: [#{@stars_name_array[107 - @hitting_times][0]}] : #{@stars_name_array[107 - @hitting_times][1]} / #{@stars_name_array[107 - @hitting_times][2]} / #{@stars_name_array[107 - @hitting_times][3]} / #{@stars_name_array[107 - @hitting_times][4]} / #{@stars_name_array[107 - @hitting_times][5]} / #{@stars_name_array[107 - @hitting_times][6]} / #{@stars_name_array[107 - @hitting_times][7]}"

  # 最初から撞き直したい場合は hitting_status ファイルを削除する
  def create_hitting_status_file
    File.open(HITTING_STATUS_FILENAME, "w") do |file|
      file.puts "0" # 撞いた回数
    end unless File.exist?(HITTING_STATUS_FILENAME)
    @hitting_times      = 0
  end

  def update_hitting_status
    @hitting_times += 1
    File.open(HITTING_STATUS_FILENAME, "r+") do |file|
      file.puts "#{updated_status}"
    end
  end

  def judge_to_hit
    begin_datetime  = Time.parse(BEGIN_DATETIME)
    finish_datetime = Time.parse(FINISH_DATETIME)
    now_datetime    = Time.now
    exit(0) if (begin_datetime - now_datetime <= 0) && (now_datetime - finish_datetime >= 0)
    exit(0) if @hitting_times > TO_HIT_TIMES
  end

  def import_stars_name
    @stars_name_array = CSV.read(STARS_NAME_CSV_FILENAME, headers: false)
  end

  def main
    create_hitting_status_file

    judge_to_hit
    import_stars_name
    twitter_api_config

    if @hitting_times == 0
      tweet_content = OPENING_TWEET
    elsif @hitting_times == (TO_HIT_TIMES - 1)
      tweet_content = FINISH_TWEET
    else
      tweet_content = TWEET_CONTENT
    end

    @client.update(tweet_content)
    update_hitting_status
  end
end

joya_no_kane = JoyaNoKaneWith108Stars.new
joya_no_kane.main
