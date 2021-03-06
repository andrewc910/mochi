require "../../spec_helper"
require "http/request"

describe Mochi::Models::Trackable do
  USER_CLASSES.each do |user_class|
    it "should update tracked fields" do
      user = user_class.build
      request = HTTP::Request.new("get", "/")

      # TODO: Find better way of creating a request with an IP address
      # request.remote_address = "127.0.98.15"

      user.update_tracked_fields(request)

      user.sign_in_count.should eq(1)
      # user.last_sign_in_ip.should eq("127.0.98.15")
      user.last_sign_in_ip.should eq(user.current_sign_in_ip)
      user.last_sign_in_at.should eq(user.current_sign_in_at)

      # request.remote_address = "127.0.98.16"
      sleep(1) # Tests go too fast. Time will be identical without sleep
      user.update_tracked_fields(request)
      user.sign_in_count.should eq(2)
      # user.last_sign_in_ip.should eq("127.0.98.15")
      # user.current_sign_in_ip.should eq("127.0.98.16")
      user.last_sign_in_at.should_not eq(user.current_sign_in_at)
    end
  end
end
