class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      if params[:ratings] != nil
        ratings = params[:ratings].keys
      elsif params[:G] != nil || params[:PG] != nil || params[:R] != nil || params["PG-13"] != nil
        ratings = []
        if params[:G] != nil
          ratings << "G"
        end
        if params[:PG] != nil
          ratings << "PG"
        end
        if params[:R] != nil
          ratings << "R"
        end
        if params["PG-13"] != nil
          ratings << "PG-13"
        end
      else
        ratings = Movie.all_ratings
      end
      if params.key?("mt")
        sortstring = "title"
        session[:sort] = "title"
      elsif params.key?("rd")
        sortstring = "release_date"
        session[:sort] = "release_date"
      else
        sortstring = params[:sort]
        
      end
      if params[:home] == nil && !(params[:ratings] != nil ||
        params[:G] != nil || params[:PG] != nil || params[:R] != nil || params["PG-13"] != nil ||
        params.key?("mt") || params.key?("rd") || params[:sort] != nil)
        ratings = session[:ratings]
        sortstring = session[:sort]
      end
      session[:sort] = sortstring
      session[:ratings] = ratings
      if sortstring == "title"
        @title_header = true
        @date_header = false
      elsif sortstring == "release_date"
        @title_header = false
        @date_header = true
      else
        @title_header = false
        @date_header = false
      end
      @movies = Movie.with_ratings(ratings).order(sortstring)
      @ratings_to_show = ratings
      @ratings_to_show_hash = ratings.to_h {|key| [key, 1]}
      @all_ratings = Movie.all_ratings
      @sort = sortstring
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