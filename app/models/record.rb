class Record < ActiveRecord::Base
   require 'csv'
   def self.import(file)
      CSV.foreach(file.path, headers: true, encoding:'r:iso-8859-1:utf-8') do |row|
         Record.create! row.to_hash
      end
   end
   
   
   def batter_result
      all_cases = Array.new
      
      self.attributes.each do |key, value|
         next if value.to_i > 10000
         value.to_i.times do 
            all_cases << key
         end
      end
      all_cases = all_cases - ["id", "user_id", "steal", "game"]
      return all_cases.sample
   end
   
   
end
