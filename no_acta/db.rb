module NoACTA
  ##
  # NoACTA Database Handler
  module DB

    # Setting up the database
    def self.setup()
      DataMapper.setup(
        :default, 
        ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/mydatabase.db"
      )
      DataMapper.auto_upgrade!
    end

    class Email
      include DataMapper::Resource
      property :id, Serial
      property :email, String
    end

  end #module
end #module
