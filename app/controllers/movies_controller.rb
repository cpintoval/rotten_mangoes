class MoviesController < ApplicationController
  def index

    @movies = Movie.all

    if params[:title] != nil && params[:title] != ""
      # @movies = Movie.where(title: params[:title])
      @movies = Movie.title_match(params[:title])
    end

    if params[:director] != nil && params[:director] != ""
      # @movies = Movie.where(director: params[:director])
      @movies = Movie.director_match(params[:director])
    end

    if params[:duration] != nil && params[:duration] != ""
      
      if params[:duration] == "Under 90 minutes"
        # @movies = Movie.where("runtime_in_minutes < 90")
        @movies = Movie.runtime_under_90_minutes
      elsif params[:duration] == "Between 90 and 120 minutes"
        # @movies = Movie.where(runtime_in_minutes: 90..120)
        @movies = Movie.runtime_between_90_and_120_minutes
      else
        # @movies = Movie.where("runtime_in_minutes > 120")
        @movies = Movie.runtime_above_120_minutes
      end 

    end

  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  def search
    render :search
  end

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :poster_image_url, :description
    )
  end
end
