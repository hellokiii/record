class HomeController < ApplicationController

  
  @@advance = {"baseonballs": [1],
             "hbp": [1],
             "single": [0,1],
             "double": [1,0],
             "triple": [1,0,0],
             "homerun": [1,0,0,0],
             "pb": [0]
            }
  @@inning = 1
  @@batter_num = 0
  @@result = Array.new
  @@juja = Array.new
  @@run = 0

  def index
    simulation
  end
  
  def upload
    Record.import(params[:csv_file])
    redirect_to '/home/index', notice: "완료!"
  end
  
  def simul
    @@result = []
    @@juja = []
    @@inning = 1
    @@batter_num = 0
    redirect_to '/home/simulation'
  end
  
  def simulation
    out = 0
    @@result << @@inning.to_s + "이닝"
    while out < 3
      Record.all.each do |r|
        @@batter_num += 1
        @@batter_num = 1 if @@batter_num > 9
        result_of_the_batter = r.batter_result
        @@result << @@batter_num.to_s + "번타자 " + Record.find(@@batter_num).name + ": " + result_of_the_batter
        if result_of_the_batter == "strikeout"
          out += 1
        elsif result_of_the_batter == "pb"
          out += 1
          if out == 3
            @@inning += 1
            break
          end
          @@juja += @@advance[result_of_the_batter.to_sym]
        else
          @@juja += @@advance[result_of_the_batter.to_sym]
        end
        if out == 3
          @@inning += 1
          break
        end
      end
    end
    @juja = @@juja
    @result = @@result
    leftonbase = @@juja.last(3)
    @scorerunner = @@juja.count(1) - leftonbase.count(1)
  end
  
  def five_inning
    @@result = []
    5.times do
      simulation
      @@result << @scorerunner.to_s + " 점"
      @@result << ""
      @@run += @scorerunner
      @@juja = []
    end
      @result = @@result
      @run = @@run
      @@inning = 1
      @@batter_num = 0
      @@run = 0
  end
  
  
  def average
    @sum = 0.to_f
    1000.times do
      five_inning
      @sum += @run
    end
    
  end
  
end
