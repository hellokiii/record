class Record < ActiveRecord::Base
    require 'csv'
    def self.import(file)
        i=1
        CSV.foreach(file.path, headers: true, encoding:'r:iso-8859-1:utf-8') do |row|
            info = row.to_hash
            info["user_id"] = 5
            if i > Record.count
                Record.create! info
            else
                a = Record.find(i)
                a.attributes = info
                a.save
                i+=1
            end
        end
            # Record.all.each do |e|
            #     e.attributes = row.to_hash
            #     e.save
            # end
    end

    def batter_result
       all_cases = []
       self.attributes.each do |key, value|
          next if key == "selected"
          next if value.to_i > 10000
          value.to_i.times do 
             all_cases << key
          end
       end
       all_cases = all_cases - ["id", "user_id", "steal", "game", "batting_order"]
       return all_cases.sample
    end
end
