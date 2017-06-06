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
  
  def check
    Record.all.each do |r|
      r.selected = false
      r.batting_order = 0
      r.save
    end
    the_selected = params[:lineup]
    lineup = the_selected.split('"') - ["[", ",", "]"]
    lineup.each do |l|
      a = Record.where(name: l).take
      a.batting_order = lineup.index(l) + 1
      a.selected = true
      a.save
    end
    redirect_to '/home/lineup'
  end
  
  def lineup
    choose_batters
    @picked = Record.where(selected: true).order(batting_order: :asc)
  end
  
  
  def upload
    Record.import(params[:csv_file])
    redirect_to '/home/choose', notice: "완료!"
  end
  
  def simul
    @@result = []
    @@juja = []
    @@inning = 1
    @@batter_num = 0
    redirect_to '/home/simulation'
  end
  
  def simulation
    choose_batters
    out = 0
    @@result << @@inning.to_s + "이닝"
    while out < 3 do
      Record.where(selected: true).order(batting_order: :asc).each do |r| #선택된 타자들 타순으로
        result_of_the_batter = r.batter_result #랜덤으로 타석 결과 뽑기
        @@result << r.batting_order.to_s + "번타자 " + r.name + ": " + result_of_the_batter
        if result_of_the_batter == "strikeout"
          out += 1      #삼진이면 아웃카운트만 하나 올리기
        elsif result_of_the_batter == "pb"
          out += 1     #범타면 아웃카운트 하나 올리기
          if out == 3
            @@inning += 1
            break
          end
          @@juja += @@advance[result_of_the_batter.to_sym] #3아웃이면 다음이닝, 아니면 주자 진루
        else
          @@juja += @@advance[result_of_the_batter.to_sym]  #나머지는 타석결과에 따라 주자 진루
        end
        if out == 3
          @@inning += 1
          break
        end  #3아웃이면 다음이닝
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
  
  def choose
    @all_players = Record.all
  end
end
