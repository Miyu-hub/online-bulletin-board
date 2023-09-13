require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'

require 'open-uri'
require 'sinatra/json'
require 'dotenv'

enable :sessions

before do
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name = ENV['CLOUD_NAME']
        config.api_key = ENV['CLOUDINARY_API_KEY']
        config.api_secret = ENV['CLOUDINARY_API_SECRET']
    end
    
end

get '/' do
    @contents = Contribution.all.order('id desc')
    @categories = Category.all
    erb :index
end

post '/new' do
    img_url = ''
    if params[:file]
        img = params[:file]
        tempfile = img[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        img_url = upload['url']
    end
    
    Contribution.create({
        name: params[:user_name],
        body: params[:body],
        user_id: session[:user],
        category_id: params[:category],
        img: img_url
    })
    
    redirect '/'
end

get '/signin' do
    erb :sign_in
end

get '/signup' do
    erb :sign_up
end

post '/signin' do
    user = User.find_by(mail: params[:mail])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/'
end

post '/signup' do
    user = User.create(mail: params[:mail], password: params[:password],
            password_confirmation: params[:password_confirmation])
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end

post '/category' do
    Category.create(name: params[:category])
    redirect '/'
end

get '/category/:id' do
    @categories = Category.all
    @category = Category.find(params[:id])
    @category_name = @category.name
    @contents = @category.contributions
    erb :index
end

get '/all' do
    @contents = Contribution.all.order('id desc')
    @categories = Category.all
    erb :index
end
post '/delete/:id' do
    Category.find(params[:id]).destroy
    redirect '/'
end

get '/edit/:id' do
    @category = Category.find(params[:id])
    erb :edit
end

post '/renew/:id' do
    category = Category.find(params[:id])
    category.update({
        name:params[:category]
    })
    redirect '/'
end

get '/edit2/:id' do
    @content = Contribution.find(params[:id])
    erb :edit2
end

post '/renew2/:id' do
    content = Contribution.find(params[:id])
    content.update({
        name: params[:title],
        body: params[:body]
    })
    redirect '/'
end

post '/delete2/:id' do
    Contribution.find(params[:id]).destroy
    redirect '/'
end