# Description:
#   What's soup does Panera Bread have today?
#
# Dependencies:
#   "cheerio": "0.12.x"
#   "moment": "2.0.x"
#
# Commands:
#   hubot panera - Pulls the soup Panera Bread has today
#   hubot panerabread - Pulls the soup Panera Bread has today
#
# Author:
#   jonursenbach

cheerio = require 'cheerio'
moment = require 'moment'

baseUrl = 'https://www.panerabread.com'
today = moment().format('dddd').toLowerCase()

module.exports = (robot) =>
  robot.respond /panera(bread)?$/i, (msg) ->
    msg.http(baseUrl + '/content/panerabread/en_us/lookups/tabs/soups-' + today + '.tabview.html')
      .get() (err, res, body) ->
        return msg.send "Sorry, Panera bread doesn't like you. ERROR:#{err}" if err
        return msg.send "Unable to get today's soup: #{res.statusCode + ':\n' + body}" if res.statusCode != 200

        $ = cheerio.load(body)

        emit = 'Today\'s Panera Bread soups are:' + "\n";
        soups = []

        for article in $('article:not(.promo-tile)')
            soups.push(' · ' + $(article).find('.item-name').text())

        emit += soups.join("\n")

        msg.send emit;
