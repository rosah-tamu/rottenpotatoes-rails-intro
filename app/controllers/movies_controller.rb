class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_by = params[:sort_by] || session[:sort_by]
     #@movies = Movie.all
    @all_ratings = Movie.list_all_values_of_column('rating')
    @ratings = params[:ratings] || session[:ratings]
    @filtered_ratings = []
    
    if @ratings.nil?
      @filtered_ratings = @all_ratings
    else  
      @filtered_ratings = @ratings.keys
    end
    
    @movies = Movie.with_ratings(@filtered_ratings)
    
    if params[:sort_by] != session[:sort_by]
      session[:sort_by] = @sort_by
      flash.keep
      redirect_to :sort_by => @sort_by, :ratings => @ratings and return
    end
    
    if params[:ratings] != session[:ratings] 
      session[:sort_by] = @sort_by
      session[:ratings] = @ratings
      flash.keep
      redirect_to :sort_by => @sort_by, :ratings => @ratings and return
    end

    if @sort_by
      @movies = @movies.order(@sort_by)
      case @sort_by
        when "title"
          @title_header = 'bg-warning'
        when !"title"
          @title_header = 'hilite'
        when "release_date"
          @release_date_header = 'bg-warning'
        when !"release_date"
          @release_date_header = 'hilite'
      end
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
