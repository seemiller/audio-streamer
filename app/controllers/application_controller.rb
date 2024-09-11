class ApplicationController < ActionController::API

  private

  def sse_stream_handler(handler = nil, raw: false, content_type: 'text/event-stream')
    request.env['rack.hijack'].call
    stream = request.env['rack.hijack_io']
    send_sse_headers(stream: stream, content_type: content_type)

    # Give the option to send raw messages or have a formatter for SSEs
    sse_stream = raw ? stream : ActionController::Live::SSE.new(stream, retry: 300)
    Thread.new do
      yield(sse_stream) if block_given?
      send(handler, sse_stream) if handler.present?
    ensure
      sse_stream.close
    end

    response.close
  end

  def send_sse_headers(stream:, content_type:)
    headers = [
      'HTTP/2.0 200 OK',
      "Content-Type: #{content_type}"
    ]
    stream.write(headers.map { |header| "#{header}\r\n" }.join)
    stream.write("\r\n")
    stream.flush
  rescue
    stream.close
    raise
  end
end
