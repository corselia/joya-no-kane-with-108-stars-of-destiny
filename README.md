# joya-no-kane-with-108-stars-of-destiny
On new year’s eve, automatically tweet 108 stars of destiny from Suikoden series, which is 幻想水滸伝シリーズ in Japanese, as new year’s bell, [JOYA-NO-KANE](https://ja.wikipedia.org/wiki/%E9%99%A4%E5%A4%9C%E3%81%AE%E9%90%98)

# Overview
from December 31th (22:12) to January 1st (00:01), every minute you can tweet 108 stars of destiny from Suikoden automatically as [JOYA-NO-KANE](https://ja.wikipedia.org/wiki/%E9%99%A4%E5%A4%9C%E3%81%AE%E9%90%98).

# Required

```
$ sudo gem install twitter
```

# How to use

### config file
- rewrite sample config to your Twitter app config in `twitter_api_config.rb.sample`
- rename `twitter_api_config.rb.sample` to `twitter_api_config.rb`

### 108 stars of destiny file (csv)
- translate `108_stars_name.csv` into your language
    - default language is Japanese
- column order is below
    - Stars,Suikoden,Suikoden II,Suikoden III,Suikoden IV,Suikoden V,Suikoden Tierkreis(Suikoden Tactics),Suikoden Tsumugareshi
    - header row is nothing

### tweet content
- translate `tweet_content` into your language and modify it
    - default language is Japanese
    - default content is my original, very ordinary one

### set cron
- set cron as below

```
*/1 * * * * username  /usr/bin/ruby /path/joya_no_kane_with_108_stars.rb
```

### initialize
delete `hitting_status` to initialize

# License
[MIT License](/LICENSE)
