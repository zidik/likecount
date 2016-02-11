module Enumerable
  def every_nth(n)
    (0... self.length).select{ |x| x%n == n-1 }.map { |y| self[y] }
  end
end 

require 'open-uri'
class ResultsController < ApplicationController
  before_action :set_result, only: [:show, :edit, :update, :destroy]

  def get_new_results
    url = 'http://koorikampaania.postimees.ee/helpers/getCompetitors.php'
    buffer = open(URI.encode(url)).read
    response = JSON(buffer)
    response.map{|x| {
        name: x["header"],
        likes: x["likes"]}
    }
  end
  def save_results
    get_new_results.map{|r| Result.create(r)}
    redirect_to results_url
  end
  # GET /results
  # GET /results.json
  def index
    @results = Result.all

  end

  def likes
    today = Result.where(created_at: (Time.now - 1.day)..Time.now).group_by(&:name)
    all = Result.all.group_by(&:name)
    @today_graph = []
    @all_graph = []     
    today.each{|k,v| @today_graph.append({name: k, data: v.every_nth(v.count/100+1).map{|r| [r[:created_at], r[:likes]]}.to_h })}
    all  .each{|k,v| @all_graph  .append({name: k, data: v.every_nth(v.count/100+1).map{|r| [r[:created_at], r[:likes]]}.to_h })}
  end


  # GET /results/1
  # GET /results/1.json
  def show
  end

  # GET /results/new
  def new
    @result = Result.new(get_new_results[0])
  end

  # GET /results/1/edit
  def edit
  end

  # POST /results
  # POST /results.json
  def create
    @result = Result.new(result_params)

    respond_to do |format|
      if @result.save
        format.html { redirect_to @result, notice: 'Result was successfully created.' }
        format.json { render :show, status: :created, location: @result }
      else
        format.html { render :new }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /results/1
  # PATCH/PUT /results/1.json
  def update
    respond_to do |format|
      if @result.update(result_params)
        format.html { redirect_to @result, notice: 'Result was successfully updated.' }
        format.json { render :show, status: :ok, location: @result }
      else
        format.html { render :edit }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result.destroy
    respond_to do |format|
      format.html { redirect_to results_url, notice: 'Result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_result
      @result = Result.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(:name, :likes)
    end
end
