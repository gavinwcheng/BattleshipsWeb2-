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

  get '/new_board' do
    session[:board] = Board.new(Cell)
    @board = session[:board].print_table
    erb :place_ships
  end

  get '/place_ships' do
    size = session[:size]
    coord = session[:coord]
    direction = session[:direction]
    ship = Ship.new(size)
    session[:board].place(ship, coord, direction)
    @board = session[:board].print_table
    session[:board].ships_count == 2 ? erb(:fire) : erb(:place_ships)
  end

  post '/place_ships' do
    session[:coord] = params[:coord].to_sym
    session[:size] = params[:size].to_i
    session[:direction] = params[:direction].to_sym
    redirect '/place_ships'
  end

  get '/fire' do
    fire = session[:fire]
    session[:board].shoot_at(fire)
    @board = session[:board].print_table
    session[:board].floating_ships? ? erb(:fire) : erb(:final)
  end

  post '/fire' do
    session[:fire] = params[:fire].to_sym
    redirect '/fire'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0

end
