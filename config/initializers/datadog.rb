Datadog.configure do |c|
  c.service = 'rails-performance-book'
  c.env = Rails.env

  c.tracing.test_mode.enabled = (Rails.env == 'test')
end
