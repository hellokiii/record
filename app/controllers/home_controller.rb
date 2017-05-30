class HomeController < ApplicationController

  @@advance = {"baseonballs": [1],
             "hbp": [1],
             "single": [0,1],
             "double": [1,0],
             "triple": [1,0,0],
             "homerun": [1,0,0,0],
             "pb": [0]
            }

  def index
    simulation
  end
  
  def upload
    Record.import(params[:csv_file])
    redirect_to '/home/index', notice: "완료!"
  end
  
  def simulation
    out = 0
    batter_num = 0
    juja = Array.new
    @result = Array.new
    while out < 3
      Record.all.each do |r|
        batter_num += 1
        batter_num = 1 if batter_num > 9
        result_of_the_batter = r.batter_result
        @result << batter_num.to_s + "번타자 " + Record.find(batter_num).name + ": " + result_of_the_batter
        if result_of_the_batter == "strikeout"
          out += 1
        elsif result_of_the_batter == "pb"
          out += 1
          break if out == 3
          juja += @@advance[result_of_the_batter.to_sym]
        else
          juja += @@advance[result_of_the_batter.to_sym]
        end
        break if out == 3
      end
    end
    @juja = juja
    leftonbase = juja.last(3)
    @scorerunner = juja.count(1) - leftonbase.count(1)
    
  end
end
