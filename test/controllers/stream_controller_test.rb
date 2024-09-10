require "test_helper"

class StreamControllerTest < ActionDispatch::IntegrationTest
  test "should get tts" do
    get stream_tts_url
    assert_response :success
  end
end
