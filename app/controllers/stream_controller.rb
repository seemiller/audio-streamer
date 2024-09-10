require 'net/http'
require 'net/https'

class StreamController < ApplicationController
  def tts
    response.headers['Content-Type'] = 'audio/mpeg'
    text = params[:text]

    begin
      short = 'short Hello, how are you doing today?'
      med =  "medium medium Well, I would do that, and we’re sitting down. You know, I was somebody — we had, Senator Marco Rubio, and my daughter Ivanka, was so impactful on that issue. It’s a very important issue. But I think when you talk about the kind of numbers that I’m talking about — that, because look, child care is child care, couldn’t — you know, there’s something — you have to have it in this country. You have to have it. But when you talk about those numbers, compared to the kind of numbers that I’m talking about by taxing foreign nations at levels that they’re not used to. But they’ll get used to it very quickly. And it’s not going to stop them from doing business with us."
      long =  "long long long Well, I would do that, and we’re sitting down. You know, I was somebody — we had, Senator Marco Rubio, and my daughter Ivanka, was so impactful on that issue. It’s a very important issue. But I think when you talk about the kind of numbers that I’m talking about — that, because look, child care is child care, couldn’t — you know, there’s something — you have to have it in this country. You have to have it. But when you talk about those numbers, compared to the kind of numbers that I’m talking about by taxing foreign nations at levels that they’re not used to. But they’ll get used to it very quickly. And it’s not going to stop them from doing business with us. But they’ll have a very substantial tax when they send product into our country. Those numbers are so much bigger than any numbers that we’re talking about, including child care, that it’s going to take care. We’re going to have — I look forward to having no deficits within a fairly short period of time, coupled with the reductions that I told you about on waste and fraud and all of the other things that are going on in our country. Because I have to stay with child care. I want to stay with child care. But those numbers are small relative to the kind of economic numbers that I’m talking about, including growth, but growth also headed up by what the plan is that I just — that I just told you about. We’re going to be taking in trillions of dollars. And as much as child care is talked about as being expensive, it’s, relatively speaking, not very expensive compared to the kind of numbers will be taking in. We’re going to make this into an incredible country that can afford to take care of its people. And then we’ll worry about the rest of the world. Let’s help other people. But we’re going to take care of our country first. This is about America first. It’s about make America great again. We have to do it because right now, we’re a failing nation. So we’ll take care of it. Thank you. Very good question. Thank you."
      sse_stream_handler(raw: true) do |stream|
        stream_audio(text: med, response_stream: stream)
      end
    rescue => e
      logger.error("Error occurred: #{e.message}")
      response.stream.write(e.message)
    ensure
      response.stream.close
    end
  end

  private

  def stream_audio(text:, response_stream:)
    uri = URI("https://api.elevenlabs.io/v1/text-to-speech/#{ENV.fetch('ELEVENLABS_VOICE_ID')}/stream")

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
      request = Net::HTTP::Post.new(uri)
      request["xi-api-key"] = ENV.fetch("ELEVENLABS_API_KEY")
      request["Content-Type"] = "application/json"
      request.body = { text: text }.to_json

      count = 0
      http.request(request) do |response|
        response.read_body do |chunk|
          p "chunk #{count += 1}"
          response_stream.write chunk
        end
      end
    end
    p "done"
  end
end
