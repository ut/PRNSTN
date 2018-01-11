require 'sqlite3'
require 'active_record'


puts "... script is running in #{$env} mode"


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => "prnstn-#{$env}.db"
)

class Message < ActiveRecord::Base

   validates :sid, presence: true, uniqueness: true
   validates :title, presence: true

end

ActiveRecord::Schema.define do
  if ActiveRecord::Base.connection.data_sources.include? 'messages'
    puts '... database and table "messages" already set'
  else
    puts '... database available, creating table "messages"'
    create_table :messages do |table|
      table.column :sid,      :string
      table.column :title,    :string
      table.column :body,     :text
      table.column :imageurl, :string
      table.column :date,     :timestamp
      table.column :queued,   :boolean
      table.column :printed,   :boolean
    end
  end
end
