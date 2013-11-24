#encoding: utf-8
require 'sinatra'
require "sinatra/activerecord"
require "thin"

set :database, "sqlite3:///blog.db"
set :bind, '192.168.1.80'
set :port, 90

class User < ActiveRecord::Base
end

class Group < ActiveRecord::Base

end

class Record < ActiveRecord::Base

end

class Group_Member < ActiveRecord::Base

end

class Target < ActiveRecord::Base

end

class Subproblem < ActiveRecord::Base

end

class Problem <ActiveRecord::Base

end

class Problem_group < ActiveRecord::Base

end

class Worker < ActiveRecord::Base

end

class Calendar < ActiveRecord::Base

end

class Friend < ActiveRecord::Base

end

enable :sessions
set :session_secret, "My session secret"
#use Rack::Session::Cookie, :key => 'rack.session',
#    :domain => 'localhost',
#    :path => '/',
#    :expire_after => 2592000, # In seconds
#    :secret => '123'

get "/" do

  erb :"main"
end

get "/register" do
  erb :"register"
end

post "/register" do
  p params
  email_check = User.find(:first, :conditions => [ "email = ?", params['email']])
  name_check = User.find(:first, :conditions => ["login = ?", params['login']])
  if(email_check.nil? && name_check.nil?)
    result = User.create(login: params["login"], name: params["name"], email: params["email"], password: params["password"], info: params["info"])
    Calendar.create(user_id: result.id)
    p result
    @thanks = "Благодарим за регистрацию в системе"
    erb :Thanks
  else
    if(email_check.nil?)
      @errors = "Такой e-mail уже существует"
      erb :Error
    else
      @errors = "Такой логин уже существует"
      erb :Error
    end
  end
end

get "/auth" do
  erb :auth
end

post "/auth" do
  result = User.find(:first, :conditions => ["email = ? and password = ?", params["email"], params["password"]])
  if !result.nil?
    session[:user]=result
    p result
    p session[:user]
    @thanks = "Поздравляем с успешной авторизацией"
    erb :Thanks
  else
    @errors = "Email и Пароль не совпадают с уже имеющимися"
    erb :Error
  end
end


get "/users/:id" do
  p params["splat"]
  @user = User.find(params[:id])
  @title = @user.name
  erb :"users/show"
end

get "/users*" do
  @users = User.order("created_at DESC")
  erb :"users/index"
end

get '/friends' do
  @friends = Friend.where(user_id: session[:user].id).map{|connection| User.find_by(id:connection.friend_id)}
  erb :"friends/main"
end

get '/friends/add' do
  if(session[:user].id)
    p session[:user]
    @friends = Friend.where(user_id: session[:user].id)
    @users = User.all
    p @users
    erb :"friends/all"
  else
    redirect('/auth')
  end
end

get '/friends/add/:friend_id' do
  Friend.create(user_id:session[:user].id, friend_id:params[:friend_id])
  @thanks = "Пользователь успешно добавлен"
  erb :Thanks
end

get '/friends/remove/:friend_id' do
  friend = Friend.delete_all(["user_id = ? and friend_id = ?", session[:user].id, params[:friend_id]])
  p friend

  @thanks = "Удаление пользователя"
  erb :Thanks
end

get '/groups' do
  @groups = Group_Member.where(user_id:session[:user].id).map{|group| Group.find_by(id:group.group_id)}
  erb :"groups/index"
end

get '/groups/new' do
  if(session[:user])
    @user = session[:user]
    @friends = Friend.where(user_id:session[:user].id).map{|friend| User.find_by(id: friend.friend_id)}
    erb :"groups/new"
  end
end

post '/groups/new' do
  if(session[:user])
    result = Group.create(name:params["name"], author_id:session[:user].id)
    params["users"].each{|user|
      Group_Member.create(group_id:result.id,user_id:user,is_leader:0)
    }
    Group_Member.create(group_id:result.id,user_id:session[:user].id,is_leader:1)
    @thanks = "Спасибо за создание группы"
    erb :Thanks
  end
end

get '/groups/:id' do
  if(session[:user])
    @group = Group.find_by(id:params[:id])
    @members = Group_Member.where(group_id:params["id"]).map{|member| User.find_by(id:member.user_id)}
    erb :"groups/show"
  end

end

get '/problems' do
  if(session[:user])
    @problems = Worker.where(user_id:session[:user].id).map{|problem| Problem.find_by(id:problem.problem_id)}
    erb :"problems/index"
  end

  #p session[:user]
end

get '/problems/new' do
  if(session[:user])
    erb :"problems/new"
  end

end

post '/problems/new' do
  if(session[:user])
    date = DateTime.parse(params["end_date"])
    @problem = Problem.create(end_date:params["end_date"],name:params["name"],difficulty:params["difficulty"])
    p @problem
    p @problem.id
    p session[:user].id
    Worker.create(user_id: session[:user].id, problem_id: @problem.id)
    @thanks = "Создание задачи"
    erb :Thanks
  else
    redirect('auth')

  end
end

get '/problems/delete/:id' do
  if(session[:user])
    Worker.delete_all(["problem_id = ?",params["id"]])
    Problem.find_by(id:params["id"]).destroy

    @thanks = "Удаление задачи"
    erb :Thanks
  end
end

post '/problems/update/:id' do
  if(session[:user])
    Worker.upda
  end
end

helpers do
  def title
    if @title
      "#{@title} -- Scheduler"
    else
      "Scheduler"
    end
  end

  def controller
    request.path_info.split("/")[1]
  end
  def pretty_date(time)
    time.strftime("%d %b %Y")
  end

end
