require 'sinatra/base'
require_relative 'board'

class Battle_ship_september < Sinatra::Base

  enable :sessions

  set :views, proc { File.join(root, '..', 'views')}

  get '/' do
    erb :index
  end

  get '/new_player' do
    @player = session[:name]
    erb :new_player
  end

  post '/new_player' do
    session[:name] = params[:name]
    redirect '/new_player'
  end

  get '/place_ships' do
    session[:board] = Board.new(Cell) if session[:board].nil?
    if session[:size] && session[:coord] && session[:direction]
      @size = session[:size].to_i
      @coord = session[:coord].to_sym
      @direction = session[:direction].to_sym
      @ship = Ship.new(@size) if @size
      session[:board].place(@ship, @coord, @direction)
    end
    @board = session[:board]
    @grid = @board.print_table
    erb :place_ships
  end

  post '/place_ships' do
    session[:coord] = params[:coord]
    session[:size] = params[:size]
    session[:direction] = params[:direction]
    redirect '/place_ships'
  end

  get '/start_the_game' do
    if params[:coordinate].nil?
      erb :start_the_game
    else
      p params
      @coord = params[:coordinate].to_sym
      $board.shoot_at(@coord)
      erb :start_the_game
    end
  end



  # start the server if ruby file executed directly
  run! if app_file == $0

end
