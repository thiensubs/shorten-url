if defined?(Mongoid)
  # GlobalID is used by ActiveJob (among other things)
  # https://github.com/rails/globalid
  Mongoid::Document.include GlobalID::Identification
  Mongoid::Association::Proxy.include GlobalID::Identification
end
