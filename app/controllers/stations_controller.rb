class StationsController < ApplicationController
  def index
    # get a list of all the lines and stations from a JSON file which was converted from CSV format
    line_station_list = JSON.parse(File.read('app/assets/javascripts/convertcsv.json'))

    # minimum stops
    @stops = params[:stops].to_i
    
    # default station
    origin_stations = ["East Ham"]

    # list of processed stations
    processed_stations = []

    # results for the station and line info
    @statition_detail ={}

    i = 0
    while i < @stops  do
      # list of final stations and detail information
      final_to_station_array = []
      statition_detail = {}

      origin_stations.each do | origin_station |
        line_station_list.each do | ls |
          if origin_station == ls["From Station"] ||  origin_station == ls["To Station"]                          
            origin_tube_line = "District"
            updated_tube_lines =""

            unless processed_stations.include?(origin_station) 
              processed_stations.push(origin_station)
            end  
            
            if !processed_stations.include?(ls["To Station"]) && !final_to_station_array.include?(ls["To Station"])
                # puts ls["To Station"]
                updated_tube_lines = update_tube_lines(origin_tube_line, ls['Tube Line'])
                final_to_station_array.push(ls["To Station"])
                statition_detail[ls["To Station"]] = "#{ls['To Station']} (lines = #{updated_tube_lines})"
            end

            if !processed_stations.include?(ls["From Station"]) && !final_to_station_array.include?(ls["From Station"])
                # puts ls["From Station"]
                updated_tube_lines = update_tube_lines(origin_tube_line, ls['Tube Line'])
                final_to_station_array.push(ls["From Station"])
                statition_detail[ls["From Station"]] = "#{ls['From Station']} (lines = #{updated_tube_lines})"
            end
          end
        end
      end

      i +=1

      origin_stations = final_to_station_array
      @statition_detail = Hash[statition_detail.sort]
    end

  end

  def update_tube_lines(origin_tube_line, current_tube_line) 
    updated_tube_lines = current_tube_line == origin_tube_line ? current_tube_line : origin_tube_line + ", " + current_tube_line
  end

end
