require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Test Comment
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
end
