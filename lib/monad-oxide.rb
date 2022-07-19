require_relative './result'
require_relative './err'
require_relative './ok'
require_relative './version'

module MonadOxide
  module_function

  def err(data)
    MonadOxide::Err.new(data)
  end

  def ok(data)
    MonadOxide::Ok.new(data)
  end
end
