##
# NoACTA Database Handler

module NoACTA
  # Setting up the database
  DataMapper.setup(
    :default, 
    ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/mydatabase.db"
  )
  DataMapper.auto_upgrade!

  class Email
    include DataMapper::Resource
    property :id, Serial
    property :email, String
  end

end #module
