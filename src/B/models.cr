require "active_record"
require "sqlite_adapter"

module B
class Transaction < ActiveRecord::Model
  adapter sqlite

  primary id : Int
  field description : String
  field ip : String
  field ua : String
  field amount : Int
  field time : Int

end
end