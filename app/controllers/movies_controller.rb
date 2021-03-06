class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    # Update session if new ratings/sort comes in through params
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    
    if params[:sort]
      session[:sort] = params[:sort]
    end
    
    # Set desired_ratings w/ order of precedence params, session, default
    if params[:ratings]
      @desired_ratings = params[:ratings].keys
    elsif session[:ratings]
      @desired_ratings = session[:ratings].keys
    else
      @desired_ratings = Movie.all_ratings
    end
    
    # Set sort_key w/ order of precedence params, session, default
    if params[:sort]
      sort_key = params[:sort]
    elsif session[:sort] != "" and session[:sort] != nil
      sort_key = session[:sort]
    else
      sort_key = ""
    end
    
    if sort_key == 'title'
      @movies = Movie.where(rating: @desired_ratings).sort_by { |movie| movie.title }
    elsif sort_key == 'rating'
      @movies = Movie.where(rating: @desired_ratings).sort_by { |movie| movie.rating }
    elsif sort_key == 'release_date'
      @movies = Movie.where(rating: @desired_ratings).sort_by { |movie| movie.release_date }
    else
      @movies = Movie.where(rating: @desired_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
